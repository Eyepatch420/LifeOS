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
    )..orderBy([(t) => OrderingTerm.desc(t.localDate)])).watch();
  }

  Future<MoodEntry?> getByDate(String localDate) {
    return (select(
      moodEntries,
    )..where((t) => t.localDate.equals(localDate))).getSingleOrNull();
  }

  /// Upserts the entry for [localDate]: overwrites the existing row for
  /// that day if present (only one mood entry per local day), inserts
  /// otherwise.
  Future<void> upsertForDate({
    required String localDate,
    required String Function() newId,
    required int score,
    String? note,
  }) async {
    final existing = await getByDate(localDate);
    await into(moodEntries).insertOnConflictUpdate(
      MoodEntriesCompanion.insert(
        id: existing?.id ?? newId(),
        localDate: localDate,
        score: score,
        note: Value(note),
      ),
    );
  }
}
