import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/focus_sessions_table.dart';

part 'focus_sessions_dao.g.dart';

@DriftAccessor(tables: [FocusSessions])
class FocusSessionsDao extends DatabaseAccessor<AppDatabase>
    with _$FocusSessionsDaoMixin {
  FocusSessionsDao(super.db);

  Stream<List<FocusSession>> watchAll() {
    return (select(
      focusSessions,
    )..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).watch();
  }

  /// The in-progress session (`status` `running` or `paused`), if any.
  /// There should only ever be at most one — enforced at the repository
  /// layer.
  Stream<FocusSession?> watchActive() {
    return (select(
      focusSessions,
    )..where((t) => t.status.isIn(['running', 'paused']))).watchSingleOrNull();
  }

  Future<FocusSession?> getById(String id) {
    return (select(
      focusSessions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<FocusSession?> watchById(String id) {
    return (select(
      focusSessions,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<void> upsert(FocusSessionsCompanion entry) =>
      into(focusSessions).insertOnConflictUpdate(entry);

  Future<void> updateFields(String id, FocusSessionsCompanion entry) {
    return (update(focusSessions)..where((t) => t.id.equals(id))).write(entry);
  }
}
