import 'package:drift/drift.dart';

/// A user-entered medication definition — descriptive only (Golden Rule for
/// this feature: LifeOS stores what the user tells it, never recommends
/// dosages/interactions). [scheduleTimes] and [scheduleDays] are encoded
/// strings owned by `MedicationSchedule` (`features/medications/domain`),
/// not raw Drift types — this table has no opinion on the encoding, only
/// persists it.
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dosageText => text().nullable()();
  TextColumn get instructions => text().nullable()();
  // Comma-separated "HH:mm" values, e.g. "09:00,21:00" — always non-empty
  // for an active medication.
  TextColumn get scheduleTimes => text()();
  // Comma-separated ISO weekday numbers (1=Mon..7=Sun), e.g. "1,3,5" — null
  // means every day.
  TextColumn get scheduleDays => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  // Archival, not deletion, is the default lifecycle end for a definition
  // with adherence history attached (see `MedicationOccurrences`'
  // `medicationId` FK) — mirrors this codebase's established
  // soft-delete/archive convention (Reminders' `deletedAt`).
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
