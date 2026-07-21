import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifeos/core/services/notification_tap_dispatcher.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Reserved seam for scheduling OS-level (system) notifications. See
/// docs/background_services_plan.md for the full background-work
/// architecture this sits in
/// (`NotificationEngine → NotificationScheduler → flutter_local_notifications`).
/// The NotificationEngine persists in-app feed entries independently of
/// this — this scaffold is only for the system-notification half.
abstract interface class NotificationScheduler {
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> cancel(String id);

  /// Posts (or updates in place, since [id] addresses the same underlying
  /// Android notification either way) a persistent, silent, non-dismissable
  /// notification showing a live OS-rendered countdown to [countdownTo] —
  /// used for the Focus "session in progress" notification. This is
  /// display-only: it never schedules a completion alarm itself (that
  /// remains [scheduleAt]'s job) and never becomes a timing source of
  /// truth — the countdown is Android's own Chronometer view rendering
  /// [countdownTo], not anything this app ticks.
  ///
  /// [showPauseAction]/[showResumeAction]/[showEndAction] control which
  /// notification actions appear — the caller decides based on the
  /// session's actual persisted status (e.g. don't show "Pause" on an
  /// already-paused session), so this stays a pure display call with no
  /// session-state knowledge of its own. Actions are delivered back through
  /// [NotificationTapDispatcher] the same way a tap is, prefixed
  /// `action:<actionId>:` ahead of the normal payload — see
  /// `focus_action_entrypoint.dart`.
  Future<void> showOngoing({
    required String id,
    required String title,
    required String body,
    required DateTime countdownTo,
    bool showPauseAction = false,
    bool showResumeAction = false,
    bool showEndAction = false,
  });

  /// Removes a notification previously posted by [showOngoing]. Safe to
  /// call even if nothing is currently showing for [id].
  Future<void> cancelOngoing(String id);
}

class NoopNotificationScheduler implements NotificationScheduler {
  const NoopNotificationScheduler();

  @override
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<void> cancel(String id) async {}

  @override
  Future<void> showOngoing({
    required String id,
    required String title,
    required String body,
    required DateTime countdownTo,
    bool showPauseAction = false,
    bool showResumeAction = false,
    bool showEndAction = false,
  }) async {}

  @override
  Future<void> cancelOngoing(String id) async {}
}

/// Android-first real implementation, backed by `flutter_local_notifications`
/// + `timezone` for correctly zoned exact-alarm scheduling. iOS/other
/// platforms are left to the plugin's own per-platform no-ops until a
/// dedicated iOS pass — the interface is platform-agnostic so that's a
/// later addition behind this same seam, not a redesign.
///
/// `flutter_local_notifications` addresses notifications by a 32-bit `int`,
/// but every call site in this app (repositories, [NotificationEngine])
/// works in the app's own stable `String` ids — [_stableIntId] deterministically
/// derives one from the other so callers never need to track a second id.
class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  // Android locks a channel's sound at creation time — changing the sound
  // in code does not mutate an already-created channel on a device where
  // the old 'reminders' channel (default system sound) already exists.
  // `_v2` is a genuine channel migration, not a stylistic rename: it's the
  // only way to make the custom alarm sound actually take effect for
  // existing installs, at the cost of any user-customized settings on the
  // old channel being reset once (they land back on this channel's
  // defaults instead).
  static const _channelId = 'reminders_v2';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Scheduled reminder notifications from LifeOS';
  static const _channelSound = RawResourceAndroidNotificationSound(
    'popular_alarm_clock_sound_effect',
  );

  // Separate low-importance, silent channel: the ongoing Focus notification
  // is a persistent status display, not an alert — it must never make a
  // sound/vibrate on every update the way the 'reminders_v2' channel does.
  static const _ongoingChannelId = 'focus_ongoing';
  static const _ongoingChannelName = 'Focus session in progress';
  static const _ongoingChannelDescription =
      'Shows the live countdown while a Focus session is running';

  /// Must be called once, before the first [scheduleAt]/[cancel] call —
  /// initializes the plugin and the `timezone` database, registers the
  /// Android notification channel `scheduleAt` posts to, and wires
  /// [notificationTapDispatcher] to every tap-delivery path the plugin
  /// supports (foreground/background here; [consumeLaunchPayload] handles
  /// cold start separately since it needs an app-startup call site, not an
  /// `initialize`-time callback).
  ///
  /// [onBackgroundAction] handles a notification action tapped while the
  /// app isn't running in the foreground (`showsUserInterface: false`,
  /// currently only the Focus ongoing notification's Pause/Resume/End) —
  /// injected by the composition root
  /// (`config/di/background_notification_action_registration.dart`) rather
  /// than hardcoded here, so this feature-agnostic `core/` service never
  /// imports Focus's types (Golden Rule). Must itself be a top-level
  /// function — see that file's doc comment for why. Defaults to the
  /// dispatcher-based [handleBackgroundNotificationResponse] no-op for
  /// callers (tests, a future scheduler with no ongoing notifications) that
  /// don't need it.
  Future<void> initialize({
    void Function(NotificationResponse response) onBackgroundAction =
        handleBackgroundNotificationResponse,
  }) async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId != null) {
          notificationTapDispatcher.dispatchAction(response.actionId);
        } else {
          notificationTapDispatcher.dispatch(response.payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: onBackgroundAction,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    // Android 13+ (API 33) requires this runtime grant or the OS silently
    // drops every notification this scheduler posts — there is no manifest
    // permission alone that makes notifications appear. Safe to call
    // unconditionally: the plugin is a no-op on API <33 and de-dupes an
    // already-granted permission itself.
    await android?.requestNotificationsPermission();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
        sound: _channelSound,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _ongoingChannelId,
        _ongoingChannelName,
        description: _ongoingChannelDescription,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    );
  }

  /// Reads whatever notification (if any) cold-launched the app and
  /// forwards its payload through the same [notificationTapDispatcher]
  /// stream a live tap would use, so `app.dart`'s single listener handles
  /// cold start, background, and foreground taps identically. Must be
  /// called once during startup, after [initialize] and after the widget
  /// tree (specifically the router) is far enough along to act on a tap —
  /// see `app.dart`.
  Future<void> consumeLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      notificationTapDispatcher.dispatch(
        details?.notificationResponse?.payload,
      );
    }
  }

  @override
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        sound: _channelSound,
      ),
    );
    final when_ = tz.TZDateTime.from(when, tz.local);

    try {
      await _plugin.zonedSchedule(
        _stableIntId(id),
        title,
        body,
        when_,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } on PlatformException catch (e) {
      // Android 12+ requires a separate user-granted "Alarms & reminders"
      // permission for exact alarms (`SCHEDULE_EXACT_ALARM`) that this app
      // does not currently request — see docs/implemented_features.md's
      // Focus entry for why declaring/requesting it is deferred rather
      // than added reflexively here (Play Store policy implications for a
      // permission this app doesn't strictly need). A denied/unpermitted
      // exact alarm must never crash the caller or block the notification
      // entirely: fall back to `inexact` — the only mode that does NOT
      // itself require the exact-alarm permission (`alarmClock` was tried
      // first and throws the same `exact_alarms_not_permitted` error, since
      // Android treats alarm-clock-style alarms as exact too) — so a
      // notification still fires, just without the exact-time guarantee.
      // Notifications are enhancement, not a dependency for Focus timer
      // correctness — the persisted session timeline is unaffected either
      // way.
      if (e.code != 'exact_alarms_not_permitted') rethrow;
      debugPrint(
        'NotificationScheduler: exact alarm not permitted, falling back to '
        'inexact scheduling for "$id".',
      );
      await _plugin.zonedSchedule(
        _stableIntId(id),
        title,
        body,
        when_,
        details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        payload: payload,
      );
    }
  }

  @override
  Future<void> cancel(String id) => _plugin.cancel(_stableIntId(id));

  @override
  Future<void> showOngoing({
    required String id,
    required String title,
    required String body,
    required DateTime countdownTo,
    bool showPauseAction = false,
    bool showResumeAction = false,
    bool showEndAction = false,
  }) async {
    // showsUserInterface: false is what makes Android deliver the tap via
    // the background-isolate path (handleBackgroundNotificationResponse)
    // instead of opening/foregrounding the app — see
    // focus_action_entrypoint.dart, which is where these action ids are
    // consumed. The `action:<id>:` payload prefix distinguishes an action
    // tap from a plain notification-body tap in the same dispatcher stream.
    final actions = <AndroidNotificationAction>[
      if (showPauseAction)
        AndroidNotificationAction(
          'action:pause:$id',
          'Pause',
          showsUserInterface: false,
        ),
      if (showResumeAction)
        AndroidNotificationAction(
          'action:resume:$id',
          'Resume',
          showsUserInterface: false,
        ),
      if (showEndAction)
        AndroidNotificationAction(
          'action:end:$id',
          'End',
          showsUserInterface: false,
        ),
    ];
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _ongoingChannelId,
        _ongoingChannelName,
        channelDescription: _ongoingChannelDescription,
        importance: Importance.low,
        priority: Priority.low,
        playSound: false,
        enableVibration: false,
        // ongoing + not autoCancel: dismissed only by cancelOngoing() (on
        // pause/resume/complete/cancel), never by the user swiping it or
        // tapping it away — it should track the session's actual state at
        // all times, not disappear out of sync with it.
        ongoing: true,
        autoCancel: false,
        showWhen: true,
        usesChronometer: true,
        chronometerCountDown: true,
        // Android's Chronometer renders this itself, independent of the
        // Flutter process — it keeps counting down even if the app is
        // killed or backgrounded, unlike a Dart Timer rewriting the
        // notification every second.
        when: countdownTo.millisecondsSinceEpoch,
        actions: actions,
      ),
    );
    await _plugin.show(_ongoingIntId(id), title, body, details);
  }

  @override
  Future<void> cancelOngoing(String id) => _plugin.cancel(_ongoingIntId(id));

  /// Ongoing notifications are addressed separately from [scheduleAt]'s
  /// completion alarm — same string [id] (a Focus session id) but a
  /// different derived int, so posting/updating the live countdown never
  /// collides with or overwrites the scheduled completion notification for
  /// the same session.
  int _ongoingIntId(String id) => _stableIntId('ongoing:$id');

  /// Deterministic 31-bit positive int from a stable string id — stable
  /// across app restarts (unlike `Object.hashCode`, which is not guaranteed
  /// stable across isolates/runs) since it's a plain content hash.
  int _stableIntId(String id) {
    var hash = 0x811c9dc5;
    for (final unit in id.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
