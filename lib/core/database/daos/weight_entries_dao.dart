import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/weight_entries_table.dart';

part 'weight_entries_dao.g.dart';

@DriftAccessor(tables: [WeightEntries])
class WeightEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$WeightEntriesDaoMixin {
  WeightEntriesDao(super.db);

  Stream<List<WeightEntry>> watchAll() {
    return (select(
      weightEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])).watch();
  }

  Future<WeightEntry?> getById(String id) {
    return (select(
      weightEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insert(WeightEntriesCompanion entry) =>
      into(weightEntries).insert(entry);

  Future<void> updateFields(String id, WeightEntriesCompanion entry) {
    return (update(weightEntries)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> deleteById(String id) {
    return (delete(weightEntries)..where((t) => t.id.equals(id))).go();
  }
}
