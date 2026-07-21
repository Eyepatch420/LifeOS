import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule_calculator.dart';

void main() {
  test('a time later today than now resolves to today', () {
    final schedule = const MedicationSchedule(
      times: [MedicationTime(hour: 21, minute: 0)],
    );
    final now = DateTime(2026, 1, 1, 9); // Thursday 09:00
    final slots = nextOccurrences(schedule, now);

    expect(slots, hasLength(1));
    expect(slots.single.nextOccurrence, DateTime(2026, 1, 1, 21));
  });

  test('a time already passed today rolls to tomorrow', () {
    final schedule = const MedicationSchedule(
      times: [MedicationTime(hour: 9, minute: 0)],
    );
    final now = DateTime(2026, 1, 1, 21); // Thursday 21:00
    final slots = nextOccurrences(schedule, now);

    expect(slots.single.nextOccurrence, DateTime(2026, 1, 2, 9));
  });

  test('multiple times each resolve independently', () {
    final schedule = const MedicationSchedule(
      times: [
        MedicationTime(hour: 9, minute: 0),
        MedicationTime(hour: 21, minute: 0),
      ],
    );
    final now = DateTime(2026, 1, 1, 12); // between the two
    final slots = nextOccurrences(schedule, now);

    // Order mirrors `schedule.times`' input order, not chronological order.
    expect(slots, hasLength(2));
    expect(slots[0].time, const MedicationTime(hour: 9, minute: 0));
    expect(slots[0].nextOccurrence, DateTime(2026, 1, 2, 9));
    expect(slots[1].time, const MedicationTime(hour: 21, minute: 0));
    expect(slots[1].nextOccurrence, DateTime(2026, 1, 1, 21));
  });

  test('a weekday restriction skips forward to the next eligible day', () {
    // Thursday 2026-01-01, restricted to Mon/Wed/Fri.
    final schedule = const MedicationSchedule(
      times: [MedicationTime(hour: 9, minute: 0)],
      days: {DateTime.monday, DateTime.wednesday, DateTime.friday},
    );
    final now = DateTime(2026, 1, 1, 7); // Thursday, before 09:00
    final slots = nextOccurrences(schedule, now);

    // Next eligible day on/after Thursday is Friday 2026-01-02.
    expect(slots.single.nextOccurrence, DateTime(2026, 1, 2, 9));
  });

  test('an empty schedule (no times) returns no slots', () {
    final slots = nextOccurrences(
      const MedicationSchedule(times: []),
      DateTime(2026, 1, 1),
    );
    expect(slots, isEmpty);
  });

  test('storage round-trip preserves times and weekday set', () {
    const schedule = MedicationSchedule(
      times: [
        MedicationTime(hour: 9, minute: 0),
        MedicationTime(hour: 21, minute: 5),
      ],
      days: {1, 3, 5},
    );
    final restored = MedicationSchedule.fromStorage(
      scheduleTimes: schedule.storageTimes,
      scheduleDays: schedule.storageDays,
    );

    expect(restored.times, schedule.times);
    expect(restored.days, schedule.days);
  });

  test('a null scheduleDays round-trips to a daily (isDaily) schedule', () {
    final restored = MedicationSchedule.fromStorage(
      scheduleTimes: '09:00',
      scheduleDays: null,
    );
    expect(restored.isDaily, isTrue);
  });
}
