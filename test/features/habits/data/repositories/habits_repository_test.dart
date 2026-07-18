import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/domain/events/habit_events.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late HabitsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = HabitsRepository(db.habitsDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchAll is empty before any habit is created', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('create adds a daily habit retrievable by id', () async {
    await repository.create(
      id: 'h1',
      title: 'Morning Walk',
      schedule: const HabitSchedule.daily(),
      icon: 'walk',
    );

    final habit = await repository.getById('h1');
    expect(habit, isNotNull);
    expect(habit!.title, 'Morning Walk');
    expect(habit.schedule.isDaily, isTrue);
    expect(habit.archivedAt, isNull);
  });

  test('create persists a weekly schedule with specific weekdays', () async {
    await repository.create(
      id: 'h1',
      title: 'Gym',
      schedule: HabitSchedule.weekly({1, 3, 5}),
      icon: 'gym',
    );

    final habit = await repository.getById('h1');
    expect(habit!.schedule.isDaily, isFalse);
    expect(habit.schedule.weekdays, {1, 3, 5});
  });

  test('create emits a HabitCreated event carrying title', () async {
    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.create(
      id: 'h1',
      title: 'Read',
      schedule: const HabitSchedule.daily(),
      icon: 'book',
    );
    await pumpEventQueue();

    expect(events, hasLength(1));
    final event = events.single as HabitCreated;
    expect(event.sourceModule, 'habits');
    expect(event.sourceId, 'h1');
    expect(event.title, 'Read');
    await sub.cancel();
  });

  test('update changes title/schedule and emits HabitUpdated', () async {
    await repository.create(
      id: 'h1',
      title: 'Old',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );

    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.update(
      id: 'h1',
      title: 'New',
      schedule: HabitSchedule.weekly({2, 4}),
      icon: 'star',
    );
    await pumpEventQueue();

    final habit = await repository.getById('h1');
    expect(habit!.title, 'New');
    expect(habit.schedule.weekdays, {2, 4});

    expect(events, hasLength(1));
    expect(events.single, isA<HabitUpdated>());
    await sub.cancel();
  });

  test(
    'setCompletedForDate(completed: true) records completion and emits HabitCompleted',
    () async {
      await repository.create(
        id: 'h1',
        title: 'Title',
        schedule: const HabitSchedule.daily(),
        icon: 'star',
      );

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      await repository.setCompletedForDate(
        'h1',
        DateTime(2026, 7, 16),
        completed: true,
      );
      await pumpEventQueue();

      final completions = await repository.watchCompletionDates('h1').first;
      expect(completions, {DateTime(2026, 7, 16)});

      expect(events, hasLength(1));
      final event = events.single as HabitCompleted;
      expect(event.localDate, '2026-07-16');
      await sub.cancel();
    },
  );

  test(
    'setCompletedForDate is idempotent — completing twice does not duplicate',
    () async {
      await repository.create(
        id: 'h1',
        title: 'Title',
        schedule: const HabitSchedule.daily(),
        icon: 'star',
      );

      await repository.setCompletedForDate(
        'h1',
        DateTime(2026, 7, 16),
        completed: true,
      );
      await repository.setCompletedForDate(
        'h1',
        DateTime(2026, 7, 16),
        completed: true,
      );

      final completions = await repository.watchCompletionDates('h1').first;
      expect(completions, hasLength(1));
    },
  );

  test('setCompletedForDate(completed: false) undoes a completion', () async {
    await repository.create(
      id: 'h1',
      title: 'Title',
      schedule: const HabitSchedule.daily(),
      icon: 'star',
    );
    await repository.setCompletedForDate(
      'h1',
      DateTime(2026, 7, 16),
      completed: true,
    );

    await repository.setCompletedForDate(
      'h1',
      DateTime(2026, 7, 16),
      completed: false,
    );

    final completions = await repository.watchCompletionDates('h1').first;
    expect(completions, isEmpty);
  });

  test(
    'archive + restore round-trips and archive emits HabitArchived',
    () async {
      await repository.create(
        id: 'h1',
        title: 'Title',
        schedule: const HabitSchedule.daily(),
        icon: 'star',
      );

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      await repository.archive('h1');
      await pumpEventQueue();

      final active = await repository.watchAll().first;
      expect(active, isEmpty);
      expect(events, hasLength(1));
      expect(events.single, isA<HabitArchived>());

      await repository.restore('h1');
      final restored = await repository.watchAll().first;
      expect(restored, hasLength(1));
      await sub.cancel();
    },
  );
}
