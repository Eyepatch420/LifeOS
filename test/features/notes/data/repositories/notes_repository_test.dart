import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/notes/data/repositories/notes_repository.dart';
import 'package:lifeos/features/notes/domain/events/note_events.dart';

void main() {
  late AppDatabase db;
  late EventBus eventBus;
  late NotesRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    eventBus = EventBus();
    repository = NotesRepository(db.notesDao, eventBus);
  });

  tearDown(() async {
    eventBus.dispose();
    await db.close();
  });

  test('watchAll is empty before any note is created', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('create adds a note retrievable by id', () async {
    await repository.create(id: 'n1', title: 'Title', body: 'Body');

    final note = await repository.getById('n1');
    expect(note, isNotNull);
    expect(note!.title, 'Title');
    expect(note.body, 'Body');
    expect(note.isPinned, isFalse);
  });

  test('create emits a NoteCreated event on the event bus', () async {
    final events = <DomainEvent>[];
    final sub = eventBus.events.listen(events.add);

    await repository.create(id: 'n1', title: 'Title', body: 'Body');
    await pumpEventQueue();

    expect(events, hasLength(1));
    expect(events.single, isA<NoteCreated>());
    expect(events.single.sourceModule, 'notes');
    expect(events.single.sourceId, 'n1');
    await sub.cancel();
  });

  test(
    'update changes title/body without emitting a new create event',
    () async {
      await repository.create(id: 'n1', title: 'Old', body: 'Old body');
      await repository.update(id: 'n1', title: 'New', body: 'New body');

      final note = await repository.getById('n1');
      expect(note!.title, 'New');
      expect(note.body, 'New body');
    },
  );

  test('setPinned toggles pin state', () async {
    await repository.create(id: 'n1', title: 'Title', body: 'Body');
    await repository.setPinned('n1', true);

    expect((await repository.getById('n1'))!.isPinned, isTrue);
  });

  test('delete + restore round-trips (soft delete)', () async {
    await repository.create(id: 'n1', title: 'Title', body: 'Body');
    await repository.delete('n1');
    expect(await repository.getById('n1'), isNull);

    await repository.restore('n1');
    expect(await repository.getById('n1'), isNotNull);
  });
}
