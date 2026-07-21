import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_occurrence.freezed.dart';

enum MedicationOccurrenceStatus { scheduled, taken, skipped, missed }

/// One scheduled dose for a medication — either persisted (taken/skipped)
/// or synthesized in-memory by [MedicationsRepository] from the
/// definition's schedule (scheduled/missed). "Missed" is always derived
/// (scheduledFor in the past, no persisted row), never stored — see
/// `MedicationOccurrences`' doc comment.
@freezed
abstract class MedicationOccurrence with _$MedicationOccurrence {
  const factory MedicationOccurrence({
    /// `null` for a synthesized (not-yet-acted-on) occurrence — only set
    /// once a real row exists.
    String? id,
    required String medicationId,
    required DateTime scheduledFor,
    required MedicationOccurrenceStatus status,
    DateTime? takenAt,
  }) = _MedicationOccurrence;
}
