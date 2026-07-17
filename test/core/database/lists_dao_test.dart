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

  Future<void> insertList(String id) => db.listsDao.upsertList(
    ListsCompanion.insert(
      id: id,
      title: 'List $id',
      kind: 'shopping',
      createdAt: DateTime.now(),
    ),
  );

  test('watchAll excludes archived and soft-deleted lists', () async {
    await insertList('l1');
    await insertList('l2');
    await insertList('l3');
    await db.listsDao.setArchived('l2', true);
    await db.listsDao.softDeleteList('l3');

    final all = await db.listsDao.watchAll().first;
    expect(all.map((l) => l.id), ['l1']);
  });

  test('watchItems orders by sortOrder ascending', () async {
    await insertList('l1');
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(
        id: 'i1',
        listId: 'l1',
        label: 'B',
        sortOrder: const Value(1),
      ),
    );
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(
        id: 'i2',
        listId: 'l1',
        label: 'A',
        sortOrder: const Value(0),
      ),
    );

    final items = await db.listsDao.watchItems('l1').first;
    expect(items.map((i) => i.id), ['i2', 'i1']);
  });

  test('reorderItems rewrites sortOrder to match the given order', () async {
    await insertList('l1');
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i1', listId: 'l1', label: 'A'),
    );
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i2', listId: 'l1', label: 'B'),
    );

    await db.listsDao.reorderItems(['i2', 'i1']);

    final items = await db.listsDao.watchItems('l1').first;
    expect(items.map((i) => i.id), ['i2', 'i1']);
  });

  test('setItemDone toggles isDone', () async {
    await insertList('l1');
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i1', listId: 'l1', label: 'A'),
    );

    await db.listsDao.setItemDone('i1', true);
    var items = await db.listsDao.watchItems('l1').first;
    expect(items.single.isDone, isTrue);

    await db.listsDao.setItemDone('i1', false);
    items = await db.listsDao.watchItems('l1').first;
    expect(items.single.isDone, isFalse);
  });

  test('deleteItem removes just that item', () async {
    await insertList('l1');
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i1', listId: 'l1', label: 'A'),
    );
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i2', listId: 'l1', label: 'B'),
    );

    await db.listsDao.deleteItem('i1');

    final items = await db.listsDao.watchItems('l1').first;
    expect(items.map((i) => i.id), ['i2']);
  });

  test('deleting a list cascades to its items', () async {
    await insertList('l1');
    await db.listsDao.upsertItem(
      ListItemsCompanion.insert(id: 'i1', listId: 'l1', label: 'A'),
    );

    await db.customStatement('DELETE FROM lists WHERE id = ?', ['l1']);

    final items = await db.listsDao.watchItems('l1').first;
    expect(items, isEmpty);
  });
}
