import 'package:drift/drift.dart';
import 'package:lifeos/core/database/tables/medications_table.dart';

/// A single scheduled dose. Deliberately separate from [Medications] rather
/// than a `lastTaken` field on the definition — see this table's own
/// history requirement: adherence needs every past occurrence, not just
/// the most recent one. Only occurrences someone has acted on (taken or
/// skipped) get a persisted row; an untouched future/today occurrence is
/// synthesized in-memory by `MedicationsRepository` from the definition's
/// schedule — see that class's doc comment. "Missed" is never persisted
/// here; it's derived (scheduled + in the past + no row) at read time.
class MedicationOccurrences extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId =>
      text().references(Medications, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get scheduledFor => dateTime()();
  // 'taken' | 'skipped' — a row only ever exists once one of these is true.
  TextColumn get status => text()();
  DateTimeColumn get takenAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
