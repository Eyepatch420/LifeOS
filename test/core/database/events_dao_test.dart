import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<void> insertEvent(
    String id, {
    DateTime? startAt,
    bool isAllDay = false,
  }) => db.eventsDao.upsert(
    EventsCompanion.insert(
      id: id,
      title: 'Event $id',
      startAt: startAt ?? DateTime(2026, 7, 20, 9),
      isAllDay: Value(isAllDay),
      createdAt: DateTime.now(),
    ),
  );

  test('watchAll excludes archived events', () async {
    await insertEvent('e1');
    await insertEvent('e2');
    await db.eventsDao.archive('e2');

    final all = await db.eventsDao.watchAll().first;
    expect(all.map((e) => e.id), ['e1']);
  });

  test('watchAll orders by startAt ascending', () async {
    await insertEvent('e2', startAt: DateTime(2026, 7, 20, 15));
    await insertEvent('e1', startAt: DateTime(2026, 7, 20, 9));

    final all = await db.eventsDao.watchAll().first;
    expect(all.map((e) => e.id), ['e1', 'e2']);
  });

  test('getById returns null for an archived event', () async {
    await insertEvent('e1');
    await db.eventsDao.archive('e1');

    final row = await db.eventsDao.getById('e1');
    expect(row, isNull);
  });

  test('restore un-archives an event', () async {
    await insertEvent('e1');
    await db.eventsDao.archive('e1');
    await db.eventsDao.restore('e1');

    final all = await db.eventsDao.watchAll().first;
    expect(all.map((e) => e.id), ['e1']);
  });

  test(
    'upsert with an existing id updates in place, not a duplicate',
    () async {
      await insertEvent('e1');
      await db.eventsDao.upsert(
        EventsCompanion.insert(
          id: 'e1',
          title: 'Updated title',
          startAt: DateTime(2026, 7, 21, 10),
          createdAt: DateTime.now(),
        ),
      );

      final all = await db.eventsDao.watchAll().first;
      expect(all, hasLength(1));
      expect(all.single.title, 'Updated title');
    },
  );

  test('isAllDay defaults to false', () async {
    await insertEvent('e1');
    final row = await db.eventsDao.getById('e1');
    expect(row!.isAllDay, isFalse);
  });
}
