import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_entry.freezed.dart';

/// A single manually-logged body-weight measurement. Canonical storage unit
/// is kilograms — presentation formatting/unit conversion is entirely a UI
/// concern, never baked into the stored value.
@freezed
abstract class WeightEntry with _$WeightEntry {
  const factory WeightEntry({
    required String id,
    required double weightKg,
    String? note,
    required DateTime recordedAt,
    required DateTime createdAt,
  }) = _WeightEntry;
}
