import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifeos/features/focus/data/focus_action_entrypoint.dart';

/// The single composition-layer seam allowed to give `core/services`'
/// `LocalNotificationScheduler` a feature-aware background-action handler
/// without `core/` itself importing any feature (Golden Rule) — mirrors
/// `notification_contributor_registrations.dart`/
/// `search_contributor_registrations.dart` exactly, just for this one
/// plugin-mandated top-level function instead of a list of contributors.
///
/// Must itself be top-level (not a closure) per
/// `flutter_local_notifications`' `onDidReceiveBackgroundNotificationResponse`
/// contract — Android may invoke it in a freshly spawned isolate/engine
/// with no access to this file's or any other's instance state, so it can
/// only ever delegate to another top-level function, never close over
/// anything. Currently Focus's ongoing-notification actions
/// (Pause/Resume/End) are the only background action this app posts; if a
/// second feature ever needs one, this is where it gets dispatched by
/// payload/action-id prefix, the same way `notificationContributors`
/// dispatches by `sourceModule`.
void handleBackgroundNotificationAction(NotificationResponse response) {
  handleFocusNotificationAction(response);
}
