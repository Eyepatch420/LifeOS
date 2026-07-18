import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/planner/planner_contributor.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_planner_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_planner_contributor.dart';

/// The single composition-layer seam allowed to import every Type A
/// feature's [PlannerContributor] — `lib/features/reminders/presentation/screens/planner_screen.dart`
/// and its supporting providers never do. Add one line here when a feature
/// gains a contributor; nothing inside the Planner feature changes (mirrors
/// `search_contributor_registrations.dart`/`notification_contributor_registrations.dart`
/// exactly).
List<PlannerContributor> plannerContributors(Ref ref) {
  return [
    RemindersPlannerContributor(ref.watch(remindersRepositoryProvider)),
    HabitsPlannerContributor(ref.watch(habitsRepositoryProvider)),
  ];
}

/// A `Ref`-free way for widgets (`WidgetRef`, which no longer subtypes
/// `Ref` as of Riverpod 3) to read the same registered contributor list —
/// e.g. `PlannerScreen`'s completion handler, which needs to find "the
/// contributor that owns this item" without importing a feature repository
/// itself.
final plannerContributorsProvider = Provider<List<PlannerContributor>>(
  plannerContributors,
);
