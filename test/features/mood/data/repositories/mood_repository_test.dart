import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/features/mood/data/repositories/mood_repository.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';
import 'package:lifeos/features/mood/domain/events/mood_events.dart';

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
  late MoodRepository repository;
  final events = <DomainEvent>[];

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    events.clear();
    eventBus.events.listen(events.add);
    clock = _FakeClock(DateTime(2026, 1, 1, 9));
    repository = MoodRepository(db.moodEntriesDao, eventBus, clock);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('log adds a new entry and emits MoodLogged', () async {
    await repository.log(id: 'e1', level: MoodLevel.good, note: 'Feeling good');
    await pumpEventQueue();

    final all = await repository.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.level, MoodLevel.good);
    expect(all.single.note, 'Feeling good');
    expect(events.whereType<MoodLogged>(), hasLength(1));
  });

  test(
    'logging twice in the same day appends rather than overwriting',
    () async {
      await repository.log(id: 'e1', level: MoodLevel.bad);
      clock.set(DateTime(2026, 1, 1, 18));
      await repository.log(id: 'e2', level: MoodLevel.great);

      final all = await repository.watchAll().first;
      expect(all, hasLength(2));
    },
  );

  test(
    'watchToday only returns entries recorded on the current local day',
    () async {
      await repository.log(
        id: 'e1',
        level: MoodLevel.neutral,
        recordedAt: DateTime(2025, 12, 31, 9),
      );
      await repository.log(id: 'e2', level: MoodLevel.good);

      final today = await repository.watchToday().first;
      expect(today, hasLength(1));
      expect(today.single.id, 'e2');
    },
  );

  test('update changes level/note and emits MoodUpdated', () async {
    await repository.log(id: 'e1', level: MoodLevel.bad);
    await pumpEventQueue();
    events.clear();

    await repository.update(
      id: 'e1',
      level: MoodLevel.great,
      note: 'Better now',
    );
    await pumpEventQueue();

    final entry = await repository.getById('e1');
    expect(entry?.level, MoodLevel.great);
    expect(entry?.note, 'Better now');
    expect(events.whereType<MoodUpdated>(), hasLength(1));
  });

  test('delete removes the entry and emits MoodDeleted', () async {
    await repository.log(id: 'e1', level: MoodLevel.bad);
    await pumpEventQueue();
    events.clear();

    await repository.delete('e1');
    await pumpEventQueue();

    expect(await repository.getById('e1'), isNull);
    expect(events.whereType<MoodDeleted>(), hasLength(1));
  });
}
