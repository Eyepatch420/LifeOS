import 'package:drift/drift.dart';
import 'package:lifeos/core/database/database_connection.dart';

part 'app_database.g.dart';

/// A trivial key-value table used only to prove out the Drift/build_runner
/// pipeline in Module 1, which otherwise has no relational data (see
/// docs/architecture.md — every User Setup field is scalar and lives in
/// SharedPreferences instead). Real tables (Reminders, Notes, Expenses,
/// Health entries) land in Module 2, at which point this table can be
/// dropped or repurposed.
class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [AppMetadata])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
