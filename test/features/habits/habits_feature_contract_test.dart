import 'package:drift/native.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/domain/events/habit_events.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_notification_contributor.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_search_contributor.dart';

import '../../contracts/feature_contract_test_harness.dart';

/// Follows `reminders_feature_contract_test.dart`'s exact shape — the
/// template this feature copied. Habits deliberately has no
/// `AgendaContributor` (see `config/di/agenda_contributor_registrations.dart`'s
/// doc comment), so it isn't part of this harness — the five-part contract
/// is dashboard summary + search + notification, and Habits satisfies all
/// three.
void main() {
  runFeatureContractTests<HabitsSummary>('Habits', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final eventBus = EventBus();
    final repository = HabitsRepository(db.habitsDao, eventBus);

    await repository.create(
      id: 'h1',
      title: 'Seed',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );

    return FeatureContractFixture<HabitsSummary>(
      dashboardSummary: () async {
        final habits = await repository.watchAll().first;
        return HabitsSummary(
          streaks: [
            for (final habit in habits)
              HabitStreakSummary(
                id: habit.id,
                title: habit.title,
                icon: habit.icon,
                streakDays: 0,
                last7Days: const [
                  false,
                  false,
                  false,
                  false,
                  false,
                  false,
                  false,
                ],
                isCompletedToday: false,
              ),
          ],
          scheduledTodayCount: habits.length,
          completedTodayCount: 0,
        );
      },
      searchContributor: HabitsSearchContributor(repository),
      notificationContributor: const HabitsNotificationContributor(),
      sampleOwnEvent: const HabitCreated(habitId: 'h1', title: 'Seed'),
      triggerNotifiableMutation: () => repository.create(
        id: 'h2',
        title: 'Trigger',
        schedule: const HabitSchedule.daily(),
        icon: 'star',
      ),
    );
  });
}
