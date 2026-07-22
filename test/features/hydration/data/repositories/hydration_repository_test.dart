import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/hydration/data/repositories/hydration_repository.dart';
import 'package:lifeos/features/hydration/domain/events/hydration_events.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late HydrationRepository repository;
  final events = <DomainEvent>[];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    final prefs = PreferencesService(await SharedPreferences.getInstance());
    repository = HydrationRepository(
      db.hydrationEntriesDao,
      eventBus,
      clock,
      prefs,
    );
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('log adds a new entry and emits HydrationLogged', () async {
    await repository.log(id: 'h1', amountMl: 250);
    await pumpEventQueue();

    final all = await repository.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.amountMl, 250);
    expect(events.whereType<HydrationLogged>(), hasLength(1));
  });

  test('log rejects a zero or negative amount', () async {
    expect(() => repository.log(id: 'h1', amountMl: 0), throwsArgumentError);
    expect(() => repository.log(id: 'h1', amountMl: -100), throwsArgumentError);
  });

  test('watchToday sums only entries on the current local day', () async {
    await repository.log(
      id: 'h1',
      amountMl: 500,
      recordedAt: DateTime(2025, 12, 31, 23, 59),
    );
    await repository.log(id: 'h2', amountMl: 250);
    await repository.log(id: 'h3', amountMl: 300);

    final today = await repository.watchToday().first;
    expect(today.map((e) => e.id), containsAll(['h2', 'h3']));
    final total = today.fold<int>(0, (sum, e) => sum + e.amountMl);
    expect(total, 550);
  });

  test('an entry logged just after midnight belongs to the new day', () async {
    await repository.log(
      id: 'h1',
      amountMl: 500,
      recordedAt: DateTime(2026, 1, 1, 23, 59),
    );
    clock.set(DateTime(2026, 1, 2, 0, 1));
    await repository.log(id: 'h2', amountMl: 250);

    final today = await repository.watchToday().first;
    expect(today.map((e) => e.id), ['h2']);
  });

  test('update changes the amount and emits HydrationUpdated', () async {
    await repository.log(id: 'h1', amountMl: 250);
    await pumpEventQueue();
    events.clear();

    await repository.update(id: 'h1', amountMl: 500);
    await pumpEventQueue();

    final entry = await repository.getById('h1');
    expect(entry?.amountMl, 500);
    expect(events.whereType<HydrationUpdated>(), hasLength(1));
  });

  test('update rejects a zero or negative amount', () async {
    await repository.log(id: 'h1', amountMl: 250);
    expect(() => repository.update(id: 'h1', amountMl: 0), throwsArgumentError);
  });

  test('delete removes the entry and emits HydrationDeleted', () async {
    await repository.log(id: 'h1', amountMl: 250);
    await pumpEventQueue();
    events.clear();

    await repository.delete('h1');
    await pumpEventQueue();

    expect(await repository.getById('h1'), isNull);
    expect(events.whereType<HydrationDeleted>(), hasLength(1));
  });

  test('goal defaults, persists, and rejects non-positive values', () async {
    expect(repository.getGoalMl(), kDefaultHydrationGoalMl);

    await repository.setGoalMl(3000);
    expect(repository.getGoalMl(), 3000);

    expect(() => repository.setGoalMl(0), throwsArgumentError);
  });
}
