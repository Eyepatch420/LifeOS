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

  static const _channelId = 'reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Scheduled reminder notifications from LifeOS';

  /// Must be called once, before the first [scheduleAt]/[cancel] call —
  /// initializes the plugin and the `timezone` database, registers the
  /// Android notification channel `scheduleAt` posts to, and wires
  /// [notificationTapDispatcher] to every tap-delivery path the plugin
  /// supports (foreground/background here; [consumeLaunchPayload] handles
  /// cold start separately since it needs an app-startup call site, not an
  /// `initialize`-time callback).
  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) =>
          notificationTapDispatcher.dispatch(response.payload),
      onDidReceiveBackgroundNotificationResponse:
          handleBackgroundNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
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
