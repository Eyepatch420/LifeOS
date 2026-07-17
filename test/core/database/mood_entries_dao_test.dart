import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('upsertForDate inserts a new entry for a fresh date', () async {
    await db.moodEntriesDao.upsertForDate(
      localDate: '2026-07-16',
      newId: () => 'm1',
      score: 4,
    );

    final entry = await db.moodEntriesDao.getByDate('2026-07-16');
    expect(entry, isNotNull);
    expect(entry!.score, 4);
  });

  test(
    'upsertForDate overwrites rather than duplicates the same day',
    () async {
      await db.moodEntriesDao.upsertForDate(
        localDate: '2026-07-16',
        newId: () => 'm1',
        score: 2,
      );
      await db.moodEntriesDao.upsertForDate(
        localDate: '2026-07-16',
        newId: () => 'm2',
        score: 5,
        note: 'Better now',
      );

      final all = await db.moodEntriesDao.watchAll().first;
      expect(all, hasLength(1));
      expect(all.single.score, 5);
      expect(all.single.note, 'Better now');
    },
  );

  test('watchAll orders by localDate descending', () async {
    await db.moodEntriesDao.upsertForDate(
      localDate: '2026-07-14',
      newId: () => 'm1',
      score: 3,
    );
    await db.moodEntriesDao.upsertForDate(
      localDate: '2026-07-16',
      newId: () => 'm2',
      score: 3,
    );

    final all = await db.moodEntriesDao.watchAll().first;
    expect(all.map((e) => e.localDate), ['2026-07-16', '2026-07-14']);
  });
}
