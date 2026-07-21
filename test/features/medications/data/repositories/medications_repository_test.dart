import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/medications/data/repositories/medications_repository.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/domain/events/medication_events.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime value) => _now = value;
}

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late _FakeClock clock;
  late MedicationsRepository repository;
  final events = <DomainEvent>[];

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    // A weekday (Thursday) so weekday-restricted schedule tests below have
    // a deterministic "today is/isn't eligible" baseline.
    clock = _FakeClock(DateTime(2026, 1, 1, 7)); // Thursday, 07:00
    repository = MedicationsRepository(db.medicationsDao, eventBus, clock);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  MedicationScheduleChanged lastChange() =>
      events.whereType<MedicationScheduleChanged>().last;

  test('creating a medication with multiple times schedules multiple distinct '
      'slot ids, none colliding', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [
          MedicationTime(hour: 9, minute: 0),
          MedicationTime(hour: 21, minute: 0),
        ],
      ),
    );
    await pumpEventQueue();

    final change = lastChange();
    expect(change.oldSlotIds, isEmpty);
    final slotIds = change.newSlots.map((s) => s.slotId).toSet();
    expect(slotIds, {'m1:09:00', 'm1:21:00'});
    expect(slotIds.length, 2);
  });

  test('two medications scheduled at the same time-of-day get distinct slot '
      'ids (medication id is embedded in the composite key)', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
      ),
    );
    await pumpEventQueue();
    await repository.create(
      id: 'm2',
      name: 'Iron',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
      ),
    );
    await pumpEventQueue();

    final slotIds = events
        .whereType<MedicationScheduleChanged>()
        .expand((e) => e.newSlots.map((s) => s.slotId))
        .toSet();
    expect(slotIds, {'m1:09:00', 'm2:09:00'});
  });

  test('changing schedule times cancels the obsolete slots and schedules the '
      'replacements, exactly once each', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [
          MedicationTime(hour: 9, minute: 0),
          MedicationTime(hour: 21, minute: 0),
        ],
      ),
    );
    await pumpEventQueue();
    events.clear();

    await repository.update(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [
          MedicationTime(hour: 10, minute: 0),
          MedicationTime(hour: 20, minute: 0),
        ],
      ),
    );
    await pumpEventQueue();

    final change = lastChange();
    expect(change.oldSlotIds.toSet(), {'m1:09:00', 'm1:21:00'});
    final newIds = change.newSlots.map((s) => s.slotId).toSet();
    expect(newIds, {'m1:10:00', 'm1:20:00'});
    // Old ids don't leak into the new set — a pure contributor mapping
    // this event would cancel exactly the removed ones.
    expect(newIds.intersection(change.oldSlotIds.toSet()), isEmpty);
  });

  test('changing from daily to selected weekdays cancels the always-slot and '
      'schedules the weekday-scoped replacement', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
      ),
    );
    await pumpEventQueue();
    events.clear();

    await repository.update(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
        days: {DateTime.monday, DateTime.wednesday, DateTime.friday},
      ),
    );
    await pumpEventQueue();

    final change = lastChange();
    // Same time-of-day, so the slot id itself is unchanged (id doesn't
    // encode weekday) — but a fresh event must still have been emitted
    // with the new schedule reflected in the recomputed occurrence.
    expect(change.newSlots.map((s) => s.slotId).toSet(), {'m1:09:00'});
    expect(change.newSlots, hasLength(1));
  });

  test(
    'archiving a medication cancels all its slot ids and schedules nothing',
    () async {
      await repository.create(
        id: 'm1',
        name: 'Vitamin D',
        schedule: const MedicationSchedule(
          times: [
            MedicationTime(hour: 9, minute: 0),
            MedicationTime(hour: 21, minute: 0),
          ],
        ),
      );
      await pumpEventQueue();
      events.clear();

      await repository.archive('m1');
      await pumpEventQueue();

      final change = lastChange();
      expect(change.oldSlotIds.toSet(), {'m1:09:00', 'm1:21:00'});
      expect(change.newSlots, isEmpty);
    },
  );

  test(
    'deleting a medication cancels all its slot ids and schedules nothing',
    () async {
      await repository.create(
        id: 'm1',
        name: 'Vitamin D',
        schedule: const MedicationSchedule(
          times: [MedicationTime(hour: 9, minute: 0)],
        ),
      );
      await pumpEventQueue();
      events.clear();

      await repository.delete('m1');
      await pumpEventQueue();

      final change = lastChange();
      expect(change.oldSlotIds, ['m1:09:00']);
      expect(change.newSlots, isEmpty);
    },
  );

  test('reconcileNotificationsOnStartup called twice in a row emits the same '
      'slots each time, never accumulating duplicates', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
      ),
    );
    await pumpEventQueue();
    events.clear();

    await repository.reconcileNotificationsOnStartup();
    await pumpEventQueue();
    await repository.reconcileNotificationsOnStartup();
    await pumpEventQueue();

    final changes = events.whereType<MedicationScheduleChanged>().toList();
    expect(changes, hasLength(2));
    for (final change in changes) {
      // A reconciliation replay has nothing to diff away — the "cancel"
      // half is empty by construction, only the re-assert half fires.
      expect(change.oldSlotIds, isEmpty);
      expect(change.newSlots.map((s) => s.slotId).toList(), ['m1:09:00']);
    }
  });

  test('reconcileNotificationsOnStartup only re-asserts active (non-archived) '
      'medications', () async {
    await repository.create(
      id: 'm1',
      name: 'Vitamin D',
      schedule: const MedicationSchedule(
        times: [MedicationTime(hour: 9, minute: 0)],
      ),
    );
    await pumpEventQueue();
    await repository.archive('m1');
    await pumpEventQueue();
    events.clear();

    await repository.reconcileNotificationsOnStartup();
    await pumpEventQueue();

    expect(events.whereType<MedicationScheduleChanged>(), isEmpty);
  });
}
