import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/planner/planner_contributor.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';

/// Completes [item] via whichever [PlannerContributor] produced it (matched
/// by [PlannerItem.sourceType] — see [PlannerContributor.complete]'s doc
/// comment on why Planner never imports a feature repository directly to do
/// this) and shows appropriate feedback.
///
/// For a [PlannerSourceType.reminder] item, reuses the exact recurring-
/// completion snackbar language ("Completed. Next reminder: ...") from
/// `ReminderDetailScreen`/`RemindersListScreen` — detected by reading the
/// reminder back through [remindersRepository] (only used for this
/// feedback text, not for the completion call itself, which always goes
/// through the matched contributor). Every other source type gets a
/// simpler, source-agnostic "Marked complete" acknowledgement, since
/// non-reminder sources (Habits) have no equivalent "advanced to a new
/// occurrence" concept to surface.
Future<void> completePlannerItemWithFeedback(
  BuildContext context, {
  required PlannerItem item,
  required List<PlannerContributor> contributors,
  required RemindersRepository remindersRepository,
}) async {
  final contributor = contributors.firstWhere(
    (c) => c.sourceType == item.sourceType,
    orElse: () => throw StateError(
      'No PlannerContributor registered for ${item.sourceType}',
    ),
  );

  await contributor.complete(item, completed: true);
  if (!context.mounted) return;

  if (item.sourceType != PlannerSourceType.reminder) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Marked complete')));
    return;
  }

  final refreshed = await remindersRepository.getById(item.sourceId);
  if (!context.mounted) return;

  final message = (refreshed != null && !refreshed.isCompleted)
      ? 'Completed. Next reminder: '
            '${DateFormat('EEE, d MMM • h:mm a').format(refreshed.dueAt)}'
      : 'Reminder completed';
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
