import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/sleep_entries_table.dart';

part 'sleep_entries_dao.g.dart';

@DriftAccessor(tables: [SleepEntries])
class SleepEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$SleepEntriesDaoMixin {
  SleepEntriesDao(super.db);

  Stream<List<SleepEntry>> watchAll() {
    return (select(
      sleepEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.wakeTime)])).watch();
  }

  Future<SleepEntry?> getById(String id) {
    return (select(
      sleepEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insert(SleepEntriesCompanion entry) =>
      into(sleepEntries).insert(entry);

  Future<void> updateFields(String id, SleepEntriesCompanion entry) {
    return (update(sleepEntries)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> deleteById(String id) {
    return (delete(sleepEntries)..where((t) => t.id.equals(id))).go();
  }
}
