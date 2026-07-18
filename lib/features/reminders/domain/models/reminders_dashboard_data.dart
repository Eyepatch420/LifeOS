import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';

part 'reminders_dashboard_data.freezed.dart';

/// Derived, dashboard-shaped view over the reminder list — a pure
/// transformation of [RemindersRepository.watchAll]'s stream, never a
/// second source of truth. See [remindersForDashboard] for the
/// classification logic and [remindersDashboardDataProvider] for how this
/// is kept live.
@freezed
abstract class RemindersDashboardData with _$RemindersDashboardData {
  const factory RemindersDashboardData({
    required List<Reminder> today,
    required List<Reminder> upcoming,
    required List<Reminder> overdue,
    required Reminder? upNext,
    required int pendingCount,
    required int completedCount,
    required int overdueCount,
    required int todayCount,
  }) = _RemindersDashboardData;

  const RemindersDashboardData._();

  static const empty = RemindersDashboardData(
    today: [],
    upcoming: [],
    overdue: [],
    upNext: null,
    pendingCount: 0,
    completedCount: 0,
    overdueCount: 0,
    todayCount: 0,
  );

  bool get isEmpty =>
      today.isEmpty && upcoming.isEmpty && overdue.isEmpty && upNext == null;
}

/// Pure classification of [reminders] into dashboard buckets, given [now] as
/// an explicit input (never reads the clock itself) so it's independently
/// testable with fixed dates — see reminders_dashboard_data_test.dart.
///
/// Semantics (schema has only `dueAt: DateTime`, `isCompleted`,
/// `isUrgent`, `recurrence` — no all-day flag, no priority/category beyond
/// `isUrgent`, no per-reminder timezone, so all comparisons are plain local
/// `DateTime` comparisons against [now]):
///
/// - TODAY: not completed, `dueAt` falls within [now]'s local calendar day
///   (including any already-passed time earlier today — see OVERDUE below,
///   these two buckets can overlap by design: a reminder due earlier today
///   that's still pending is both "overdue" and "today").
/// - OVERDUE: not completed, `dueAt` is strictly before [now].
/// - UPCOMING: not completed, `dueAt` is on a later calendar day than
///   [now]'s.
/// - UP NEXT: the nearest actionable (not completed) reminder by `dueAt`
///   ascending — overdue reminders sort first since their `dueAt` is
///   earliest, which is the desired "most urgent first" behavior without
///   any special-casing.
/// - COMPLETED: `isCompleted == true`, excluded from today/upcoming/overdue/
///   upNext entirely — only contributes to `completedCount`.
///
/// Recurrence: `RecurrenceRule` is persisted per reminder but there is no
/// recurrence-expansion/materialization engine anywhere in the current
/// architecture (each `Reminder` row is a single occurrence) — this
/// function does not invent one. A recurring reminder is classified using
/// its single stored `dueAt` like any other reminder; once occurrences are
/// materialized elsewhere, this function will pick them up automatically
/// since it only ever looks at the flat `List<Reminder>` it's given.
RemindersDashboardData remindersForDashboard(
  List<Reminder> reminders, {
  required DateTime now,
}) {
  final todayKey = DateTime(now.year, now.month, now.day);
  final tomorrowKey = todayKey.add(const Duration(days: 1));

  final pending = reminders.where((r) => !r.isCompleted).toList()
    ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

  final overdue = pending.where((r) => r.dueAt.isBefore(now)).toList();

  final today = pending
      .where(
        (r) => !r.dueAt.isBefore(todayKey) && r.dueAt.isBefore(tomorrowKey),
      )
      .toList();

  final upcoming = pending
      .where((r) => !r.dueAt.isBefore(tomorrowKey))
      .toList();

  final completedCount = reminders.where((r) => r.isCompleted).length;

  return RemindersDashboardData(
    today: today,
    upcoming: upcoming,
    overdue: overdue,
    upNext: pending.isEmpty ? null : pending.first,
    pendingCount: pending.length,
    completedCount: completedCount,
    overdueCount: overdue.length,
    todayCount: today.length,
  );
}
