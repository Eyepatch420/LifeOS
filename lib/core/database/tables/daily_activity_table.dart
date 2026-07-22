import 'package:drift/drift.dart';

/// One row per local calendar day (upsert-by-day), not append-only —
/// mirrors a running daily aggregate rather than a history of individual
/// activity events, avoiding a flood of near-meaningless entries for a
/// value the user is expected to update in place throughout the day.
/// [id] is the local-day key (`yyyy-MM-dd`), computed by the repository via
/// `ClockManager`, never `DateTime.now()` directly.
class DailyActivity extends Table {
  TextColumn get id => text()();
  IntColumn get steps => integer()();
  IntColumn get distanceMeters => integer().nullable()();
  IntColumn get activeMinutes => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
