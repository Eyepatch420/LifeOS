import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';

/// A habit's streak state as of [now] — current + best consecutive-run
/// length, counted in *scheduled occurrences*, not raw calendar days: a
/// Mon/Wed/Fri habit does not lose its streak because Tuesday had no
/// completion, since Tuesday was never an expected occurrence.
class HabitStreakResult {
  const HabitStreakResult({required this.current, required this.best});

  final int current;
  final int best;
}

/// Pure, testable streak calculation. Walks backwards day-by-day from
/// [now]'s calendar day, skipping any day [schedule] doesn't expect an
/// occurrence on, and counting consecutive completed scheduled days from
/// [completedDates] (a set of local calendar dates, normalized via
/// [dateOnly] — see that function's doc comment for why every
/// calendar-date comparison in the app goes through it).
///
/// - **Today pending**: if today is a scheduled day and hasn't been
///   completed yet, it does not break an existing streak (the user still
///   has time to complete it) — the walk simply starts counting from the
///   most recent scheduled day that *was* completed, beginning at
///   yesterday. It also doesn't count toward [current] until actually
///   completed.
/// - **Today completed**: counts as the first (most recent) day of
///   [current].
/// - **Future completion records** (dates after [now]'s calendar day) are
///   ignored entirely — they cannot contribute to a streak measured as of
///   now.
/// - **Broken streak**: the walk stops at the first scheduled day, at or
///   before today, that was not completed (today itself never counts as
///   "broken" while still pending, per above).
/// - [best] is the longest run of consecutive completed scheduled days
///   found anywhere in [completedDates], independent of whether it's still
///   active — a simple linear scan is sufficient since completion history
///   is bounded and this isn't called in a hot loop.
HabitStreakResult calculateHabitStreak({
  required HabitSchedule schedule,
  required Set<DateTime> completedDates,
  required DateTime now,
}) {
  final today = dateOnly(now);
  final normalizedCompletions = completedDates
      .map(dateOnly)
      .where((d) => !d.isAfter(today))
      .toSet();

  final current = _currentStreak(schedule, normalizedCompletions, today);
  final best = _bestStreak(schedule, normalizedCompletions, today);

  return HabitStreakResult(
    current: current,
    best: best > current ? best : current,
  );
}

int _currentStreak(
  HabitSchedule schedule,
  Set<DateTime> completions,
  DateTime today,
) {
  var cursor = today;
  var streak = 0;
  var isFirstScheduledDay = true;

  // Bounded walk: a habit can't have more consecutive days than there have
  // been days since any completion exists at all (or none, in which case
  // this loop exits on the first scheduled day anyway). A hard cap avoids
  // an unbounded loop for a daily habit with zero completions.
  for (var i = 0; i < 3650; i++) {
    if (!schedule.occursOn(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      continue;
    }

    final isCompleted = completions.contains(cursor);
    if (!isCompleted) {
      // Today being pending (not yet completed) doesn't break the streak —
      // just don't count it, and keep walking from yesterday.
      if (isFirstScheduledDay && isSameDay(cursor, today)) {
        isFirstScheduledDay = false;
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }
      break;
    }

    streak++;
    isFirstScheduledDay = false;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}

int _bestStreak(
  HabitSchedule schedule,
  Set<DateTime> completions,
  DateTime today,
) {
  if (completions.isEmpty) return 0;

  final earliest = completions.reduce((a, b) => a.isBefore(b) ? a : b);
  var best = 0;
  var running = 0;
  var cursor = earliest;

  while (!cursor.isAfter(today)) {
    if (schedule.occursOn(cursor)) {
      if (completions.contains(cursor)) {
        running++;
        if (running > best) best = running;
      } else {
        running = 0;
      }
    }
    cursor = cursor.add(const Duration(days: 1));
  }

  return best;
}
