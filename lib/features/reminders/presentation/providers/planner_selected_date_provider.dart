import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/utils/date_only.dart';

/// The Planner's selected day — pure UI/navigation state, never persisted
/// to Drift (see Phase 5 plan's note against over-persisting temporary UI
/// state). Defaults to today and is always normalized via [dateOnly] so
/// nothing downstream ever compares a selected "day" against a value that
/// still carries a time component.
///
/// Deliberately does NOT follow a midnight rollover automatically: if the
/// user selected a specific calendar date, it remains selected even after
/// midnight passes — only the `Today` action (`resetToToday`) jumps to the
/// new current day. This matches how a day planner should behave: the user's
/// choice of day shouldn't be yanked out from under them by the clock.
class PlannerSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void selectDate(DateTime date) => state = dateOnly(date);

  void previousDay() => state = state.subtract(const Duration(days: 1));

  void nextDay() => state = state.add(const Duration(days: 1));

  void resetToToday() => state = dateOnly(DateTime.now());
}

final plannerSelectedDateProvider =
    NotifierProvider<PlannerSelectedDateNotifier, DateTime>(
      PlannerSelectedDateNotifier.new,
    );
