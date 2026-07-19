import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/utils/date_only.dart';

/// The Calendar workspace's selected day — pure UI/navigation state, never
/// persisted to Drift, and deliberately independent from
/// `plannerSelectedDateProvider`: changing which day Calendar is showing
/// must not silently move Planner's own selected day out from under the
/// user, and vice versa (see Phase 7 plan's explicit requirement). Mirrors
/// `PlannerSelectedDateNotifier`'s shape exactly, including the "doesn't
/// follow midnight rollover automatically" behavior.
class CalendarSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void selectDate(DateTime date) => state = dateOnly(date);

  void previousDay() => state = state.subtract(const Duration(days: 1));

  void nextDay() => state = state.add(const Duration(days: 1));

  void resetToToday() => state = dateOnly(DateTime.now());
}

final calendarSelectedDateProvider =
    NotifierProvider<CalendarSelectedDateNotifier, DateTime>(
      CalendarSelectedDateNotifier.new,
    );
