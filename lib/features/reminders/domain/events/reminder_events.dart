import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [RemindersRepository] on reminder creation. Carries
/// [title]/[dueAt] (not just the id) so [RemindersNotificationContributor]
/// can build a [ScheduleNotification] synchronously, without needing an
/// async repository re-read inside [NotificationContributor.map].
class ReminderCreated extends DomainEvent {
  const ReminderCreated({
    required String reminderId,
    required this.title,
    required this.dueAt,
  }) : super(sourceModule: 'reminders', sourceId: reminderId);

  final String title;
  final DateTime dueAt;
}

/// Emitted when a reminder's title/dueAt/recurrence changes. Carries the
/// same fields as [ReminderCreated] for the same reason —
/// [RemindersNotificationContributor] reschedules (same `id`, new
/// `when`/content) without a repository dependency.
class ReminderUpdated extends DomainEvent {
  const ReminderUpdated({
    required String reminderId,
    required this.title,
    required this.dueAt,
  }) : super(sourceModule: 'reminders', sourceId: reminderId);

  final String title;
  final DateTime dueAt;
}

/// Emitted when a reminder is marked completed.
/// [RemindersNotificationContributor] cancels its pending notification in
/// response — a completed reminder should never still fire.
class ReminderCompleted extends DomainEvent {
  const ReminderCompleted({required String reminderId})
    : super(sourceModule: 'reminders', sourceId: reminderId);
}

/// Emitted on (soft) delete. Cancels the pending notification, same as
/// [ReminderCompleted].
class ReminderDeleted extends DomainEvent {
  const ReminderDeleted({required String reminderId})
    : super(sourceModule: 'reminders', sourceId: reminderId);
}
