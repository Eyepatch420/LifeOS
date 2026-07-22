import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_dashboard_summary.freezed.dart';

/// The Weight feature's own dashboard contract — the only thing another
/// feature (Home/Health Overview) is allowed to `ref.watch()`. Consumers
/// never see `WeightEntry`/`WeightRepository`/`WeightEntriesDao` (Golden
/// Rule, mirrors `MoodDashboardSummary`'s role exactly).
@freezed
abstract class WeightDashboardSummary with _$WeightDashboardSummary {
  const factory WeightDashboardSummary({
    double? latestWeightKg,

    /// `latestWeightKg - previousWeightKg`, presented neutrally (not
    /// color-coded good/bad — see `WeightScreen`'s doc comment) — `null`
    /// when there's fewer than two measurements to compare.
    double? changeFromPreviousKg,
    required List<WeightEntrySummary> recentEntries,
  }) = _WeightDashboardSummary;
}

/// One entry as surfaced to a dashboard consumer.
@freezed
abstract class WeightEntrySummary with _$WeightEntrySummary {
  const factory WeightEntrySummary({
    required String id,
    required double weightKg,
    String? note,
    required DateTime recordedAt,
  }) = _WeightEntrySummary;
}
