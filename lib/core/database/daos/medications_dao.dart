import 'package:drift/drift.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/database/tables/medication_occurrences_table.dart';
import 'package:lifeos/core/database/tables/medications_table.dart';

part 'medications_dao.g.dart';

@DriftAccessor(tables: [Medications, MedicationOccurrences])
class MedicationsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationsDaoMixin {
  MedicationsDao(super.db);

  Stream<List<Medication>> watchAll() {
    return (select(
      medications,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch();
  }

  Stream<List<Medication>> watchActive() {
    return (select(medications)
          ..where((t) => t.archivedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<Medication?> getById(String id) {
    return (select(
      medications,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsert(MedicationsCompanion entry) =>
      into(medications).insertOnConflictUpdate(entry);

  Future<void> archive(String id, DateTime archivedAt) {
    return (update(medications)..where((t) => t.id.equals(id))).write(
      MedicationsCompanion(archivedAt: Value(archivedAt)),
    );
  }

  Future<void> deleteById(String id) {
    // Cascades to `medication_occurrences` via the FK's onDelete — see
    // `MedicationOccurrences.medicationId`'s doc comment on why archival is
    // preferred whenever adherence history should be kept.
    return (delete(medications)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<MedicationOccurrence>> watchOccurrencesFor(String medicationId) {
    return (select(medicationOccurrences)
          ..where((t) => t.medicationId.equals(medicationId))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledFor)]))
        .watch();
  }

  Future<MedicationOccurrence?> getOccurrence(
    String medicationId,
    DateTime scheduledFor,
  ) {
    return (select(medicationOccurrences)..where(
          (t) =>
              t.medicationId.equals(medicationId) &
              t.scheduledFor.equals(scheduledFor),
        ))
        .getSingleOrNull();
  }

  /// All persisted occurrences within `[from, to)` across every medication
  /// — used to overlay real taken/skipped status onto the in-memory
  /// synthesized "today" schedule without one query per medication.
  Future<List<MedicationOccurrence>> occurrencesBetween(
    DateTime from,
    DateTime to,
  ) {
    return (select(medicationOccurrences)..where(
          (t) =>
              t.scheduledFor.isBiggerOrEqualValue(from) &
              t.scheduledFor.isSmallerThanValue(to),
        ))
        .get();
  }

  Future<void> upsertOccurrence(MedicationOccurrencesCompanion entry) =>
      into(medicationOccurrences).insertOnConflictUpdate(entry);
}
