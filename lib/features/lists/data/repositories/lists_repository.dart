import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/lists_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/lists/domain/entities/list_item.dart';
import 'package:lifeos/features/lists/domain/events/list_events.dart';

/// The single owner of Lists persistence — every mutation and query for
/// lists/items goes through here, wrapping [ListsDao] and mapping Drift
/// rows to the feature's own [TodoList]/[ListItemEntity] entities. No other
/// feature imports this class or [ListsDao] directly (see the Golden Rule).
class ListsRepository {
  ListsRepository(this._dao, this._eventBus);

  final ListsDao _dao;
  final EventBus _eventBus;

  /// Combines the lists stream with each list's items into one `TodoList`
  /// stream — `Stream.asyncMap` re-fetches items (a one-shot [ListsDao.getItems]
  /// read, not a nested live stream) on every list change; acceptable for
  /// the small per-user list counts this app targets. Item-level changes
  /// (check/reorder/add/delete) don't re-emit `watchAll()` on their own —
  /// callers needing live item updates for one list should combine this
  /// with [ListsDao.watchItems] directly, or, for the common case, prefer
  /// [watchById].
  Stream<List<TodoList>> watchAll() {
    return _dao.watchAll().asyncMap((rows) async {
      final lists = <TodoList>[];
      for (final row in rows) {
        final items = await _dao.getItems(row.id);
        lists.add(_toEntity(row, items));
      }
      return lists;
    });
  }

  /// Live-updates on both list-level changes (title/archive) and
  /// item-level changes (add/check/reorder/delete) for [id] specifically,
  /// by combining the list-level stream with the item-level stream.
  Stream<TodoList?> watchById(String id) {
    return _dao.watchAll().asyncExpand((rows) {
      final row = rows.where((r) => r.id == id).firstOrNull;
      if (row == null) return Stream.value(null);
      return _dao.watchItems(id).map((items) => _toEntity(row, items));
    });
  }

  Future<void> createList({
    required String id,
    required String title,
    required String kind,
  }) async {
    await _dao.upsertList(
      db.ListsCompanion.insert(
        id: id,
        title: title,
        kind: kind,
        createdAt: DateTime.now(),
      ),
    );
    _eventBus.emit(ListCreated(listId: id));
  }

  Future<void> archiveList(String id, bool isArchived) =>
      _dao.setArchived(id, isArchived);

  Future<void> deleteList(String id) => _dao.softDeleteList(id);

  Future<void> addItem({
    required String id,
    required String listId,
    required String label,
    required int sortOrder,
  }) {
    return _dao.upsertItem(
      db.ListItemsCompanion.insert(
        id: id,
        listId: listId,
        label: label,
        sortOrder: Value(sortOrder),
      ),
    );
  }

  Future<void> setItemDone(String itemId, bool isDone) =>
      _dao.setItemDone(itemId, isDone);

  Future<void> deleteItem(String itemId) => _dao.deleteItem(itemId);

  Future<void> reorderItems(List<String> idsInOrder) =>
      _dao.reorderItems(idsInOrder);

  TodoList _toEntity(db.ListRecord row, List<db.ListItem> items) => TodoList(
    id: row.id,
    title: row.title,
    kind: row.kind,
    isArchived: row.isArchived,
    createdAt: row.createdAt,
    items: [
      for (final item in items)
        ListItemEntity(
          id: item.id,
          listId: item.listId,
          label: item.label,
          isDone: item.isDone,
          sortOrder: item.sortOrder,
        ),
    ],
  );
}
