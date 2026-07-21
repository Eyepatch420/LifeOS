import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('insert adds a new entry', () async {
    final recordedAt = DateTime(2026, 7, 16, 9);
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm1',
        moodLevel: 'good',
        recordedAt: recordedAt,
        createdAt: recordedAt,
      ),
    );

    final entry = await db.moodEntriesDao.getById('m1');
    expect(entry, isNotNull);
    expect(entry!.moodLevel, 'good');
  });

  test('insert appends rather than overwriting a same-day entry', () async {
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm1',
        moodLevel: 'bad',
        recordedAt: DateTime(2026, 7, 16, 8),
        createdAt: DateTime(2026, 7, 16, 8),
      ),
    );
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm2',
        moodLevel: 'great',
        note: const Value('Better now'),
        recordedAt: DateTime(2026, 7, 16, 18),
        createdAt: DateTime(2026, 7, 16, 18),
      ),
    );

    final all = await db.moodEntriesDao.watchAll().first;
    expect(all, hasLength(2));
  });

  test('watchAll orders by recordedAt descending', () async {
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm1',
        moodLevel: 'neutral',
        recordedAt: DateTime(2026, 7, 14),
        createdAt: DateTime(2026, 7, 14),
      ),
    );
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm2',
        moodLevel: 'neutral',
        recordedAt: DateTime(2026, 7, 16),
        createdAt: DateTime(2026, 7, 16),
      ),
    );

    final all = await db.moodEntriesDao.watchAll().first;
    expect(all.map((e) => e.id), ['m2', 'm1']);
  });

  test('deleteById removes the entry', () async {
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm1',
        moodLevel: 'good',
        recordedAt: DateTime(2026, 7, 16),
        createdAt: DateTime(2026, 7, 16),
      ),
    );
    await db.moodEntriesDao.deleteById('m1');

    final all = await db.moodEntriesDao.watchAll().first;
    expect(all, isEmpty);
  });

  test('updateFields overwrites the note', () async {
    await db.moodEntriesDao.insert(
      MoodEntriesCompanion.insert(
        id: 'm1',
        moodLevel: 'good',
        recordedAt: DateTime(2026, 7, 16),
        createdAt: DateTime(2026, 7, 16),
      ),
    );
    await db.moodEntriesDao.updateFields(
      'm1',
      const MoodEntriesCompanion(note: Value('Edited note')),
    );

    final entry = await db.moodEntriesDao.getById('m1');
    expect(entry!.note, 'Edited note');
  });
}
