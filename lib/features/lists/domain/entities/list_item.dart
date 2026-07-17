import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item.freezed.dart';

@freezed
abstract class ListItemEntity with _$ListItemEntity {
  const factory ListItemEntity({
    required String id,
    required String listId,
    required String label,
    required bool isDone,
    required int sortOrder,
  }) = _ListItemEntity;
}

/// A persisted list (shopping/groceries/checklist/etc.) with its items.
/// This is the feature's own domain entity, distinct from the Drift
/// `ListRecord` row shape — [ListsRepository] is the only place that maps
/// between them.
@freezed
abstract class TodoList with _$TodoList {
  const factory TodoList({
    required String id,
    required String title,
    required String kind,
    required bool isArchived,
    required DateTime createdAt,
    required List<ListItemEntity> items,
  }) = _TodoList;
}
