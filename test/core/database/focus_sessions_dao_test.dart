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

  test('watchActive is null when no session is running', () async {
    expect(await db.focusSessionsDao.watchActive().first, isNull);
  });

  test('watchActive returns the session while status is running', () async {
    await db.focusSessionsDao.upsert(
      FocusSessionsCompanion.insert(
        id: 'f1',
        startedAt: DateTime.now(),
        plannedMinutes: 25,
        kind: 'focus',
      ),
    );

    final active = await db.focusSessionsDao.watchActive().first;
    expect(active, isNotNull);
    expect(active!.id, 'f1');
  });

  test('setting status to completed removes it from watchActive', () async {
    final now = DateTime.now();
    await db.focusSessionsDao.upsert(
      FocusSessionsCompanion.insert(
        id: 'f1',
        startedAt: now,
        plannedMinutes: 25,
        kind: 'focus',
      ),
    );

    await db.focusSessionsDao.updateFields(
      'f1',
      FocusSessionsCompanion(
        status: const Value('completed'),
        endedAt: Value(now.add(const Duration(minutes: 25))),
      ),
    );

    expect(await db.focusSessionsDao.watchActive().first, isNull);
    final all = await db.focusSessionsDao.watchAll().first;
    expect(all.single.endedAt, isNotNull);
  });

  test('watchAll orders by startedAt descending', () async {
    final now = DateTime.now();
    await db.focusSessionsDao.upsert(
      FocusSessionsCompanion.insert(
        id: 'old',
        startedAt: now.subtract(const Duration(hours: 1)),
        plannedMinutes: 25,
        kind: 'focus',
      ),
    );
    await db.focusSessionsDao.updateFields(
      'old',
      FocusSessionsCompanion(
        status: const Value('completed'),
        endedAt: Value(now),
      ),
    );
    await db.focusSessionsDao.upsert(
      FocusSessionsCompanion.insert(
        id: 'new',
        startedAt: now,
        plannedMinutes: 25,
        kind: 'focus',
      ),
    );

    final all = await db.focusSessionsDao.watchAll().first;
    expect(all.map((s) => s.id), ['new', 'old']);
  });
}
