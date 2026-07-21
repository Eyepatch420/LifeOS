import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';
import 'package:lifeos/features/reminders/domain/events/reminder_events.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late RemindersRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = RemindersRepository(db.remindersDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchAll is empty before any reminder is created', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test(
    'create adds a reminder retrievable by id, defaulting to no recurrence',
    () async {
      await repository.create(
        id: 'r1',
        title: 'Pay rent',
        dueAt: DateTime(2026, 1, 1, 9),
        isUrgent: true,
      );

      final reminder = await repository.getById('r1');
      expect(reminder, isNotNull);
      expect(reminder!.title, 'Pay rent');
      expect(reminder.isUrgent, isTrue);
      expect(reminder.isCompleted, isFalse);
      expect(reminder.recurrence, RecurrenceRule.none);
      expect(reminder.customRule, isNull);
    },
  );

  test('create persists a non-default recurrence rule', () async {
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(2026, 1, 1, 9),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );

    final reminder = await repository.getById('r1');
    expect(reminder!.recurrence, RecurrenceRule.daily);
  });

  test('create emits a ReminderCreated event carrying title/dueAt', () async {
    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    final dueAt = DateTime(2026, 1, 1, 9);
    await repository.create(
      id: 'r1',
      title: 'Title',
      dueAt: dueAt,
      isUrgent: false,
    );
    await pumpEventQueue();

    expect(events, hasLength(1));
    final event = events.single as ReminderCreated;
    expect(event.sourceModule, 'reminders');
    expect(event.sourceId, 'r1');
    expect(event.title, 'Title');
    expect(event.dueAt, dueAt);
    await sub.cancel();
  });

  test(
    'update changes title/dueAt/recurrence and emits ReminderUpdated',
    () async {
      await repository.create(
        id: 'r1',
        title: 'Old',
        dueAt: DateTime(2026, 1, 1),
        isUrgent: false,
      );

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      final newDueAt = DateTime(2026, 2, 1);
      await repository.update(
        id: 'r1',
        title: 'New',
        dueAt: newDueAt,
        isUrgent: true,
        recurrence: RecurrenceRule.weekly,
        category: ReminderCategory.other,
      );
      await pumpEventQueue();

      final reminder = await repository.getById('r1');
      expect(reminder!.title, 'New');
      expect(reminder.dueAt, newDueAt);
      expect(reminder.isUrgent, isTrue);
      expect(reminder.recurrence, RecurrenceRule.weekly);

      expect(events, hasLength(1));
      final event = events.single as ReminderUpdated;
      expect(event.title, 'New');
      expect(event.dueAt, newDueAt);
      await sub.cancel();
    },
  );

  test(
    'setCompleted(true) marks completed, sets completedAt, and emits ReminderCompleted',
    () async {
      await repository.create(
        id: 'r1',
        title: 'Title',
        dueAt: DateTime(2026, 1, 1),
        isUrgent: false,
      );

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      await repository.setCompleted('r1', true);
      await pumpEventQueue();

      final reminder = await repository.getById('r1');
      expect(reminder!.isCompleted, isTrue);
      expect(reminder.completedAt, isNotNull);

      expect(events, hasLength(1));
      expect(events.single, isA<ReminderCompleted>());
      await sub.cancel();
    },
  );

  test(
    'setCompleted(false) after completion re-emits ReminderUpdated (reschedulable)',
    () async {
      await repository.create(
        id: 'r1',
        title: 'Title',
        dueAt: DateTime(2026, 1, 1),
        isUrgent: false,
      );
      await repository.setCompleted('r1', true);

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      await repository.setCompleted('r1', false);
      await pumpEventQueue();

      final reminder = await repository.getById('r1');
      expect(reminder!.isCompleted, isFalse);
      expect(reminder.completedAt, isNull);

      expect(events, hasLength(1));
      expect(events.single, isA<ReminderUpdated>());
      await sub.cancel();
    },
  );

  test('setCompleted(true) on a DAILY recurring reminder advances dueAt to the '
      'next day, stays pending, and emits ReminderUpdated instead of '
      'ReminderCompleted', () async {
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(2026, 6, 15, 9),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );

    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.setCompleted('r1', true);
    await pumpEventQueue();

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isFalse);
    expect(reminder.completedAt, isNull);
    expect(reminder.dueAt, DateTime(2026, 6, 16, 9));
    expect(reminder.recurrence, RecurrenceRule.daily);

    expect(events, hasLength(1));
    final event = events.single;
    expect(event, isA<ReminderUpdated>());
    expect((event as ReminderUpdated).dueAt, DateTime(2026, 6, 16, 9));
    await sub.cancel();
  });

  test('setCompleted(true) on a MONTHLY recurring reminder advances dueAt by '
      'one calendar month', () async {
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 31, 9),
      isUrgent: false,
      recurrence: RecurrenceRule.monthly,
    );

    await repository.setCompleted('r1', true);

    final reminder = await repository.getById('r1');
    expect(reminder!.dueAt, DateTime(2026, 2, 28, 9));
    expect(reminder.isCompleted, isFalse);
  });

  test('setCompleted(true) on a CUSTOM recurring reminder (no defined rule '
      'language) falls back to permanent completion instead of silently '
      'doing nothing', () async {
    await repository.create(
      id: 'r1',
      title: 'Undefined custom rule',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
      recurrence: RecurrenceRule.custom,
    );

    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.setCompleted('r1', true);
    await pumpEventQueue();

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isTrue);
    expect(reminder.completedAt, isNotNull);
    expect(events.single, isA<ReminderCompleted>());
    await sub.cancel();
  });

  test('completing successive DAILY occurrences advances dueAt each time, '
      'never becoming permanently completed', () async {
    await repository.create(
      id: 'r1',
      title: 'Water plants',
      dueAt: DateTime(2026, 6, 15, 8),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );

    await repository.setCompleted('r1', true);
    var reminder = await repository.getById('r1');
    expect(reminder!.dueAt, DateTime(2026, 6, 16, 8));

    await repository.setCompleted('r1', true);
    reminder = await repository.getById('r1');
    expect(reminder!.dueAt, DateTime(2026, 6, 17, 8));
    expect(reminder.isCompleted, isFalse);
  });

  test(
    'delete + restore round-trips (soft delete) and emits ReminderDeleted',
    () async {
      await repository.create(
        id: 'r1',
        title: 'Title',
        dueAt: DateTime(2026, 1, 1),
        isUrgent: false,
      );

      final events = <DomainEvent>[];
      final sub = eventBus.events.listen(events.add);

      await repository.delete('r1');
      await pumpEventQueue();
      expect(await repository.getById('r1'), isNull);
      expect(events, hasLength(1));
      expect(events.single, isA<ReminderDeleted>());

      await repository.restore('r1');
      expect(await repository.getById('r1'), isNotNull);
      await sub.cancel();
    },
  );
}
