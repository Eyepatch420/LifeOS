import 'package:drift/drift.dart';

/// `parentListId`/`templateId`/`recurrence` are reserved columns for future
/// nested lists, list templates, and recurring lists — unused by Phase 2's
/// implementation but present now so a later feature is a `build()`/query
/// change, not a migration.
///
/// `@DataClassName` avoids Drift generating a data class literally named
/// `List`, which would shadow `dart:core`'s `List`.
@DataClassName('ListRecord')
class Lists extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get kind => text()();
  TextColumn get parentListId => text().nullable().references(Lists, #id)();
  TextColumn get templateId => text().nullable()();
  TextColumn get recurrence => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ListItems extends Table {
  TextColumn get id => text()();
  TextColumn get listId =>
      text().references(Lists, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
