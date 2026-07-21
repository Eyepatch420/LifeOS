import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/medications/domain/entities/medication_occurrence.dart';

part 'medications_dashboard_summary.freezed.dart';

/// The Medications feature's own dashboard provider — the only thing
/// another feature (Home) is allowed to `ref.watch()`. Home never sees
/// `Medication`/`MedicationsRepository`/`MedicationsDao`, mirroring
/// `habitsDashboardProvider`'s role exactly.
@freezed
abstract class MedicationsDashboardSummary with _$MedicationsDashboardSummary {
  const factory MedicationsDashboardSummary({
    required List<MedicationOccurrenceSummary> todayOccurrences,
    required int activeMedicationCount,
  }) = _MedicationsDashboardSummary;
}

@freezed
abstract class MedicationOccurrenceSummary with _$MedicationOccurrenceSummary {
  const factory MedicationOccurrenceSummary({
    required String medicationId,
    required String medicationName,
    required DateTime scheduledFor,
    required MedicationOccurrenceStatus status,
  }) = _MedicationOccurrenceSummary;
}
