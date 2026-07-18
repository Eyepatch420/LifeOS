import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';

void main() {
  Future<ProviderContainer> makeContainer() async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('zero habits yields an empty summary', () async {
    final container = await makeContainer();
    final sub = container.listen(habitsDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    final summary = await container.read(habitsDashboardProvider.future);
    expect(summary.streaks, isEmpty);
    expect(summary.scheduledTodayCount, 0);
    expect(summary.completedTodayCount, 0);
  });

  test('a daily habit is counted as scheduled today', () async {
    final container = await makeContainer();
    final sub = container.listen(habitsDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(habitsRepositoryProvider)
        .create(
          id: 'h1',
          title: 'Walk',
          schedule: const HabitSchedule.daily(),
          icon: 'walk',
        );

    final summary = await container.read(habitsDashboardProvider.future);
    expect(summary.scheduledTodayCount, 1);
    expect(summary.completedTodayCount, 0);
    expect(summary.streaks.single.title, 'Walk');
    expect(summary.streaks.single.isCompletedToday, isFalse);
  });

  test('completing today increments completedTodayCount', () async {
    final container = await makeContainer();
    final sub = container.listen(habitsDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(habitsRepositoryProvider);
    await repository.create(
      id: 'h1',
      title: 'Walk',
      schedule: const HabitSchedule.daily(),
      icon: 'walk',
    );
    await repository.setCompletedForDate('h1', DateTime.now(), completed: true);

    final summary = await container.read(habitsDashboardProvider.future);
    expect(summary.completedTodayCount, 1);
    expect(summary.streaks.single.isCompletedToday, isTrue);
    expect(summary.streaks.single.streakDays, 1);
  });

  test(
    'a weekly habit not scheduled today is excluded from scheduledTodayCount',
    () async {
      final container = await makeContainer();
      final sub = container.listen(habitsDashboardProvider, (_, _) {});
      addTearDown(sub.close);

      // Pick a weekday that is definitely not today.
      final notToday = (DateTime.now().weekday % 7) + 1;
      await container
          .read(habitsRepositoryProvider)
          .create(
            id: 'h1',
            title: 'Gym',
            schedule: HabitSchedule.weekly({notToday}),
            icon: 'gym',
          );

      final summary = await container.read(habitsDashboardProvider.future);
      expect(summary.scheduledTodayCount, 0);
      // Still present in the streaks list (Habits workspace shows all
      // habits, not only today's), just not counted as scheduled today.
      expect(summary.streaks, hasLength(1));
    },
  );

  test('repository changes update the provider output reactively', () async {
    final container = await makeContainer();
    final sub = container.listen(habitsDashboardProvider, (_, _) {});
    addTearDown(sub.close);

    await container.read(habitsDashboardProvider.future);
    final repository = container.read(habitsRepositoryProvider);

    await repository.create(
      id: 'h1',
      title: 'Read',
      schedule: const HabitSchedule.daily(),
      icon: 'book',
    );

    // Re-await the future provider — its value updates once the new
    // StreamProvider.autoDispose emission lands.
    await Future<void>.delayed(Duration.zero);
    final summary = await container.read(habitsDashboardProvider.future);
    expect(summary.streaks, hasLength(1));
  });
}
