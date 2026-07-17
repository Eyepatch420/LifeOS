import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminders_summary.freezed.dart';

/// One entry in the Reminders feature's dashboard summary — deliberately
/// narrower than [Reminder] (no `recurrence`/`customRule`) since Home only
/// ever renders a preview tile/agenda entry. Home imports this and
/// [RemindersSummary] only; it never imports [Reminder] or
/// `RemindersRepository` — see docs/architecture_principles.md's
/// Architecture Constraint 1.
///
/// Every field is a stable identity or a deep-link-ready primitive (`id`,
/// raw `dueAt`) rather than only display text, so search/notifications/
/// navigation/widgets can all key off the same DTO later without a
/// redesign (standing rule 3).
@freezed
abstract class ReminderEntrySummary with _$ReminderEntrySummary {
  const factory ReminderEntrySummary({
    required String id,
    required String title,
    required DateTime dueAt,
    required bool isUrgent,
    required bool isCompleted,
  }) = _ReminderEntrySummary;
}

/// The Reminders feature's full dashboard contribution — Home watches
/// `remindersDashboardProvider` (which resolves to this) instead of the
/// feature's repository or entity. `pendingCount`/`completedTodayCount`
/// back Home's Overview Stats "Tasks" tile without Home computing them
/// itself from the raw [items] list.
@freezed
abstract class RemindersSummary with _$RemindersSummary {
  const factory RemindersSummary({
    required List<ReminderEntrySummary> items,
    required int pendingCount,
    required int completedTodayCount,
  }) = _RemindersSummary;
}
