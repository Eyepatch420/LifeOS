import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [EventsRepository] on event creation. Carries [title]/
/// [startAt] (not just the id) so [CalendarNotificationContributor] can
/// build a [ScheduleNotification] synchronously, without an async
/// repository re-read inside [NotificationContributor.map] — mirrors
/// `ReminderCreated`.
class EventCreated extends DomainEvent {
  const EventCreated({
    required String eventId,
    required this.title,
    required this.startAt,
    required this.isAllDay,
  }) : super(sourceModule: 'calendar', sourceId: eventId);

  final String title;
  final DateTime startAt;
  final bool isAllDay;
}

/// Emitted when an event's title/startAt/endAt/isAllDay changes. Carries
/// the same fields as [EventCreated] so
/// [CalendarNotificationContributor] can reschedule (same `id`, new
/// `when`) without a repository dependency.
class EventUpdated extends DomainEvent {
  const EventUpdated({
    required String eventId,
    required this.title,
    required this.startAt,
    required this.isAllDay,
  }) : super(sourceModule: 'calendar', sourceId: eventId);

  final String title;
  final DateTime startAt;
  final bool isAllDay;
}

/// Emitted on (soft) delete/archive. Cancels any pending notification.
class EventDeleted extends DomainEvent {
  const EventDeleted({required String eventId})
    : super(sourceModule: 'calendar', sourceId: eventId);
}
