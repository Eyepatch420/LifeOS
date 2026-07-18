import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';

/// Pure, calendar-aware calculation of a recurring reminder's next
/// occurrence — no widget, provider, or repository dependency, so it's
/// unit-testable with fixed dates (see recurrence_calculator_test.dart).
///
/// Returns `null` for [RecurrenceRule.none] (nothing to advance to) and for
/// [RecurrenceRule.custom] (see the doc comment on [RecurrenceRule.custom]
/// / `Reminders.customRule` — no rule language is defined yet, so there is
/// nothing a calculator could correctly compute; exposing a result here
/// would be a guess, not a calculation).
DateTime? nextOccurrence(DateTime currentDueAt, RecurrenceRule recurrence) {
  return switch (recurrence) {
    RecurrenceRule.none => null,
    RecurrenceRule.daily => currentDueAt.add(const Duration(days: 1)),
    RecurrenceRule.weekdays => _nextWeekday(currentDueAt),
    RecurrenceRule.weekly => currentDueAt.add(const Duration(days: 7)),
    RecurrenceRule.monthly => _addMonths(currentDueAt, 1),
    RecurrenceRule.yearly => _addMonths(currentDueAt, 12),
    RecurrenceRule.custom => null,
  };
}

/// The next occurrence of [RecurrenceRule.weekdays] (Mon-Fri): the next
/// calendar day, then skipping forward over a landed Saturday/Sunday.
DateTime _nextWeekday(DateTime currentDueAt) {
  var next = currentDueAt.add(const Duration(days: 1));
  while (next.weekday == DateTime.saturday || next.weekday == DateTime.sunday) {
    next = next.add(const Duration(days: 1));
  }
  return next;
}

/// Calendar-aware month addition, anchored to [currentDueAt]'s original
/// day-of-month, clamped to the last valid day of the target month when
/// that day doesn't exist there (e.g. Jan 31 -> Feb 28/29, and Feb 29 in a
/// leap year -> Feb 28 in a non-leap target year for +12 months). Time of
/// day is preserved unchanged.
///
/// This is the documented, deterministic policy chosen for Phase 4 in the
/// absence of a richer stored anchor (the schema has no separate
/// "original day" field beyond `dueAt` itself, so `dueAt`'s own day-of-month
/// *is* the anchor, by construction — every advance re-anchors to whatever
/// day the previous occurrence actually landed on, matching how a plain
/// user-facing "every month on this day" recurrence is normally understood).
DateTime _addMonths(DateTime currentDueAt, int monthsToAdd) {
  final totalMonths = currentDueAt.month - 1 + monthsToAdd;
  final targetYear = currentDueAt.year + totalMonths ~/ 12;
  final targetMonth = totalMonths % 12 + 1;
  final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
  final targetDay = currentDueAt.day.clamp(1, lastDayOfTargetMonth);

  return DateTime(
    targetYear,
    targetMonth,
    targetDay,
    currentDueAt.hour,
    currentDueAt.minute,
    currentDueAt.second,
    currentDueAt.millisecond,
    currentDueAt.microsecond,
  );
}
