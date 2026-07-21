import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';

part 'medication.freezed.dart';

/// A persisted medication definition. This is the feature's own domain
/// entity, distinct from the Drift `Medication` row shape —
/// [MedicationsRepository] is the only place that maps between them,
/// mirroring `Habit`/`HabitsRepository`'s split.
@freezed
abstract class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String name,
    String? dosageText,
    String? instructions,
    required MedicationSchedule schedule,
    required DateTime createdAt,
    DateTime? archivedAt,
  }) = _Medication;
}

extension MedicationActive on Medication {
  bool get isActive => archivedAt == null;
}
