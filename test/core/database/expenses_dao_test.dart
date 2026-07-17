import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('watchAll orders by occurredAt descending', () async {
    final now = DateTime.now();
    await db.expensesDao.upsert(
      ExpensesCompanion.insert(
        id: 'old',
        title: 'Old',
        amount: 10,
        category: 'Food',
        occurredAt: now.subtract(const Duration(days: 1)),
      ),
    );
    await db.expensesDao.upsert(
      ExpensesCompanion.insert(
        id: 'new',
        title: 'New',
        amount: 5,
        category: 'Food',
        occurredAt: now,
      ),
    );

    final all = await db.expensesDao.watchAll().first;
    expect(all.map((e) => e.id), ['new', 'old']);
  });

  test('softDelete excludes from watchAll and getById', () async {
    final now = DateTime.now();
    await db.expensesDao.upsert(
      ExpensesCompanion.insert(
        id: 'e1',
        title: 'Title',
        amount: 5,
        category: 'Food',
        occurredAt: now,
      ),
    );

    await db.expensesDao.softDelete('e1');

    expect(await db.expensesDao.watchAll().first, isEmpty);
    expect(await db.expensesDao.getById('e1'), isNull);
  });

  test('restore brings a soft-deleted expense back', () async {
    final now = DateTime.now();
    await db.expensesDao.upsert(
      ExpensesCompanion.insert(
        id: 'e1',
        title: 'Title',
        amount: 5,
        category: 'Food',
        occurredAt: now,
      ),
    );
    await db.expensesDao.softDelete('e1');
    await db.expensesDao.restore('e1');

    expect(await db.expensesDao.getById('e1'), isNotNull);
  });
}
