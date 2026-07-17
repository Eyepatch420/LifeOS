import 'package:drift/drift.dart';

/// One entry per local day — writing a second entry the same day upserts
/// rather than appending (enforced at the repository layer via a unique
/// index, not here, so the table stays a plain Drift table).
class MoodEntries extends Table {
  TextColumn get id => text()();
  TextColumn get localDate => text()();
  IntColumn get score => integer()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
