import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/domain/entities/habit_streak.dart';

DateTime _d(int day) => DateTime(2026, 7, day);

void main() {
  group('calculateHabitStreak', () {
    test('zero history yields a zero streak', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {},
        now: _d(16),
      );
      expect(result.current, 0);
      expect(result.best, 0);
    });

    test('one completion today yields a streak of 1', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(16)},
        now: _d(16).add(const Duration(hours: 9)),
      );
      expect(result.current, 1);
    });

    test('consecutive daily completions accumulate', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(14), _d(15), _d(16)},
        now: _d(16),
      );
      expect(result.current, 3);
    });

    test('a gap breaks the daily streak', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(12), _d(13), _d(16)},
        now: _d(16),
      );
      expect(result.current, 1);
    });

    test('a Mon/Wed/Fri habit does not break streak on an unscheduled day', () {
      // 2026-07-13 is a Monday, 15 Wed, 17 Fri.
      final result = calculateHabitStreak(
        schedule: HabitSchedule.weekly({1, 3, 5}),
        completedDates: {_d(13), _d(15), _d(17)},
        now: _d(17),
      );
      expect(result.current, 3);
    });

    test('multiple scheduled weekdays only count scheduled occurrences', () {
      // Weekdays only (Mon-Fri): 13,14,15,16,17 = Mon-Fri.
      final result = calculateHabitStreak(
        schedule: HabitSchedule.weekly({1, 2, 3, 4, 5}),
        completedDates: {_d(13), _d(14), _d(15), _d(16), _d(17)},
        now: _d(17),
      );
      expect(result.current, 5);
    });

    test(
      'today pending (not yet completed) does not break an existing streak',
      () {
        final result = calculateHabitStreak(
          schedule: const HabitSchedule.daily(),
          completedDates: {_d(14), _d(15)},
          now: _d(16).add(const Duration(hours: 8)),
        );
        // Today (16th) is scheduled but not completed yet; doesn't count
        // toward current, but doesn't zero it out either.
        expect(result.current, 2);
      },
    );

    test('today completed counts as the first day of the streak', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(15), _d(16)},
        now: _d(16),
      );
      expect(result.current, 2);
    });

    test('future completion records are ignored', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(16), _d(17), _d(18)},
        now: _d(16),
      );
      expect(result.current, 1);
    });

    test('duplicate completion dates in the set do not double-count', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(16), _d(16)},
        now: _d(16),
      );
      expect(result.current, 1);
    });

    test('a DateTime with a time-of-day component still normalizes', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {DateTime(2026, 7, 16, 23, 59)},
        now: DateTime(2026, 7, 16, 8),
      );
      expect(result.current, 1);
    });

    test('best streak can exceed the current (active) streak', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(10), _d(11), _d(12), _d(13), _d(16)},
        now: _d(16),
      );
      expect(result.current, 1);
      expect(result.best, 4);
    });

    test('best streak is at least the current streak', () {
      final result = calculateHabitStreak(
        schedule: const HabitSchedule.daily(),
        completedDates: {_d(15), _d(16)},
        now: _d(16),
      );
      expect(result.best, greaterThanOrEqualTo(result.current));
    });
  });
}
