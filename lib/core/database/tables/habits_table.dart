import 'package:drift/drift.dart';

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get targetFrequency => text()();

  /// Comma-separated weekday indices (1=Mon..7=Sun), empty for "daily".
  TextColumn get scheduleDays => text().withDefault(const Constant(''))();
  TextColumn get icon => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per day a habit was marked done. `localDate` is `yyyy-MM-dd` in
/// the device's local timezone (not UTC) so day boundaries match what the
/// user sees on screen, not an arbitrary UTC cutoff.
class HabitCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get localDate => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
