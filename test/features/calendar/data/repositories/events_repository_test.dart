import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/domain/events/event_events.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late EventsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = EventsRepository(db.eventsDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchAll is empty before any event is created', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('create adds a timed event retrievable by id', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime(2026, 7, 20, 9),
      endAt: DateTime(2026, 7, 20, 9, 30),
      isAllDay: false,
    );

    final event = await repository.getById('e1');
    expect(event, isNotNull);
    expect(event!.title, 'Standup');
    expect(event.startAt, DateTime(2026, 7, 20, 9));
    expect(event.endAt, DateTime(2026, 7, 20, 9, 30));
    expect(event.isAllDay, isFalse);
  });

  test(
    'create normalizes an all-day event to calendar-date midnights',
    () async {
      await repository.create(
        id: 'e1',
        title: 'Conference',
        startAt: DateTime(2026, 7, 20, 14, 30),
        endAt: DateTime(2026, 7, 22, 9),
        isAllDay: true,
      );

      final event = await repository.getById('e1');
      expect(event!.startAt, DateTime(2026, 7, 20));
      expect(event.endAt, DateTime(2026, 7, 22));
    },
  );

  test('create with no endAt persists a point-in-time event', () async {
    await repository.create(
      id: 'e1',
      title: 'Call',
      startAt: DateTime(2026, 7, 20, 15),
      isAllDay: false,
    );

    final event = await repository.getById('e1');
    expect(event!.endAt, isNull);
  });

  test('create emits an EventCreated event carrying title/startAt', () async {
    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime(2026, 7, 20, 9),
      isAllDay: false,
    );
    await pumpEventQueue();

    expect(events, hasLength(1));
    final event = events.single as EventCreated;
    expect(event.sourceModule, 'calendar');
    expect(event.sourceId, 'e1');
    expect(event.title, 'Standup');
    expect(event.startAt, DateTime(2026, 7, 20, 9));
    await sub.cancel();
  });

  test('update changes title/time and emits EventUpdated', () async {
    await repository.create(
      id: 'e1',
      title: 'Old',
      startAt: DateTime(2026, 7, 20, 9),
      isAllDay: false,
    );

    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.update(
      id: 'e1',
      title: 'New',
      startAt: DateTime(2026, 7, 21, 10),
      isAllDay: false,
    );
    await pumpEventQueue();

    final event = await repository.getById('e1');
    expect(event!.title, 'New');
    expect(event.startAt, DateTime(2026, 7, 21, 10));

    expect(events, hasLength(1));
    expect(events.single, isA<EventUpdated>());
    await sub.cancel();
  });

  test('delete archives (soft-delete) and emits EventDeleted', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime(2026, 7, 20, 9),
      isAllDay: false,
    );

    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.delete('e1');
    await pumpEventQueue();

    final all = await repository.watchAll().first;
    expect(all, isEmpty);
    expect(events, hasLength(1));
    expect(events.single, isA<EventDeleted>());
    await sub.cancel();
  });

  test('restore un-archives a deleted event', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime(2026, 7, 20, 9),
      isAllDay: false,
    );
    await repository.delete('e1');
    await repository.restore('e1');

    final all = await repository.watchAll().first;
    expect(all, hasLength(1));
  });

  test('watchForDate includes a timed event that starts on that day', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime(2026, 7, 20, 9),
      isAllDay: false,
    );

    final onDay = await repository.watchForDate(DateTime(2026, 7, 20)).first;
    expect(onDay.map((e) => e.id), ['e1']);

    final otherDay = await repository.watchForDate(DateTime(2026, 7, 21)).first;
    expect(otherDay, isEmpty);
  });

  test(
    'watchForDate includes an all-day event on every day within its range',
    () async {
      await repository.create(
        id: 'e1',
        title: 'Conference',
        startAt: DateTime(2026, 7, 20),
        endAt: DateTime(2026, 7, 22),
        isAllDay: true,
      );

      for (final day in [
        DateTime(2026, 7, 20),
        DateTime(2026, 7, 21),
        DateTime(2026, 7, 22),
      ]) {
        final events = await repository.watchForDate(day).first;
        expect(events.map((e) => e.id), ['e1'], reason: '$day');
      }

      final before = await repository.watchForDate(DateTime(2026, 7, 19)).first;
      expect(before, isEmpty);
      final after = await repository.watchForDate(DateTime(2026, 7, 23)).first;
      expect(after, isEmpty);
    },
  );
}
