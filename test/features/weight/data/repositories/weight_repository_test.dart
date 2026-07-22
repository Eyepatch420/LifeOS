import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/weight/data/repositories/weight_repository.dart';
import 'package:lifeos/features/weight/domain/events/weight_events.dart';

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
  late WeightRepository repository;
  final events = <DomainEvent>[];

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    repository = WeightRepository(db.weightEntriesDao, eventBus, clock);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test(
    'log adds a new entry with a decimal weight and emits WeightLogged',
    () async {
      await repository.log(id: 'w1', weightKg: 64.25);
      await pumpEventQueue();

      final all = await repository.watchAll().first;
      expect(all, hasLength(1));
      expect(all.single.weightKg, 64.25);
      expect(events.whereType<WeightLogged>(), hasLength(1));
    },
  );

  test('log rejects a zero or negative weight', () async {
    expect(() => repository.log(id: 'w1', weightKg: 0), throwsArgumentError);
    expect(() => repository.log(id: 'w1', weightKg: -5), throwsArgumentError);
  });

  test('update changes the weight and emits WeightUpdated', () async {
    await repository.log(id: 'w1', weightKg: 65);
    await pumpEventQueue();
    events.clear();

    await repository.update(id: 'w1', weightKg: 64.2);
    await pumpEventQueue();

    final entry = await repository.getById('w1');
    expect(entry?.weightKg, 64.2);
    expect(events.whereType<WeightUpdated>(), hasLength(1));
  });

  test('watchLatest returns the most recent measurement', () async {
    await repository.log(id: 'w1', weightKg: 65);
    clock.set(DateTime(2026, 1, 5));
    await repository.log(id: 'w2', weightKg: 64.2);

    final latest = await repository.watchLatest().first;
    expect(latest?.id, 'w2');
    expect(latest?.weightKg, 64.2);
  });

  test('delete removes the entry and emits WeightDeleted', () async {
    await repository.log(id: 'w1', weightKg: 65);
    await pumpEventQueue();
    events.clear();

    await repository.delete('w1');
    await pumpEventQueue();

    expect(await repository.getById('w1'), isNull);
    expect(events.whereType<WeightDeleted>(), hasLength(1));
  });
}
