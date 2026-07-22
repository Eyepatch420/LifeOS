import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/daily_activity_table.dart';

part 'daily_activity_dao.g.dart';

@DriftAccessor(tables: [DailyActivity])
class DailyActivityDao extends DatabaseAccessor<AppDatabase>
    with _$DailyActivityDaoMixin {
  DailyActivityDao(super.db);

  Stream<List<DailyActivityData>> watchAll() {
    return (select(
      dailyActivity,
    )..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();
  }

  /// Most recent [limit] days, newest first — used for Activity's history
  /// list and Home/Overview trend display.
  Stream<List<DailyActivityData>> watchRecent(int limit) {
    return (select(dailyActivity)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(limit))
        .watch();
  }

  Future<DailyActivityData?> getByDayKey(String dayKey) {
    return (select(
      dailyActivity,
    )..where((t) => t.id.equals(dayKey))).getSingleOrNull();
  }

  Future<void> upsert(DailyActivityCompanion entry) =>
      into(dailyActivity).insertOnConflictUpdate(entry);
}
