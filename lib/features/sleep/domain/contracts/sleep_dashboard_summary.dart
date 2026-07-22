import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_dashboard_summary.freezed.dart';

/// The Sleep feature's own dashboard contract — the only thing another
/// feature (Home/Health Overview) is allowed to `ref.watch()`. Consumers
/// never see `SleepEntry`/`SleepQuality`/`SleepRepository`/`SleepEntriesDao`
/// (Golden Rule, mirrors `MoodDashboardSummary`'s role exactly).
@freezed
abstract class SleepDashboardSummary with _$SleepDashboardSummary {
  const factory SleepDashboardSummary({
    /// The most recent record's duration/quality, or `null` if nothing has
    /// been logged yet — an honest empty state, never a fabricated default.
    Duration? latestDuration,
    String? latestQualityLabel,
    required List<SleepEntrySummary> recentEntries,
  }) = _SleepDashboardSummary;
}

/// One record as surfaced to a dashboard consumer.
@freezed
abstract class SleepEntrySummary with _$SleepEntrySummary {
  const factory SleepEntrySummary({
    required String id,
    required DateTime bedtime,
    required DateTime wakeTime,
    required Duration duration,
    String? qualityLabel,
  }) = _SleepEntrySummary;
}
