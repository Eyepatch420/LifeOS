import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/domain/planner/planner_day_data.dart';
import 'package:lifeos/core/planner/planner_item.dart';

PlannerItem _item({
  required String id,
  required DateTime scheduledAt,
  bool isCompleted = false,
  bool isUrgent = false,
  bool isRecurring = false,
}) {
  return PlannerItem(
    id: id,
    sourceType: PlannerSourceType.reminder,
    sourceId: id,
    title: 'Item $id',
    scheduledAt: scheduledAt,
    isCompleted: isCompleted,
    isUrgent: isUrgent,
    isRecurring: isRecurring,
    routeName: 'reminderDetail',
    pathParameters: {'reminderId': id},
  );
}

void main() {
  final today = DateTime(2026, 7, 18, 9);

  group('plannerDayFor', () {
    test('empty reminder list yields an empty day', () {
      final result = plannerDayFor([], date: today, now: today);
      expect(result.isEmpty, isTrue);
      expect(result.scheduled, isEmpty);
      expect(result.overdueCarryover, isEmpty);
    });

    test('one item scheduled for the selected day is included', () {
      final item = _item(id: 'a', scheduledAt: DateTime(2026, 7, 18, 14));
      final result = plannerDayFor([item], date: today, now: today);
      expect(result.scheduled, [item]);
    });

    test('multiple items are sorted chronologically', () {
      final late = _item(id: 'late', scheduledAt: DateTime(2026, 7, 18, 18));
      final early = _item(id: 'early', scheduledAt: DateTime(2026, 7, 18, 8));
      final mid = _item(id: 'mid', scheduledAt: DateTime(2026, 7, 18, 12));
      final result = plannerDayFor([late, early, mid], date: today, now: today);
      expect(result.scheduled, [early, mid, late]);
    });

    test('completed item is still shown in scheduled, subdued elsewhere', () {
      final item = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 18, 10),
        isCompleted: true,
      );
      final result = plannerDayFor([item], date: today, now: today);
      expect(result.scheduled, [item]);
      expect(result.completedCount, 1);
      expect(result.pendingCount, 0);
    });

    test('pending item counts toward pendingCount', () {
      final item = _item(id: 'a', scheduledAt: DateTime(2026, 7, 18, 10));
      final result = plannerDayFor([item], date: today, now: today);
      expect(result.pendingCount, 1);
      expect(result.completedCount, 0);
    });

    test('urgent item is preserved in scheduled with isUrgent set', () {
      final item = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 18, 10),
        isUrgent: true,
      );
      final result = plannerDayFor([item], date: today, now: today);
      expect(result.scheduled.single.isUrgent, isTrue);
    });

    test('recurring item is preserved in scheduled with isRecurring set', () {
      final item = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 18, 10),
        isRecurring: true,
      );
      final result = plannerDayFor([item], date: today, now: today);
      expect(result.scheduled.single.isRecurring, isTrue);
    });

    test('today includes overdue carryover from previous days', () {
      final overdue = _item(id: 'old', scheduledAt: DateTime(2026, 7, 15, 9));
      final result = plannerDayFor(
        [overdue],
        date: today,
        now: DateTime(2026, 7, 18, 12),
      );
      expect(result.overdueCarryover, [overdue]);
      expect(result.scheduled, isEmpty);
    });

    test('overdue carryover excludes completed items', () {
      final overdue = _item(
        id: 'old',
        scheduledAt: DateTime(2026, 7, 15, 9),
        isCompleted: true,
      );
      final result = plannerDayFor(
        [overdue],
        date: today,
        now: DateTime(2026, 7, 18, 12),
      );
      expect(result.overdueCarryover, isEmpty);
    });

    test('earlier-today pending item stays in scheduled, not carryover', () {
      final earlierToday = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 18, 6),
      );
      final result = plannerDayFor(
        [earlierToday],
        date: today,
        now: DateTime(2026, 7, 18, 12),
      );
      expect(result.scheduled, [earlierToday]);
      expect(result.overdueCarryover, isEmpty);
    });

    test('future date excludes historical overdue items entirely', () {
      final overdue = _item(id: 'old', scheduledAt: DateTime(2026, 7, 10, 9));
      final futureDate = DateTime(2026, 7, 25);
      final result = plannerDayFor(
        [overdue],
        date: futureDate,
        now: DateTime(2026, 7, 18, 12),
      );
      expect(result.overdueCarryover, isEmpty);
    });

    test('past date shows its own scheduled items, not overdue carryover', () {
      final pastDay = DateTime(2026, 7, 10);
      final item = _item(id: 'a', scheduledAt: DateTime(2026, 7, 10, 9));
      final result = plannerDayFor(
        [item],
        date: pastDay,
        now: DateTime(2026, 7, 18, 12),
      );
      expect(result.scheduled, [item]);
      expect(result.overdueCarryover, isEmpty);
    });

    test('reminder exactly at 00:00 belongs to that calendar day', () {
      final midnight = _item(id: 'a', scheduledAt: DateTime(2026, 7, 18));
      final result = plannerDayFor([midnight], date: today, now: today);
      expect(result.scheduled, [midnight]);
    });

    test('reminder at 23:59 belongs to that calendar day, not the next', () {
      final lateNight = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 18, 23, 59),
      );
      final result = plannerDayFor([lateNight], date: today, now: today);
      expect(result.scheduled, [lateNight]);

      final nextDay = DateTime(2026, 7, 19);
      final resultNextDay = plannerDayFor(
        [lateNight],
        date: nextDay,
        now: today,
      );
      expect(resultNextDay.scheduled, isEmpty);
    });

    test('a recurring item after advancement appears only on its new date', () {
      // Simulates RemindersRepository.setCompleted advancing dueAt forward
      // — the single-row model means Planner only ever sees the item's
      // current scheduledAt, never a historical occurrence on the old day.
      final advanced = _item(
        id: 'a',
        scheduledAt: DateTime(2026, 7, 19, 9),
        isRecurring: true,
      );
      final resultOldDay = plannerDayFor([advanced], date: today, now: today);
      expect(resultOldDay.scheduled, isEmpty);

      final resultNewDay = plannerDayFor(
        [advanced],
        date: DateTime(2026, 7, 19),
        now: today,
      );
      expect(resultNewDay.scheduled, [advanced]);
    });

    test('date is normalized to the local calendar day regardless of time '
        'component passed in', () {
      final item = _item(id: 'a', scheduledAt: DateTime(2026, 7, 18, 10));
      final result = plannerDayFor(
        [item],
        date: DateTime(2026, 7, 18, 23, 59),
        now: today,
      );
      expect(result.date, DateTime(2026, 7, 18));
      expect(result.scheduled, [item]);
    });
  });
}
