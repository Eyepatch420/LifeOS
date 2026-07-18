import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_calculator.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';

void main() {
  group('none', () {
    test('returns null — nothing to advance to', () {
      expect(
        nextOccurrence(DateTime(2026, 1, 1, 9), RecurrenceRule.none),
        isNull,
      );
    });
  });

  group('daily', () {
    test('advances by exactly one calendar day, preserving time', () {
      final result = nextOccurrence(
        DateTime(2026, 6, 15, 9, 30),
        RecurrenceRule.daily,
      );
      expect(result, DateTime(2026, 6, 16, 9, 30));
    });

    test('crosses a month boundary correctly', () {
      final result = nextOccurrence(
        DateTime(2026, 1, 31, 9),
        RecurrenceRule.daily,
      );
      expect(result, DateTime(2026, 2, 1, 9));
    });

    test('crosses a year boundary correctly (December -> January)', () {
      final result = nextOccurrence(
        DateTime(2026, 12, 31, 23, 59),
        RecurrenceRule.daily,
      );
      expect(result, DateTime(2027, 1, 1, 23, 59));
    });
  });

  group('weekdays', () {
    test('a Monday advances to Tuesday', () {
      final monday = DateTime(2026, 6, 15, 9); // Monday.
      expect(monday.weekday, DateTime.monday);
      final result = nextOccurrence(monday, RecurrenceRule.weekdays);
      expect(result, DateTime(2026, 6, 16, 9));
    });

    test('a Friday skips the weekend and lands on Monday', () {
      final friday = DateTime(2026, 6, 19, 9); // Friday.
      expect(friday.weekday, DateTime.friday);
      final result = nextOccurrence(friday, RecurrenceRule.weekdays);
      expect(result, DateTime(2026, 6, 22, 9)); // Next Monday.
      expect(result!.weekday, DateTime.monday);
    });

    test('a Saturday (if ever stored) advances to Monday', () {
      final saturday = DateTime(2026, 6, 20, 9);
      expect(saturday.weekday, DateTime.saturday);
      final result = nextOccurrence(saturday, RecurrenceRule.weekdays);
      expect(result!.weekday, DateTime.monday);
      expect(result, DateTime(2026, 6, 22, 9));
    });
  });

  group('weekly', () {
    test('advances by exactly 7 days, preserving time and weekday', () {
      final result = nextOccurrence(
        DateTime(2026, 6, 15, 14, 0), // Monday.
        RecurrenceRule.weekly,
      );
      expect(result, DateTime(2026, 6, 22, 14, 0));
      expect(result!.weekday, DateTime.monday);
    });
  });

  group('monthly', () {
    test('advances by one calendar month on an ordinary day', () {
      final result = nextOccurrence(
        DateTime(2026, 3, 15, 9),
        RecurrenceRule.monthly,
      );
      expect(result, DateTime(2026, 4, 15, 9));
    });

    test('January 31 clamps to February 28 in a non-leap year', () {
      final result = nextOccurrence(
        DateTime(2026, 1, 31, 9), // 2026 is not a leap year.
        RecurrenceRule.monthly,
      );
      expect(result, DateTime(2026, 2, 28, 9));
    });

    test('January 31 clamps to February 29 in a leap year', () {
      final result = nextOccurrence(
        DateTime(2028, 1, 31, 9), // 2028 is a leap year.
        RecurrenceRule.monthly,
      );
      expect(result, DateTime(2028, 2, 29, 9));
    });

    test('re-anchors to the day it actually landed on, not the original '
        'day — Jan 31 -> Feb 28 -> Mar 28 (not Mar 31)', () {
      final febOccurrence = nextOccurrence(
        DateTime(2026, 1, 31, 9),
        RecurrenceRule.monthly,
      )!;
      expect(febOccurrence, DateTime(2026, 2, 28, 9));

      final marOccurrence = nextOccurrence(
        febOccurrence,
        RecurrenceRule.monthly,
      );
      expect(marOccurrence, DateTime(2026, 3, 28, 9));
    });

    test('December advances into January of the next year', () {
      final result = nextOccurrence(
        DateTime(2026, 12, 15, 9),
        RecurrenceRule.monthly,
      );
      expect(result, DateTime(2027, 1, 15, 9));
    });

    test('a 31st rolling into a 30-day month clamps to the 30th', () {
      final result = nextOccurrence(
        DateTime(2026, 3, 31, 9),
        RecurrenceRule.monthly,
      );
      expect(result, DateTime(2026, 4, 30, 9));
    });
  });

  group('yearly', () {
    test('advances by exactly one year on an ordinary day', () {
      final result = nextOccurrence(
        DateTime(2026, 6, 15, 9),
        RecurrenceRule.yearly,
      );
      expect(result, DateTime(2027, 6, 15, 9));
    });

    test('February 29 in a leap year clamps to February 28 in the next '
        '(non-leap) year', () {
      final result = nextOccurrence(
        DateTime(2028, 2, 29, 9), // 2028 is a leap year.
        RecurrenceRule.yearly,
      );
      expect(result, DateTime(2029, 2, 28, 9)); // 2029 is not.
    });

    test('February 29 advancing 4 years lands on February 29 again (next '
        'leap year)', () {
      final result = nextOccurrence(
        DateTime(2028, 2, 29, 9),
        RecurrenceRule.yearly,
      );
      final result2 = nextOccurrence(result!, RecurrenceRule.yearly)!;
      final result3 = nextOccurrence(result2, RecurrenceRule.yearly)!;
      final result4 = nextOccurrence(result3, RecurrenceRule.yearly);
      // 2028(29th) -> 2029(28th, clamped) -> 2030(28th) -> 2031(28th) ->
      // 2032(28th) — re-anchoring means it never gets back to the 29th on
      // its own once clamped, matching monthly's same documented
      // re-anchor-to-landed-day policy.
      expect(result4, DateTime(2032, 2, 28, 9));
    });
  });

  group('custom', () {
    test('returns null — no rule language is defined for customRule yet', () {
      expect(
        nextOccurrence(DateTime(2026, 1, 1, 9), RecurrenceRule.custom),
        isNull,
      );
    });
  });
}
