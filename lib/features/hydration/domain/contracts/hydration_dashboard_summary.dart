import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_dashboard_summary.freezed.dart';

/// The Hydration feature's own dashboard contract — the only thing another
/// feature (Home/Health Overview) is allowed to `ref.watch()`. Consumers
/// never see `HydrationEntry`/`HydrationRepository`/`HydrationEntriesDao`
/// (Golden Rule, mirrors `MoodDashboardSummary`'s role exactly).
@freezed
abstract class HydrationDashboardSummary with _$HydrationDashboardSummary {
  const factory HydrationDashboardSummary({
    required int todayTotalMl,
    required int goalMl,
    required List<HydrationEntrySummary> recentEntries,
  }) = _HydrationDashboardSummary;
}

/// One entry as surfaced to a dashboard consumer.
@freezed
abstract class HydrationEntrySummary with _$HydrationEntrySummary {
  const factory HydrationEntrySummary({
    required String id,
    required int amountMl,
    required DateTime recordedAt,
  }) = _HydrationEntrySummary;
}
