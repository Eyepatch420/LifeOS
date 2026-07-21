import 'package:drift/drift.dart';

/// Append-only — a user may log Mood multiple times a day (feeling
/// different at 8am than at 6pm is normal, not an error). "Today's mood" is
/// derived by the repository as the most recent [recordedAt] on the
/// current local day, never persisted as a separate mutable field.
/// Superseded the original one-row-per-local-day-upsert shape as of schema
/// v7 — see `app_database.dart`'s `from < 7` migration branch for how a
/// pre-existing one-row-per-day record is carried forward.
class MoodEntries extends Table {
  TextColumn get id => text()();
  // Stored as the enum name (e.g. 'good'), never a presentation string —
  // the UI owns label/icon/color for a given level.
  TextColumn get moodLevel => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
