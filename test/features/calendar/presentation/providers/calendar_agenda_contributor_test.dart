import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/calendar/data/repositories/events_repository.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_agenda_contributor.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late EventsRepository repository;
  late CalendarAgendaContributor contributor;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = EventsRepository(db.eventsDao, eventBus);
    contributor = CalendarAgendaContributor(repository);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('an upcoming event is included as an AgendaEntry', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime.now().add(const Duration(hours: 1)),
      isAllDay: false,
    );

    final entries = await contributor.contributions().first;
    expect(entries, hasLength(1));
    expect(entries.single.title, 'Standup');
    expect(entries.single.sourceModule, 'calendar');
    expect(entries.single.isAllDay, isFalse);
  });

  test('an ongoing event (started, not yet ended) is included', () async {
    await repository.create(
      id: 'e1',
      title: 'Ongoing Meeting',
      startAt: DateTime.now().subtract(const Duration(minutes: 10)),
      endAt: DateTime.now().add(const Duration(minutes: 10)),
      isAllDay: false,
    );

    final entries = await contributor.contributions().first;
    expect(entries, hasLength(1));
  });

  test('a past event is excluded', () async {
    await repository.create(
      id: 'e1',
      title: 'Yesterday',
      startAt: DateTime.now().subtract(const Duration(days: 1)),
      isAllDay: false,
    );

    final entries = await contributor.contributions().first;
    expect(entries, isEmpty);
  });

  test(
    'an all-day event covering today is included with isAllDay true',
    () async {
      await repository.create(
        id: 'e1',
        title: 'Conference',
        startAt: DateTime.now(),
        isAllDay: true,
      );

      final entries = await contributor.contributions().first;
      expect(entries, hasLength(1));
      expect(entries.single.isAllDay, isTrue);
    },
  );

  test('editing an event updates the Agenda reactively', () async {
    await repository.create(
      id: 'e1',
      title: 'Old',
      startAt: DateTime.now().add(const Duration(hours: 1)),
      isAllDay: false,
    );

    await repository.update(
      id: 'e1',
      title: 'New',
      startAt: DateTime.now().add(const Duration(hours: 2)),
      isAllDay: false,
    );

    final entries = await contributor.contributions().first;
    expect(entries.single.title, 'New');
  });

  test('deleting an event removes it from the Agenda', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime.now().add(const Duration(hours: 1)),
      isAllDay: false,
    );

    await repository.delete('e1');

    final entries = await contributor.contributions().first;
    expect(entries, isEmpty);
  });

  test('dismiss is a no-op (events have no dismiss concept)', () async {
    await repository.create(
      id: 'e1',
      title: 'Standup',
      startAt: DateTime.now().add(const Duration(hours: 1)),
      isAllDay: false,
    );

    await contributor.dismiss('e1');

    final entries = await contributor.contributions().first;
    expect(entries, hasLength(1));
  });
}
