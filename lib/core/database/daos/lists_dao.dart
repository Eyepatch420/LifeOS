import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/lists_table.dart';

part 'lists_dao.g.dart';

@DriftAccessor(tables: [Lists, ListItems])
class ListsDao extends DatabaseAccessor<AppDatabase> with _$ListsDaoMixin {
  ListsDao(super.db);

  Stream<List<ListRecord>> watchAll() {
    return (select(lists)
          ..where((t) => t.deletedAt.isNull() & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<ListRecord?> getById(String id) {
    return (select(
      lists,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsertList(ListsCompanion entry) =>
      into(lists).insertOnConflictUpdate(entry);

  Future<void> softDeleteList(String id) {
    return (update(lists)..where((t) => t.id.equals(id))).write(
      ListsCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  Future<void> setArchived(String id, bool isArchived) {
    return (update(lists)..where((t) => t.id.equals(id))).write(
      ListsCompanion(isArchived: Value(isArchived)),
    );
  }

  Stream<List<ListItem>> watchItems(String listId) {
    return (select(listItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// One-shot read, used by [ListsRepository.watchAll]/`watchById` to
  /// compose each list's items without opening a nested live query stream
  /// per emission — `watch()` re-subscribing on every parent-stream tick
  /// is unnecessary work and, combined with `Stream.asyncMap`, prone to
  /// stalling under `closeStreamsSynchronously` test semantics.
  Future<List<ListItem>> getItems(String listId) {
    return (select(listItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<void> upsertItem(ListItemsCompanion entry) =>
      into(listItems).insertOnConflictUpdate(entry);

  Future<void> deleteItem(String id) {
    return (delete(listItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setItemDone(String id, bool isDone) {
    return (update(listItems)..where((t) => t.id.equals(id))).write(
      ListItemsCompanion(isDone: Value(isDone)),
    );
  }

  Future<void> reorderItems(List<String> idsInOrder) async {
    await batch((b) {
      for (var i = 0; i < idsInOrder.length; i++) {
        b.update(
          listItems,
          ListItemsCompanion(sortOrder: Value(i)),
          where: (t) => t.id.equals(idsInOrder[i]),
        );
      }
    });
  }
}
