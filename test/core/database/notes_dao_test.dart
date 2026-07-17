import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('watchAll is empty before any note is inserted', () async {
    expect(await db.notesDao.watchAll().first, isEmpty);
  });

  test('upsert inserts a new note; getById returns it', () async {
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Title',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final note = await db.notesDao.getById('n1');
    expect(note, isNotNull);
    expect(note!.title, 'Title');
    expect(note.isPinned, isFalse);
  });

  test('upsert on an existing id updates rather than duplicates', () async {
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Original',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Updated',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final all = await db.notesDao.watchAll().first;
    expect(all, hasLength(1));
    expect(all.single.title, 'Updated');
  });

  test('softDelete excludes the note from watchAll and getById', () async {
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Title',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await db.notesDao.softDelete('n1');

    expect(await db.notesDao.watchAll().first, isEmpty);
    expect(await db.notesDao.getById('n1'), isNull);
  });

  test('restore brings a soft-deleted note back', () async {
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Title',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.notesDao.softDelete('n1');
    await db.notesDao.restore('n1');

    expect(await db.notesDao.getById('n1'), isNotNull);
  });

  test('watchAll orders pinned notes first, then by updatedAt desc', () async {
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'old',
        title: 'Old',
        body: '',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    );
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'new',
        title: 'New',
        body: '',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.notesDao.setPinned('old', true);

    final all = await db.notesDao.watchAll().first;
    expect(all.map((n) => n.id), ['old', 'new']);
  });

  test('watchAll emits again after a mutation', () async {
    final emissions = <int>[];
    final sub = db.notesDao.watchAll().listen((notes) {
      emissions.add(notes.length);
    });

    await pumpEventQueue();
    final now = DateTime.now();
    await db.notesDao.upsert(
      NotesCompanion.insert(
        id: 'n1',
        title: 'Title',
        body: 'Body',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await pumpEventQueue();

    expect(emissions, [0, 1]);
    await sub.cancel();
  });
}
