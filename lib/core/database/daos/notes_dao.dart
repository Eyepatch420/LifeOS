import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/notes_table.dart';

part 'notes_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  Stream<List<Note>> watchAll() {
    return (select(notes)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPinned),
            (t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .watch();
  }

  Future<Note?> getById(String id) {
    return (select(
      notes,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsert(NotesCompanion entry) =>
      into(notes).insertOnConflictUpdate(entry);

  /// Partial update for an existing row — unlike [upsert] (which validates
  /// as a full insert and therefore requires every non-nullable column,
  /// including `createdAt`), this only writes the columns present in
  /// [entry] via a real SQL `UPDATE`.
  Future<void> updateFields(String id, NotesCompanion entry) {
    return (update(notes)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> softDelete(String id) {
    return (update(notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  Future<void> restore(String id) {
    return (update(notes)..where((t) => t.id.equals(id))).write(
      const NotesCompanion(deletedAt: Value(null)),
    );
  }

  Future<void> setPinned(String id, bool isPinned) {
    return (update(notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(isPinned: Value(isPinned)),
    );
  }
}
