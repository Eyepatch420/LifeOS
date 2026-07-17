import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/reminders/data/repositories/reminders_repository.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
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
