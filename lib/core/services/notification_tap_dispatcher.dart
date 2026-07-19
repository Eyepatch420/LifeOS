import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Broadcasts a tapped notification's opaque `payload` string — the shared,
/// feature-agnostic half of notification deep-linking.
///
/// `LocalNotificationScheduler` (see `notification_scheduler.dart`) is the
/// only writer: it forwards whatever `payload` was attached via
/// `ScheduleNotification.payload` when the notification was scheduled,
/// covering all three delivery cases `flutter_local_notifications` can
/// report a tap from:
///
/// - **Foreground tap** (app already running): the plugin's
///   `onDidReceiveNotificationResponse` fires directly — forwarded here
///   immediately.
/// - **Background tap** (app backgrounded, not killed): delivered via the
///   plugin's `onDidReceiveBackgroundNotificationResponse`, which per the
///   plugin's own contract must be a top-level/static function (it may run
///   in a separate isolate) — see [handleBackgroundNotificationResponse].
/// - **Cold start** (app was fully closed, notification tap launches it):
///   there is no live listener yet when the tap happens, so
///   `LocalNotificationScheduler.consumeLaunchPayload` reads
///   `getNotificationAppLaunchDetails()` once during app startup and
///   replays it through this same controller after the first frame, so
///   every consumer (just `app.dart`'s router listener, today) only ever
///   has to handle one case: "a payload arrived on this stream."
///
/// Never imports GoRouter or any feature type (Golden Rule) — it only
/// knows how to move an opaque string from "a notification was tapped" to
/// "something is listening." `app.dart` is the one place that turns a
/// payload into a route.
class NotificationTapDispatcher {
  final _controller = StreamController<String>.broadcast();

  Stream<String> get taps => _controller.stream;

  void dispatch(String? payload) {
    if (payload == null || payload.isEmpty) return;
    _controller.add(payload);
  }

  void dispose() => _controller.close();
}

/// Process-wide singleton — required because
/// `onDidReceiveBackgroundNotificationResponse` must reference a top-level
/// or static function per `flutter_local_notifications`' contract, so it
/// cannot close over an instance the way a normal callback could. Every
/// other caller (`LocalNotificationScheduler`, `app.dart`) goes through
/// this same instance rather than each holding their own.
final notificationTapDispatcher = NotificationTapDispatcher();

/// Top-level background-response handler, registered with
/// `FlutterLocalNotificationsPlugin.initialize`. Required to be a
/// top-level/static function (never a closure) by the plugin's own
/// contract, and annotated `vm:entry-point` so it survives tree-shaking
/// when invoked from a background isolate. Deliberately does the bare
/// minimum (forward the payload) — anything heavier here risks running
/// with no guarantee of a live app UI to route into; the actual routing
/// only ever happens once [NotificationTapDispatcher.taps] is observed by
/// `app.dart` in the foreground isolate.
@pragma('vm:entry-point')
void handleBackgroundNotificationResponse(NotificationResponse response) {
  notificationTapDispatcher.dispatch(response.payload);
}
