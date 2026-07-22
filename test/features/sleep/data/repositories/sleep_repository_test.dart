import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/sleep/data/repositories/sleep_repository.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_quality.dart';
import 'package:lifeos/features/sleep/domain/events/sleep_events.dart';

class _FakeClock implements ClockManager {
  _FakeClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late _FakeClock clock;
  late SleepRepository repository;
  final events = <DomainEvent>[];

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 2, 7));
    repository = SleepRepository(db.sleepEntriesDao, eventBus, clock);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('log creates a record and emits SleepLogged', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 23),
      wakeTime: DateTime(2026, 1, 2, 7),
      quality: SleepQuality.good,
    );
    await pumpEventQueue();

    final all = await repository.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.quality, SleepQuality.good);
    expect(events.whereType<SleepLogged>(), hasLength(1));
  });

  test('an overnight bedtime->wake crossing midnight yields a positive '
      'duration, not a negative one', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 23),
      wakeTime: DateTime(2026, 1, 2, 7),
    );

    final entry = await repository.getById('s1');
    expect(entry!.duration, const Duration(hours: 8));
  });

  test('sleepDay is the wake date, not the bedtime date', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 23, 30),
      wakeTime: DateTime(2026, 1, 2, 7),
    );

    final entry = await repository.getById('s1');
    expect(entry!.sleepDay, DateTime(2026, 1, 2));
  });

  test('log rejects a wake time at or before bedtime', () async {
    expect(
      () => repository.log(
        id: 's1',
        bedtime: DateTime(2026, 1, 1, 23),
        wakeTime: DateTime(2026, 1, 1, 22),
      ),
      throwsArgumentError,
    );
    expect(
      () => repository.log(
        id: 's1',
        bedtime: DateTime(2026, 1, 1, 23),
        wakeTime: DateTime(2026, 1, 1, 23),
      ),
      throwsArgumentError,
    );
  });

  test('update changes bedtime/wake/quality, recalculating duration, and '
      'emits SleepUpdated', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 23),
      wakeTime: DateTime(2026, 1, 2, 7),
    );
    await pumpEventQueue();
    events.clear();

    await repository.update(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 22),
      wakeTime: DateTime(2026, 1, 2, 6),
      quality: SleepQuality.great,
    );
    await pumpEventQueue();

    final entry = await repository.getById('s1');
    expect(entry!.duration, const Duration(hours: 8));
    expect(entry.quality, SleepQuality.great);
    expect(events.whereType<SleepUpdated>(), hasLength(1));
  });

  test('watchLatest returns the most recently logged record', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2025, 12, 30, 23),
      wakeTime: DateTime(2025, 12, 31, 7),
    );
    await repository.log(
      id: 's2',
      bedtime: DateTime(2026, 1, 1, 23),
      wakeTime: DateTime(2026, 1, 2, 7),
    );

    final latest = await repository.watchLatest().first;
    expect(latest?.id, 's2');
  });

  test('delete removes the record and emits SleepDeleted', () async {
    await repository.log(
      id: 's1',
      bedtime: DateTime(2026, 1, 1, 23),
      wakeTime: DateTime(2026, 1, 2, 7),
    );
    await pumpEventQueue();
    events.clear();

    await repository.delete('s1');
    await pumpEventQueue();

    expect(await repository.getById('s1'), isNull);
    expect(events.whereType<SleepDeleted>(), hasLength(1));
  });
}
