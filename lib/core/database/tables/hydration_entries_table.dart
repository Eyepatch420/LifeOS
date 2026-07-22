import 'package:drift/drift.dart';

/// Append-only water intake log — one row per logged amount, never a
/// per-day upsert (a user may log several times a day). "Today's total" is
/// derived by the repository as the sum of [amountMl] on the current local
/// day, never persisted as a separate mutable field.
class HydrationEntries extends Table {
  TextColumn get id => text()();
  IntColumn get amountMl => integer()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
