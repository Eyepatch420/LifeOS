import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/core/planner/planner_item.dart';

part 'planner_day_data.freezed.dart';

/// Derived, day-shaped view over the flat [PlannerItem] list for one
/// selected date — a pure transformation, never a second source of truth.
/// See [plannerDayFor] for the classification semantics.
@freezed
abstract class PlannerDayData with _$PlannerDayData {
  const factory PlannerDayData({
    required DateTime date,
    required List<PlannerItem> overdueCarryover,
    required List<PlannerItem> scheduled,
    required int completedCount,
    required int pendingCount,
  }) = _PlannerDayData;

  const PlannerDayData._();

  int get totalCount => scheduled.length;

  bool get isEmpty => overdueCarryover.isEmpty && scheduled.isEmpty;

  /// [scheduled] items with [PlannerItem.temporalKind] `allDay` (Calendar
  /// events only, as of Phase 7), shown in their own group ahead of the
  /// timed timeline — see `PlannerScreen`'s "ALL DAY" section. Kept as a
  /// derived getter (not a separately-classified field) so `plannerDayFor`
  /// stays a single sort-then-classify pass; the split itself never needs
  /// `sourceType` knowledge, only [PlannerItem.temporalKind].
  List<PlannerItem> get allDayItems => scheduled
      .where((i) => i.temporalKind == PlannerTemporalKind.allDay)
      .toList();

  /// [scheduled] items with a specific clock time — everything that isn't
  /// [allDayItems].
  List<PlannerItem> get timedItems => scheduled
      .where((i) => i.temporalKind == PlannerTemporalKind.timed)
      .toList();
}

/// Pure classification of [items] into a single day's Planner view for
/// [date], given [now] as an explicit input (never reads the clock itself)
/// so it's independently testable with fixed dates.
///
/// Semantics:
///
/// - SCHEDULED: any item (regardless of completion state) whose
///   `scheduledAt` falls on [date]'s local calendar day. Chronologically
///   sorted ascending — this is the day timeline.
/// - COMPLETED/PENDING counts: split of `scheduled` by `isCompleted`, for
///   the compact day summary.
/// - OVERDUE CARRYOVER: only populated when [date] is [now]'s calendar
///   day (today) — pending items whose `scheduledAt` is strictly before
///   [now] and did NOT already fall on [date] (i.e. genuinely from a
///   previous day, not "earlier today", which stays in `scheduled` as an
///   ordinary chronological entry). For any other date (past or future),
///   this is always empty: a future day showing "all historical overdue
///   reminders" would be misleading, and a past day's own overdue items
///   are already represented via `scheduled` — see docs note in
///   `PlannerScreen` on this being a deliberate day-planner semantic, not
///   an omission.
///
/// Recurrence: each [PlannerItem] is a single stored occurrence (see
/// `ReminderPlannerMapping`/the single-row recurring model) — there is no
/// historical-occurrence materialization, so a past day never shows
/// occurrences of a recurring reminder that have since advanced away from
/// it. This function does not fabricate history; it only ever looks at the
/// flat list it's given.
PlannerDayData plannerDayFor(
  List<PlannerItem> items, {
  required DateTime date,
  required DateTime now,
}) {
  final dayKey = dateOnly(date);
  final todayKey = dateOnly(now);
  final isToday = dayKey == todayKey;

  final scheduled =
      items.where((item) => isSameDay(item.scheduledAt, dayKey)).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  final overdueCarryover = isToday
      ? (items
            .where(
              (item) =>
                  !item.isCompleted &&
                  item.scheduledAt.isBefore(now) &&
                  !isSameDay(item.scheduledAt, dayKey),
            )
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt)))
      : const <PlannerItem>[];

  final completedCount = scheduled.where((item) => item.isCompleted).length;

  return PlannerDayData(
    date: dayKey,
    overdueCarryover: overdueCarryover,
    scheduled: scheduled,
    completedCount: completedCount,
    pendingCount: scheduled.length - completedCount,
  );
}
