import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('watchAll orders by dueAt ascending', () async {
    final now = DateTime.now();
    await db.remindersDao.upsert(
      RemindersCompanion.insert(
        id: 'later',
        title: 'Later',
        dueAt: now.add(const Duration(days: 1)),
      ),
    );
    await db.remindersDao.upsert(
      RemindersCompanion.insert(id: 'soon', title: 'Soon', dueAt: now),
    );

    final all = await db.remindersDao.watchAll().first;
    expect(all.map((r) => r.id), ['soon', 'later']);
  });

  test('setCompleted sets isCompleted and completedAt', () async {
    final now = DateTime.now();
    await db.remindersDao.upsert(
      RemindersCompanion.insert(id: 'r1', title: 'Title', dueAt: now),
    );

    await db.remindersDao.setCompleted('r1', true);

    final reminder = await db.remindersDao.getById('r1');
    expect(reminder!.isCompleted, isTrue);
    expect(reminder.completedAt, isNotNull);
  });

  test('setCompleted(false) clears completedAt', () async {
    final now = DateTime.now();
    await db.remindersDao.upsert(
      RemindersCompanion.insert(id: 'r1', title: 'Title', dueAt: now),
    );
    await db.remindersDao.setCompleted('r1', true);
    await db.remindersDao.setCompleted('r1', false);

    final reminder = await db.remindersDao.getById('r1');
    expect(reminder!.isCompleted, isFalse);
    expect(reminder.completedAt, isNull);
  });

  test('softDelete + restore round-trips', () async {
    final now = DateTime.now();
    await db.remindersDao.upsert(
      RemindersCompanion.insert(id: 'r1', title: 'Title', dueAt: now),
    );

    await db.remindersDao.softDelete('r1');
    expect(await db.remindersDao.getById('r1'), isNull);

    await db.remindersDao.restore('r1');
    expect(await db.remindersDao.getById('r1'), isNotNull);
  });
}
