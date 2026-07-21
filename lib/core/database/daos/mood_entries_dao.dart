import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/mood_entries_table.dart';

part 'mood_entries_dao.g.dart';

@DriftAccessor(tables: [MoodEntries])
class MoodEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$MoodEntriesDaoMixin {
  MoodEntriesDao(super.db);

  Stream<List<MoodEntry>> watchAll() {
    return (select(
      moodEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])).watch();
  }

  Future<MoodEntry?> getById(String id) {
    return (select(
      moodEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insert(MoodEntriesCompanion entry) =>
      into(moodEntries).insert(entry);

  Future<void> updateFields(String id, MoodEntriesCompanion entry) {
    return (update(moodEntries)..where((t) => t.id.equals(id))).write(entry);
  }

  Future<void> deleteById(String id) {
    return (delete(moodEntries)..where((t) => t.id.equals(id))).go();
  }
}
