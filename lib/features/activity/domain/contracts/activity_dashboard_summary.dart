import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_dashboard_summary.freezed.dart';

/// The Activity feature's own dashboard contract — the only thing another
/// feature (Home/Health Overview) is allowed to `ref.watch()`. Consumers
/// never see `DailyActivityEntry`/`ActivityRepository`/`DailyActivityDao`
/// (Golden Rule, mirrors `MoodDashboardSummary`'s role exactly).
@freezed
abstract class ActivityDashboardSummary with _$ActivityDashboardSummary {
  const factory ActivityDashboardSummary({
    required int todaySteps,
    required int goalSteps,
    required List<DailyActivitySummary> recentDays,
  }) = _ActivityDashboardSummary;
}

/// One day's aggregate as surfaced to a dashboard consumer.
@freezed
abstract class DailyActivitySummary with _$DailyActivitySummary {
  const factory DailyActivitySummary({
    required String dayKey,
    required int steps,
    required int goalSteps,
  }) = _DailyActivitySummary;
}
