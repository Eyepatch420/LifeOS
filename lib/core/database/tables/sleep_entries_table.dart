import 'package:drift/drift.dart';

/// A manually-logged sleep record — [bedtime]/[wakeTime] are the
/// authoritative fields; duration is always derived
/// (`wakeTime.difference(bedtime)`), never stored, so it can't drift out of
/// sync with an edited bedtime/wake time. The record's "sleep day" is its
/// [wakeTime]'s local date (see `SleepRepository` doc comment).
class SleepEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get bedtime => dateTime()();
  DateTimeColumn get wakeTime => dateTime()();
  // Stored as the enum name (e.g. 'good'), never a presentation string —
  // mirrors `MoodEntries.moodLevel`.
  TextColumn get quality => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
