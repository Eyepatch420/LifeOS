import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/planner/planner_contributor.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';

/// Reminders' contribution to the Planner's cross-feature item stream —
/// registered at `config/di/planner_contributor_registrations.dart`.
/// Replaces the Phase 5 `reminderToPlannerItem` free function now that
/// [PlannerContributor] exists (Phase 6) as the neutral registration seam;
/// the mapping logic itself (one place that knows how a [Reminder] becomes
/// a [PlannerItem]) is unchanged, just wrapped in the contributor shape.
class RemindersPlannerContributor implements PlannerContributor {
  const RemindersPlannerContributor(this._repository);

  final RemindersRepository _repository;

  @override
  PlannerSourceType get sourceType => PlannerSourceType.reminder;

  @override
  Stream<List<PlannerItem>> contributions() {
    return _repository.watchAll().map(
      (reminders) => reminders.map(_toPlannerItem).toList(),
    );
  }

  @override
  Future<void> complete(PlannerItem item, {required bool completed}) {
    return _repository.setCompleted(item.sourceId, completed);
  }

  PlannerItem _toPlannerItem(Reminder reminder) {
    return PlannerItem(
      id: 'reminder:${reminder.id}',
      sourceType: PlannerSourceType.reminder,
      sourceId: reminder.id,
      title: reminder.title,
      scheduledAt: reminder.dueAt,
      isCompleted: reminder.isCompleted,
      isUrgent: reminder.isUrgent,
      isRecurring: reminder.recurrence != RecurrenceRule.none,
      routeName: RouteNames.reminderDetail,
      pathParameters: {'reminderId': reminder.id},
    );
  }
}
