import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_planner_contributor.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_planner_contributor.dart';

/// Verifies Planner's cross-feature aggregation architecture — the primary
/// architectural goal of Phase 6: a second real Type A feature (Habits)
/// contributes to the same `List<PlannerItem>` stream Reminders already
/// did, via the [PlannerContributor] interface, with no feature-specific
/// switching inside Planner's own provider/screen code.
void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late RemindersRepository remindersRepository;
  late HabitsRepository habitsRepository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    remindersRepository = RemindersRepository(db.remindersDao, eventBus);
    habitsRepository = HabitsRepository(db.habitsDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('both a reminder and a daily habit contribute PlannerItems', () async {
    await remindersRepository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime.now(),
      isUrgent: false,
    );
    await habitsRepository.create(
      id: 'h1',
      title: 'Morning Walk',
      schedule: const HabitSchedule.daily(),
      icon: 'walk',
    );

    final remindersContributor = RemindersPlannerContributor(
      remindersRepository,
    );
    final habitsContributor = HabitsPlannerContributor(habitsRepository);

    final reminderItems = await remindersContributor.contributions().first;
    final habitItems = await habitsContributor.contributions().first;

    expect(reminderItems, hasLength(1));
    expect(reminderItems.single.sourceType, PlannerSourceType.reminder);
    expect(reminderItems.single.title, 'Pay rent');

    expect(habitItems, isNotEmpty);
    expect(
      habitItems.every((i) => i.sourceType == PlannerSourceType.habit),
      isTrue,
    );
    expect(habitItems.any((i) => i.title == 'Morning Walk'), isTrue);
  });

  test(
    'a habit occurrence does not appear on a day it is not scheduled',
    () async {
      final today = dateOnly(DateTime.now());
      final notToday = (today.weekday % 7) + 1;

      await habitsRepository.create(
        id: 'h1',
        title: 'Gym',
        schedule: HabitSchedule.weekly({notToday}),
        icon: 'gym',
      );

      final contributor = HabitsPlannerContributor(habitsRepository);
      final items = await contributor.contributions().first;

      final todaysItems = items.where((i) => isSameDay(i.scheduledAt, today));
      expect(todaysItems, isEmpty);
      // But some day matching the scheduled weekday exists in the window.
      expect(items.any((i) => i.scheduledAt.weekday == notToday), isTrue);
    },
  );

  test('completing a habit PlannerItem updates its completion state', () async {
    await habitsRepository.create(
      id: 'h1',
      title: 'Read',
      schedule: const HabitSchedule.daily(),
      icon: 'book',
    );

    final contributor = HabitsPlannerContributor(habitsRepository);
    final today = dateOnly(DateTime.now());
    final items = await contributor.contributions().first;
    final todayItem = items.firstWhere((i) => isSameDay(i.scheduledAt, today));

    expect(todayItem.isCompleted, isFalse);

    await contributor.complete(todayItem, completed: true);

    final refreshed = await contributor.contributions().first;
    final refreshedToday = refreshed.firstWhere(
      (i) => isSameDay(i.scheduledAt, today),
    );
    expect(refreshedToday.isCompleted, isTrue);
  });

  test(
    'completing a reminder PlannerItem delegates to RemindersRepository.setCompleted',
    () async {
      await remindersRepository.create(
        id: 'r1',
        title: 'Task',
        dueAt: DateTime.now(),
        isUrgent: false,
      );

      final contributor = RemindersPlannerContributor(remindersRepository);
      final items = await contributor.contributions().first;

      await contributor.complete(items.single, completed: true);

      final reminder = await remindersRepository.getById('r1');
      expect(reminder!.isCompleted, isTrue);
    },
  );

  test(
    'each PlannerItem carries navigation metadata for its own detail screen',
    () async {
      await remindersRepository.create(
        id: 'r1',
        title: 'Reminder',
        dueAt: DateTime.now(),
        isUrgent: false,
      );
      await habitsRepository.create(
        id: 'h1',
        title: 'Habit',
        schedule: const HabitSchedule.daily(),
        icon: 'star',
      );

      final reminderItem = (await RemindersPlannerContributor(
        remindersRepository,
      ).contributions().first).single;
      final habitItem = (await HabitsPlannerContributor(
        habitsRepository,
      ).contributions().first).first;

      expect(reminderItem.routeName, 'reminderDetail');
      expect(reminderItem.pathParameters, {'reminderId': 'r1'});
      expect(habitItem.routeName, 'habitDetail');
      expect(habitItem.pathParameters, {'habitId': 'h1'});
    },
  );

  test('each registered contributor exposes a distinct sourceType — the '
      'invariant completePlannerItemWithFeedback relies on to route '
      'completion to exactly one contributor', () {
    final contributors = [
      RemindersPlannerContributor(remindersRepository),
      HabitsPlannerContributor(habitsRepository),
    ];
    final sourceTypes = contributors.map((c) => c.sourceType).toSet();
    expect(sourceTypes, hasLength(contributors.length));
  });

  test('an incomplete past-day habit occurrence is not materialized as a '
      'PlannerItem, so it can never wrongly appear as "overdue" in the '
      'Needs Attention section — a habit miss is a distinct-per-day event, '
      'not a carried-over task the way a Reminder is', () async {
    await habitsRepository.create(
      id: 'h1',
      title: 'Stretch',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );

    final contributor = HabitsPlannerContributor(habitsRepository);
    final items = await contributor.contributions().first;
    final today = dateOnly(DateTime.now());

    final pastIncomplete = items.where(
      (i) => i.scheduledAt.isBefore(today) && !i.isCompleted,
    );
    expect(pastIncomplete, isEmpty);
  });

  test('a COMPLETED past-day habit occurrence is still materialized, so that '
      "day's own timeline can show it", () async {
    await habitsRepository.create(
      id: 'h1',
      title: 'Stretch',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );
    final yesterday = dateOnly(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    await habitsRepository.setCompletedForDate(
      'h1',
      yesterday,
      completed: true,
    );

    final contributor = HabitsPlannerContributor(habitsRepository);
    final items = await contributor.contributions().first;

    final yesterdayItem = items.where(
      (i) => isSameDay(i.scheduledAt, yesterday),
    );
    expect(yesterdayItem, hasLength(1));
    expect(yesterdayItem.single.isCompleted, isTrue);
  });
}
