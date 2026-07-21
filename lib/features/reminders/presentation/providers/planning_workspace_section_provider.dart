import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';

/// Which tab of the Reminders/Planner/Habits/Calendar planning workspace is
/// currently shown — pure local UI state, analogous to
/// [PlannerSelectedDateNotifier] (`planner_selected_date_provider.dart`).
/// Switching tabs no longer navigates; it only flips this.
///
/// Deliberately NOT `.autoDispose`: [PlanningWorkspaceScaffold] is expected
/// to stay mounted for the whole `/reminders` branch lifetime, so losing
/// this on a stray rebuild would silently reset the user back to the
/// Reminders tab.
class PlanningWorkspaceSectionNotifier
    extends Notifier<PlanningWorkspaceSection> {
  @override
  PlanningWorkspaceSection build() => PlanningWorkspaceSection.reminders;

  void select(PlanningWorkspaceSection section) => state = section;
}

final planningWorkspaceSectionProvider =
    NotifierProvider<
      PlanningWorkspaceSectionNotifier,
      PlanningWorkspaceSection
    >(PlanningWorkspaceSectionNotifier.new);
