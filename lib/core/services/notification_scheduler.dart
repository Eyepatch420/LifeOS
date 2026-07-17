import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  /// initializes the plugin and the `timezone` database, and registers the
  /// Android notification channel `scheduleAt` posts to.
  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

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

  @override
  Future<void> scheduleAt({
    required String id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      _stableIntId(id),
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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
