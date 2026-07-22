import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/hydration_entries_table.dart';

part 'hydration_entries_dao.g.dart';

@DriftAccessor(tables: [HydrationEntries])
class HydrationEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$HydrationEntriesDaoMixin {
  HydrationEntriesDao(super.db);

  Stream<List<HydrationEntry>> watchAll() {
    return (select(
      hydrationEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])).watch();
  }

  /// All entries within `[from, to)` — used by the repository to sum a
  /// single local day's total without scanning the whole table.
  Stream<List<HydrationEntry>> watchBetween(DateTime from, DateTime to) {
    return (select(hydrationEntries)
          ..where(
            (t) =>
                t.recordedAt.isBiggerOrEqualValue(from) &
                t.recordedAt.isSmallerThanValue(to),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch();
  }

  Future<HydrationEntry?> getById(String id) {
    return (select(
      hydrationEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insert(HydrationEntriesCompanion entry) =>
      into(hydrationEntries).insert(entry);

  Future<void> updateFields(String id, HydrationEntriesCompanion entry) {
    return (update(
      hydrationEntries,
    )..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> deleteById(String id) {
    return (delete(hydrationEntries)..where((t) => t.id.equals(id))).go();
  }
}
