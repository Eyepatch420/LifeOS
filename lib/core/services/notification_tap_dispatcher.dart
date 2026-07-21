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

  /// A tapped notification *action* (Pause/Resume/End on the ongoing Focus
  /// notification) rather than the notification body itself. [actionId] is
  /// whatever [AndroidNotificationAction.id] the action was posted with —
  /// see `LocalNotificationScheduler.showOngoing`'s `action:<kind>:<id>`
  /// convention. Kept on a separate stream from [taps]: an action is meant
  /// to be handled silently (see `focus_action_entrypoint.dart`), while a
  /// body tap is meant to navigate — merging them would force every
  /// consumer to re-derive which case it got.
  void dispatchAction(String? actionId) {
    if (actionId == null || actionId.isEmpty) return;
    _actionController.add(actionId);
  }

  final _actionController = StreamController<String>.broadcast();

  Stream<String> get actions => _actionController.stream;

  void dispose() {
    _controller.close();
    _actionController.close();
  }
}

/// Process-wide singleton — required because
/// `onDidReceiveBackgroundNotificationResponse` must reference a top-level
/// or static function per `flutter_local_notifications`' contract, so it
/// cannot close over an instance the way a normal callback could. Every
/// other caller (`LocalNotificationScheduler`, `app.dart`) goes through
/// this same instance rather than each holding their own.
///
/// NOTE: this specific instance is only ever meaningfully observed in the
/// **foreground** app isolate. [handleBackgroundNotificationResponse] below
/// runs in a plugin-spawned background isolate/engine with its own fresh
/// memory — writes to this controller from there are inert (nothing in
/// that isolate is listening), which is why that handler does not call
/// into this dispatcher at all; see its own doc comment.
final notificationTapDispatcher = NotificationTapDispatcher();

/// Top-level fallback background-response handler. Only reachable if a
/// background action notification was posted through some path that
/// doesn't override this — in this app, every notification with
/// `showsUserInterface: false` (currently only the Focus ongoing
/// notification's Pause/Resume/End actions) registers
/// `handleFocusNotificationAction` (`focus_action_entrypoint.dart`)
/// directly at plugin-initialize time instead, so this one is a defensive
/// no-op rather than the live path — see `notification_scheduler.dart`'s
/// `initialize()` for which function is actually registered.
@pragma('vm:entry-point')
void handleBackgroundNotificationResponse(NotificationResponse response) {}
