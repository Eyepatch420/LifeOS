import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Focus's contribution to the notification pipeline. Mirrors
/// `RemindersNotificationContributor`'s shape exactly — a pure mapper with
/// no repository dependency, since [FocusSessionStarted]/[FocusSessionResumed]
/// already carry `projectedEndAt`.
///
/// [ScheduleNotification.id] is set to `'focus-<sessionId>'`'s payload
/// convention: [NotificationScheduler.scheduleAt] takes a `payload` used by
/// `LocalNotificationScheduler`'s Android channel so a tap can be routed
/// back to the Focus screen — see `notification_tap_dispatcher.dart`. The
/// payload format `focus:<sessionId>` is a plain, feature-owned string; the
/// dispatcher only pattern-matches the `focus:` prefix and never imports
/// Focus's own types (Golden Rule).
class FocusNotificationContributor implements NotificationContributor {
  const FocusNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'focus';

  @override
  NotificationIntent? map(DomainEvent event) {
    return switch (event) {
      FocusSessionStarted(sourceId: final id, :final projectedEndAt) =>
        ScheduleNotification(
          id: id,
          when: projectedEndAt,
          title: 'Focus session complete',
          body: 'Nice work — your focus session has ended.',
          payload: 'focus:$id',
        ),
      FocusSessionResumed(sourceId: final id, :final projectedEndAt) =>
        ScheduleNotification(
          id: id,
          when: projectedEndAt,
          title: 'Focus session complete',
          body: 'Nice work — your focus session has ended.',
          payload: 'focus:$id',
        ),
      FocusSessionPaused(sourceId: final id) => CancelNotification(id: id),
      FocusSessionCompleted(sourceId: final id) => CancelNotification(id: id),
      FocusSessionCancelled(sourceId: final id) => CancelNotification(id: id),
      _ => null,
    };
  }
}
