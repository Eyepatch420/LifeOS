import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/reminders_table.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Stream<List<Reminder>> watchAll() {
    return (select(reminders)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.dueAt)]))
        .watch();
  }

  Future<Reminder?> getById(String id) {
    return (select(
      reminders,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsert(RemindersCompanion entry) =>
      into(reminders).insertOnConflictUpdate(entry);

  /// Partial `UPDATE` for editable fields — distinct from [upsert], which
  /// requires every non-nullable column (mirrors `NotesDao.updateFields`).
  Future<void> updateFields(String id, RemindersCompanion companion) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(companion);
  }

  Future<void> softDelete(String id) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  Future<void> restore(String id) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(
      const RemindersCompanion(deletedAt: Value(null)),
    );
  }

  Future<void> setCompleted(String id, bool isCompleted) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
      ),
    );
  }
}
