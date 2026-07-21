import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';
import 'package:lifeos/features/reminders/domain/events/reminder_events.dart';

/// Reminders' contribution to the notification pipeline — the first real
/// (non-null-mapping) [NotificationContributor]. A pure mapper with no
/// repository dependency: [ReminderCreated]/[ReminderUpdated] already
/// carry `title`/`dueAt`, so this never needs an async re-read inside the
/// synchronous [map] call. Maps to a fresh [ScheduleNotification]
/// (rescheduling on update, since [NotificationScheduler.scheduleAt]
/// overwrites any existing notification for the same id) and
/// [ReminderCompleted]/[ReminderDeleted] to a [CancelNotification].
class RemindersNotificationContributor implements NotificationContributor {
  const RemindersNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'reminders';

  @override
  List<NotificationIntent> map(DomainEvent event) {
    return switch (event) {
      ReminderCreated(sourceId: final id, :final title, :final dueAt) => [
        ScheduleNotification(
          id: id,
          when: dueAt,
          title: title,
          body: 'Reminder due now',
          payload: 'reminder:$id',
        ),
      ],
      ReminderUpdated(sourceId: final id, :final title, :final dueAt) => [
        ScheduleNotification(
          id: id,
          when: dueAt,
          title: title,
          body: 'Reminder due now',
          payload: 'reminder:$id',
        ),
      ],
      ReminderCompleted(sourceId: final id) => [CancelNotification(id: id)],
      ReminderDeleted(sourceId: final id) => [CancelNotification(id: id)],
      _ => const [],
    };
  }
}
