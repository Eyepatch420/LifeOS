import 'package:drift/drift.dart';

/// `endedAt` is null while a session is running/paused. `plannedMinutes`
/// backs progress UI; `kind` distinguishes focus/break sessions without a
/// separate table.
class FocusSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedMinutes => integer()();
  TextColumn get kind => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
