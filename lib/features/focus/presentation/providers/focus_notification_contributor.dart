import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/focus/domain/events/focus_events.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Focus's contribution to the notification pipeline. Mirrors
/// `RemindersNotificationContributor`'s shape — a pure mapper with no
/// repository dependency, since [FocusSessionStarted]/[FocusSessionResumed]
/// already carry `projectedEndAt`.
///
/// [ScheduleNotification.id] is set to `'focus-<sessionId>'`'s payload
/// convention: [NotificationScheduler.scheduleAt] takes a `payload` used by
/// `LocalNotificationScheduler`'s Android channel so a tap can be routed
/// back to the Focus screen — see `notification_tap_dispatcher.dart`. The
/// payload format `focus:<sessionId>` is a plain, feature-owned string; the
/// dispatcher only pattern-matches the `focus:` prefix and never imports
/// Focus's own types (Golden Rule).
///
/// Start/resume return *two* intents: the OS-scheduled completion alarm
/// (unaffected by whether the app process survives) and a
/// [ShowOngoingNotification] for the live "time remaining" status display.
/// These are deliberately independent — see this file's Phase 7.5 doc notes
/// on `NotificationScheduler` — cancelling/losing the ongoing display never
/// cancels the completion alarm, and vice versa.
class FocusNotificationContributor implements NotificationContributor {
  const FocusNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'focus';

  @override
  List<NotificationIntent> map(DomainEvent event) {
    return switch (event) {
      FocusSessionStarted(sourceId: final id, :final projectedEndAt) => [
        ScheduleNotification(
          id: id,
          when: projectedEndAt,
          title: 'Focus session complete',
          body: 'Nice work — your focus session has ended.',
          payload: 'focus:$id',
        ),
        ShowOngoingNotification(
          id: id,
          title: 'Focus session in progress',
          body: 'Tap to return to your session',
          countdownTo: projectedEndAt,
        ),
      ],
      FocusSessionResumed(sourceId: final id, :final projectedEndAt) => [
        ScheduleNotification(
          id: id,
          when: projectedEndAt,
          title: 'Focus session complete',
          body: 'Nice work — your focus session has ended.',
          payload: 'focus:$id',
        ),
        ShowOngoingNotification(
          id: id,
          title: 'Focus session in progress',
          body: 'Tap to return to your session',
          countdownTo: projectedEndAt,
        ),
      ],
      // Paused: the completion alarm is cancelled (a paused session must
      // never fire early) and the ongoing display is removed rather than
      // left ticking down against a deadline that no longer applies — it
      // reappears with a freshly-projected end time on resume, above.
      FocusSessionPaused(sourceId: final id) => [
        CancelNotification(id: id),
        CancelOngoingNotification(id: id),
      ],
      FocusSessionCompleted(sourceId: final id) => [
        CancelNotification(id: id),
        CancelOngoingNotification(id: id),
      ],
      FocusSessionCancelled(sourceId: final id) => [
        CancelNotification(id: id),
        CancelOngoingNotification(id: id),
      ],
      _ => const [],
    };
  }
}
