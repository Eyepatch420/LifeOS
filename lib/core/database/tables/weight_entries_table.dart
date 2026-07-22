import 'package:drift/drift.dart';

/// A manually-logged body-weight measurement — canonical storage unit is
/// kilograms (a numeric [weightKg], never a formatted string); presentation
/// formatting/unit conversion is entirely a UI concern.
class WeightEntries extends Table {
  TextColumn get id => text()();
  RealColumn get weightKg => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
