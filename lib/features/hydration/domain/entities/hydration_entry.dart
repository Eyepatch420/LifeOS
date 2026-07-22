import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_entry.freezed.dart';

/// A single logged water intake. This is the feature's own domain entity,
/// distinct from the Drift `HydrationEntry` row shape — [HydrationRepository]
/// is the only place that maps between them, mirroring `MoodEntry`'s split.
/// Append-only: a user may log several times a day.
@freezed
abstract class HydrationEntry with _$HydrationEntry {
  const factory HydrationEntry({
    required String id,
    required int amountMl,
    required DateTime recordedAt,
    required DateTime createdAt,
  }) = _HydrationEntry;
}
