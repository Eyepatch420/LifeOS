import 'package:freezed_annotation/freezed_annotation.dart';

part 'mood_dashboard_summary.freezed.dart';

/// The Mood feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Home never sees
/// `MoodEntry`/`MoodLevel`/`MoodRepository`/`MoodEntriesDao` (Golden Rule,
/// enforced by `test/contracts/import_boundary_test.dart`) — every field
/// here is a resolved presentation value (label strings, not the raw
/// domain enum), mirroring `HabitsSummary`'s role exactly.
@freezed
abstract class MoodDashboardSummary with _$MoodDashboardSummary {
  const factory MoodDashboardSummary({
    /// The most recent entry's level label (e.g. "Good") on the current
    /// local day, or `null` if nothing has been logged yet today — Home
    /// renders an honest empty state ("—" / "Log how you feel") rather
    /// than a fabricated default.
    String? todayLevelLabel,
    required int todayEntryCount,
    required List<MoodEntrySummary> recentEntries,
  }) = _MoodDashboardSummary;
}

/// One entry as surfaced to a dashboard consumer — resolved fields only, no
/// raw entity leakage.
@freezed
abstract class MoodEntrySummary with _$MoodEntrySummary {
  const factory MoodEntrySummary({
    required String id,
    required String levelLabel,
    required String levelEmoji,
    String? note,
    required DateTime recordedAt,
  }) = _MoodEntrySummary;
}
