import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/features/habits/domain/entities/habit.dart';
import 'package:lifeos/features/habits/domain/entities/habit_streak.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository(
    ref.watch(databaseProvider).habitsDao,
    ref.watch(eventBusProvider),
  );
});

/// Ticks once a minute so Today's Habits/streak classification stays
/// correct across a midnight rollover during a long-lived session — same
/// self-contained `Stream.periodic` shape as
/// `remindersClockTickProvider`/Home's `clockTickProvider`, kept local to
/// this feature rather than depending on `clockManagerProvider` (which
/// requires a GetIt registration not present in plain `ProviderContainer`
/// tests). `autoDispose` for the same reason as `remindersClockTickProvider`
/// — see that provider's doc comment.
final _habitsClockTickProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  ).startWith(DateTime.now());
});

extension<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}

/// Live completion dates for one habit — kept as its own `autoDispose`
/// family provider so [habitsDashboardProvider] can combine N of these (one
/// per active habit) without each habit's stream leaking beyond the
/// dashboard's lifetime.
final _habitCompletionDatesProvider = StreamProvider.autoDispose
    .family<Set<DateTime>, String>((ref, habitId) {
      return ref.watch(habitsRepositoryProvider).watchCompletionDates(habitId);
    });

/// The Habits feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Combines the live habit list
/// with each habit's completion history to derive real streaks — Home
/// never sees [Habit]/[HabitsRepository]/[HabitsDao].
final habitsDashboardProvider = StreamProvider.autoDispose<HabitsSummary>((
  ref,
) {
  final repository = ref.watch(habitsRepositoryProvider);
  final now = ref.watch(_habitsClockTickProvider).value ?? DateTime.now();
  return repository.watchAll().asyncMap((habits) async {
    final today = dateOnly(now);

    final streaks = <HabitStreakSummary>[];
    var scheduledTodayCount = 0;
    var completedTodayCount = 0;

    for (final habit in habits) {
      final completions = await ref.watch(
        _habitCompletionDatesProvider(habit.id).future,
      );
      final streak = calculateHabitStreak(
        schedule: habit.schedule,
        completedDates: completions,
        now: now,
      );
      final isScheduledToday = habit.schedule.occursOn(today);
      final isCompletedToday = completions.contains(today);

      if (isScheduledToday) {
        scheduledTodayCount++;
        if (isCompletedToday) completedTodayCount++;
      }

      streaks.add(
        HabitStreakSummary(
          id: habit.id,
          title: habit.title,
          icon: habit.icon,
          streakDays: streak.current,
          last7Days: [
            for (var i = 6; i >= 0; i--)
              completions.contains(today.subtract(Duration(days: i))),
          ],
          isCompletedToday: isCompletedToday,
        ),
      );
    }

    return HabitsSummary(
      streaks: streaks,
      scheduledTodayCount: scheduledTodayCount,
      completedTodayCount: completedTodayCount,
    );
  });
});
