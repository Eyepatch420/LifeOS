import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/activity/data/repositories/activity_repository.dart';
import 'package:lifeos/features/activity/domain/events/activity_events.dart';
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
  late ActivityRepository repository;
  final events = <DomainEvent>[];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 3, 20));
    final prefs = PreferencesService(await SharedPreferences.getInstance());
    repository = ActivityRepository(
      db.dailyActivityDao,
      eventBus,
      clock,
      prefs,
    );
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test(
    'setTodaySteps creates today\'s aggregate and emits ActivityUpdated',
    () async {
      await repository.setTodaySteps(steps: 7842);
      await pumpEventQueue();

      final today = await repository.watchToday().first;
      expect(today?.steps, 7842);
      expect(today?.dayKey, '2026-01-03');
      expect(events.whereType<ActivityUpdated>(), hasLength(1));
    },
  );

  test('setTodaySteps on the same day updates in place, not append', () async {
    await repository.setTodaySteps(steps: 3000);
    await repository.setTodaySteps(steps: 7842);

    final all = await repository.watchRecent(10).first;
    expect(all, hasLength(1));
    expect(all.single.steps, 7842);
  });

  test('setTodaySteps rejects negative steps', () async {
    expect(() => repository.setTodaySteps(steps: -1), throwsArgumentError);
  });

  test('watchRecent returns days newest first across local-day keys', () async {
    await repository.setTodaySteps(steps: 5000);
    clock.set(DateTime(2026, 1, 4, 8));
    await repository.setTodaySteps(steps: 6000);
    clock.set(DateTime(2026, 1, 5, 8));
    await repository.setTodaySteps(steps: 7842);

    final recent = await repository.watchRecent(3).first;
    expect(recent.map((e) => e.dayKey), [
      '2026-01-05',
      '2026-01-04',
      '2026-01-03',
    ]);
  });

  test('watchToday returns null once the local day has advanced past the '
      'last recorded day', () async {
    await repository.setTodaySteps(steps: 5000);
    clock.set(DateTime(2026, 1, 4, 8));

    expect(await repository.watchToday().first, isNull);
  });

  test('goal defaults, persists, and rejects non-positive values', () async {
    expect(repository.getGoalSteps(), kDefaultActivityGoalSteps);

    await repository.setGoalSteps(12000);
    expect(repository.getGoalSteps(), 12000);

    expect(() => repository.setGoalSteps(0), throwsArgumentError);
  });
}
