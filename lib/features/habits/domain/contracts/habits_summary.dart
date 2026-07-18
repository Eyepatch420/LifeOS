import 'package:freezed_annotation/freezed_annotation.dart';

part 'habits_summary.freezed.dart';

/// One entry in the Habits feature's dashboard summary — Home imports this
/// and [HabitsSummary] only, never `Habit`/`HabitsRepository` directly (see
/// docs/architecture_principles.md's Architecture Constraint 1). Carries
/// `id` (identity for e.g. future dismiss/tap-through) and a resolved
/// [streakDays]/[last7Days] so Home never computes streak semantics itself.
@freezed
abstract class HabitStreakSummary with _$HabitStreakSummary {
  const factory HabitStreakSummary({
    required String id,
    required String title,
    required String icon,
    required int streakDays,
    required List<bool> last7Days,
    required bool isCompletedToday,
  }) = _HabitStreakSummary;
}

/// The Habits feature's full dashboard contribution.
@freezed
abstract class HabitsSummary with _$HabitsSummary {
  const factory HabitsSummary({
    required List<HabitStreakSummary> streaks,
    required int scheduledTodayCount,
    required int completedTodayCount,
  }) = _HabitsSummary;
}
