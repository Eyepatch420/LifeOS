import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_card_data.freezed.dart';

/// One of the 4 overview stat cards (Reminders, Today's Plan, Wellness
/// Score, Spent Today).
@freezed
abstract class OverviewStat with _$OverviewStat {
  const factory OverviewStat({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required double progress,
  }) = _OverviewStat;
}

/// One circular quick-action button (Add Reminder, Add Note, etc.). `id` is
/// a stable key used by `QuickActionsRow`'s `onActionTap` callback map, so
/// future modules can wire real navigation without ever touching
/// `QuickActionsRow` itself.
@freezed
abstract class QuickAction with _$QuickAction {
  const factory QuickAction({
    required String id,
    required IconData icon,
    required String label,
  }) = _QuickAction;
}

/// One row in the "Up Next" list.
@freezed
abstract class UpNextItem with _$UpNextItem {
  const factory UpNextItem({
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isUrgent,
  }) = _UpNextItem;
}

/// One row in the "Habit Streaks" list.
@freezed
abstract class HabitStreak with _$HabitStreak {
  const factory HabitStreak({
    required IconData icon,
    required String title,
    required int streakDays,
    required List<bool> last7Days,
  }) = _HabitStreak;
}

/// One step in the horizontal "Today's Timeline" stepper.
@freezed
abstract class TimelineStep with _$TimelineStep {
  const factory TimelineStep({
    required String id,
    required IconData icon,
    required String label,
    required String time,
    required Color dotColor,
  }) = _TimelineStep;
}

/// One row in "Recent Notes". `id` is nullable — mock-seeded rows (see
/// `mock_dashboard_data.dart`) have none, since there's no real note behind
/// them to navigate to; rows sourced from `notesDashboardProvider` always
/// set it, which is what `RecentNotesCard`'s tap wiring keys off.
@freezed
abstract class NoteSummary with _$NoteSummary {
  const factory NoteSummary({
    required IconData icon,
    required String title,
    required String preview,
    required String timestamp,
    required bool isPinned,
    String? id,
  }) = _NoteSummary;
}

/// One row in "My Lists". `id` is nullable for the same reason as
/// [NoteSummary.id].
@freezed
abstract class ListSummary with _$ListSummary {
  const factory ListSummary({
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    String? id,
  }) = _ListSummary;
}
