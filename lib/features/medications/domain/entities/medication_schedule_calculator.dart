import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';

/// One resolved future dose: which time-of-day slot, and its next
/// occurrence's absolute instant.
class MedicationScheduleSlot {
  const MedicationScheduleSlot({
    required this.time,
    required this.nextOccurrence,
  });

  final MedicationTime time;
  final DateTime nextOccurrence;
}

/// Pure, calendar-aware calculation of a [MedicationSchedule]'s next
/// occurrence for every time-of-day slot, relative to [now] — no widget,
/// provider, or repository dependency, so it's unit-testable with fixed
/// dates (mirrors `recurrence_calculator.dart`'s shape). Returns one
/// [MedicationScheduleSlot] per [MedicationSchedule.times] entry, each
/// independently advanced to whichever future instant is soonest for that
/// slot — a schedule with no times to work from returns an empty list
/// (there is nothing to compute, same "empty over guess" policy
/// `recurrence_calculator.dart` documents for `RecurrenceRule.custom`).
List<MedicationScheduleSlot> nextOccurrences(
  MedicationSchedule schedule,
  DateTime now,
) {
  return [
    for (final time in schedule.times)
      MedicationScheduleSlot(
        time: time,
        nextOccurrence: _nextOccurrenceForTime(schedule, time, now),
      ),
  ];
}

/// The next instant [time] is due on/after [now], honoring [schedule]'s
/// weekday restriction (if any). Starts at today's candidate instant for
/// [time]; if that's already past (or today isn't an eligible weekday),
/// walks forward one day at a time until it finds the next eligible day —
/// bounded to 8 iterations since a weekly restriction can skip at most 6
/// days before wrapping back onto an eligible one.
DateTime _nextOccurrenceForTime(
  MedicationSchedule schedule,
  MedicationTime time,
  DateTime now,
) {
  var candidate = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  for (var i = 0; i < 8; i++) {
    final isEligibleDay = schedule.occursOn(candidate.weekday);
    final isInFuture = candidate.isAfter(now);
    if (isEligibleDay && isInFuture) return candidate;
    candidate = candidate.add(const Duration(days: 1));
  }
  return candidate;
}
