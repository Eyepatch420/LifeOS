import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/calendar/domain/events/event_events.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Calendar's contribution to the notification pipeline — a pure mapper,
/// same shape as [RemindersNotificationContributor]. Unlike Habits, an
/// event genuinely has a scheduling timestamp ([Event.startAt]), so this
/// contributor can honestly schedule/reschedule/cancel real notifications
/// rather than mapping to `null`.
///
/// [EventCreated]/[EventUpdated] both carry `title`/`startAt`/`isAllDay` (no
/// repository re-read needed inside [map]) and map to a fresh
/// [ScheduleNotification] at `startAt` (rescheduling on update, since
/// [NotificationScheduler.scheduleAt] overwrites any existing notification
/// for the same id — mirrors [RemindersNotificationContributor]'s doc
/// comment exactly). An all-day event's [Event.startAt] is a calendar-date
/// midnight (see `EventsRepository`'s normalization); scheduling a
/// notification "at midnight" for an all-day event is the same honest
/// point-in-time interpretation Reminders already uses for any due-at
/// timestamp — not a fabricated time, just the one the domain model
/// actually stores. [EventDeleted] cancels the pending notification.
class CalendarNotificationContributor implements NotificationContributor {
  const CalendarNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'calendar';

  @override
  List<NotificationIntent> map(DomainEvent event) {
    return switch (event) {
      EventCreated(sourceId: final id, :final title, :final startAt) => [
        ScheduleNotification(
          id: id,
          when: startAt,
          title: title,
          body: 'Event starting now',
        ),
      ],
      EventUpdated(sourceId: final id, :final title, :final startAt) => [
        ScheduleNotification(
          id: id,
          when: startAt,
          title: title,
          body: 'Event starting now',
        ),
      ],
      EventDeleted(sourceId: final id) => [CancelNotification(id: id)],
      _ => const [],
    };
  }
}
