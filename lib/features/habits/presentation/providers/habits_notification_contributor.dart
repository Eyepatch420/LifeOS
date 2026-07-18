import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/habits/domain/events/habit_events.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Habits' contribution to the notification pipeline — a pure mapper, same
/// shape as [RemindersNotificationContributor].
///
/// Habits currently has no preferred-time-of-day field on the domain model
/// (see `HabitSchedule`'s doc comment — schedule is day-granularity, not
/// time-granularity, matching this phase's actual MVP scope), so there is
/// no honest `when` to schedule a reminder notification against.
/// [HabitCreated]/[HabitUpdated] are therefore recognized (`handles`
/// returns true) but intentionally map to `null` — this is a documented
/// limitation, not an omission: fabricating a notification time the domain
/// model doesn't actually have would be worse than not notifying at all.
/// [HabitArchived] cancels any notification that may have existed under a
/// prior model, so a future preferred-time addition doesn't need this
/// contributor to grow retroactive cleanup logic.
class HabitsNotificationContributor implements NotificationContributor {
  const HabitsNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'habits';

  @override
  NotificationIntent? map(DomainEvent event) {
    return switch (event) {
      HabitArchived(sourceId: final id) => CancelNotification(id: id),
      HabitCreated() || HabitUpdated() || HabitCompleted() => null,
      _ => null,
    };
  }
}
