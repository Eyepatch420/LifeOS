import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/domain/models/reminders_dashboard_data.dart';

void main() {
  // Fixed "now" so every test is deterministic — never DateTime.now().
  final now = DateTime(2026, 6, 15, 12); // Monday, 15 June 2026, 12:00.

  Reminder reminder({
    required String id,
    required DateTime dueAt,
    bool isCompleted = false,
    bool isUrgent = false,
    DateTime? completedAt,
  }) {
    return Reminder(
      id: id,
      title: 'Reminder $id',
      dueAt: dueAt,
      isUrgent: isUrgent,
      isCompleted: isCompleted,
      recurrence: RecurrenceRule.none,
      completedAt: completedAt,
    );
  }

  test(
    'zero reminders yields RemindersDashboardData.empty-equivalent state',
    () {
      final result = remindersForDashboard([], now: now);

      expect(result.today, isEmpty);
      expect(result.upcoming, isEmpty);
      expect(result.overdue, isEmpty);
      expect(result.upNext, isNull);
      expect(result.pendingCount, 0);
      expect(result.completedCount, 0);
      expect(result.overdueCount, 0);
      expect(result.todayCount, 0);
      expect(result.isEmpty, isTrue);
    },
  );

  test('a reminder due later today is classified as today, not upcoming', () {
    final r = reminder(id: 'a', dueAt: DateTime(2026, 6, 15, 18));

    final result = remindersForDashboard([r], now: now);

    expect(result.today, [r]);
    expect(result.upcoming, isEmpty);
    expect(result.overdue, isEmpty);
    expect(result.todayCount, 1);
  });

  test(
    'multiple reminders today are all included in today, sorted by time',
    () {
      final early = reminder(id: 'early', dueAt: DateTime(2026, 6, 15, 14));
      final late = reminder(id: 'late', dueAt: DateTime(2026, 6, 15, 20));

      final result = remindersForDashboard([late, early], now: now);

      expect(result.today, [early, late]);
      expect(result.todayCount, 2);
    },
  );

  test('a reminder due on a future calendar day is upcoming, not today', () {
    final r = reminder(id: 'future', dueAt: DateTime(2026, 6, 16, 9));

    final result = remindersForDashboard([r], now: now);

    expect(result.upcoming, [r]);
    expect(result.today, isEmpty);
    expect(result.overdue, isEmpty);
  });

  test('a reminder whose due time has already passed today is overdue', () {
    final r = reminder(id: 'overdue', dueAt: DateTime(2026, 6, 15, 9));

    final result = remindersForDashboard([r], now: now);

    expect(result.overdue, [r]);
    expect(result.overdueCount, 1);
    // Overdue-but-due-today also appears in today, by design (see the
    // function's doc comment: the buckets intentionally overlap here).
    expect(result.today, [r]);
  });

  test('a reminder due on a past calendar day is overdue, not today', () {
    final r = reminder(id: 'yesterday', dueAt: DateTime(2026, 6, 14, 9));

    final result = remindersForDashboard([r], now: now);

    expect(result.overdue, [r]);
    expect(result.today, isEmpty);
    expect(result.upcoming, isEmpty);
  });

  test('a completed reminder is excluded from today/upcoming/overdue/upNext '
      'but counted in completedCount', () {
    final r = reminder(
      id: 'done',
      dueAt: DateTime(2026, 6, 15, 9),
      isCompleted: true,
      completedAt: now,
    );

    final result = remindersForDashboard([r], now: now);

    expect(result.today, isEmpty);
    expect(result.upcoming, isEmpty);
    expect(result.overdue, isEmpty);
    expect(result.upNext, isNull);
    expect(result.completedCount, 1);
    expect(result.pendingCount, 0);
  });

  test('a mix of completed and pending reminders is classified correctly', () {
    final pending = reminder(id: 'pending', dueAt: DateTime(2026, 6, 16));
    final done = reminder(
      id: 'done',
      dueAt: DateTime(2026, 6, 15, 9),
      isCompleted: true,
    );

    final result = remindersForDashboard([pending, done], now: now);

    expect(result.pendingCount, 1);
    expect(result.completedCount, 1);
    expect(result.upcoming, [pending]);
  });

  test('upcoming reminders are sorted chronologically', () {
    final later = reminder(id: 'later', dueAt: DateTime(2026, 6, 20));
    final sooner = reminder(id: 'sooner', dueAt: DateTime(2026, 6, 17));

    final result = remindersForDashboard([later, sooner], now: now);

    expect(result.upcoming, [sooner, later]);
  });

  test('upNext selects the nearest actionable (pending) reminder overall', () {
    final soon = reminder(id: 'soon', dueAt: DateTime(2026, 6, 15, 15));
    final later = reminder(id: 'later', dueAt: DateTime(2026, 6, 20));

    final result = remindersForDashboard([later, soon], now: now);

    expect(result.upNext, soon);
  });

  test('upNext prefers an overdue reminder over a future one, since overdue '
      'sorts earliest by dueAt', () {
    final overdue = reminder(id: 'overdue', dueAt: DateTime(2026, 6, 10));
    final future = reminder(id: 'future', dueAt: DateTime(2026, 6, 20));

    final result = remindersForDashboard([future, overdue], now: now);

    expect(result.upNext, overdue);
  });

  test('a reminder due exactly at the start of today (midnight) counts as '
      'today, not overdue relative to the day boundary', () {
    final r = reminder(id: 'midnight', dueAt: DateTime(2026, 6, 15));

    final result = remindersForDashboard([r], now: now);

    expect(result.today, [r]);
    // 00:00 today is still strictly before `now` (12:00 today), so it is
    // also overdue by the time-based definition — both buckets are
    // intentionally allowed to include it, per the doc comment.
    expect(result.overdue, [r]);
  });

  test('a reminder due exactly at the boundary between today and tomorrow '
      '(midnight of the next day) counts as upcoming, not today', () {
    final r = reminder(id: 'nextMidnight', dueAt: DateTime(2026, 6, 16));

    final result = remindersForDashboard([r], now: now);

    expect(result.upcoming, [r]);
    expect(result.today, isEmpty);
  });

  test('a reminder due exactly at "now" is not overdue (only strictly-past '
      'due times are overdue)', () {
    final r = reminder(id: 'exactlyNow', dueAt: now);

    final result = remindersForDashboard([r], now: now);

    expect(result.overdue, isEmpty);
    expect(result.today, [r]);
  });
}
