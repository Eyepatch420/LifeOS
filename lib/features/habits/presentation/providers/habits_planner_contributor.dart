import 'dart:async';

import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';
import 'package:lifeos/core/planner/planner_contributor.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/data/repositories/habits_repository.dart';
import 'package:lifeos/features/habits/domain/entities/habit.dart';

/// How many days on either side of today Planner materializes a habit
/// occurrence for. Planner's date strip/header only ever navigate a
/// handful of days from today in practice (see `PlannerDateStrip`), and
/// habit "occurrences" aren't persisted rows the way reminders are — they
/// only exist conceptually on days [HabitSchedule.occursOn] says yes, so
/// this contributor has to materialize them on the fly rather than reading
/// them from a table. A wide-but-bounded window keeps that materialization
/// cheap and avoids an unbounded stream.
const _windowDays = 30;

/// Habits' contribution to the Planner's cross-feature item stream —
/// registered at `config/di/planner_contributor_registrations.dart`. Unlike
/// [RemindersPlannerContributor] (one [PlannerItem] per stored row), this
/// materializes one [PlannerItem] per (habit, scheduled day) pair within a
/// [_windowDays] window of today, since a habit occurrence isn't itself a
/// persisted row — only its completion is (see `HabitCompletions`' doc
/// comment). [PlannerItem.isRecurring] is always `true` for a habit
/// occurrence (a habit is inherently repeating), and [PlannerItem.isUrgent]
/// is always `false` (the domain model has no urgency concept — see
/// `Habit`'s doc comment on staying within this phase's actual MVP scope).
///
/// Re-derives and re-emits whenever the habit list changes OR any single
/// habit's completion history changes — implemented as a manual multi-
/// stream listener (no `rxdart` dependency in this project) rather than a
/// chain of `Stream` combinators, since the fan-out (one completion stream
/// per habit, with the set of habits itself changing over time) doesn't
/// map cleanly onto a fixed `StreamZip`/`combineLatest`.
class HabitsPlannerContributor implements PlannerContributor {
  const HabitsPlannerContributor(this._repository);

  final HabitsRepository _repository;

  @override
  PlannerSourceType get sourceType => PlannerSourceType.habit;

  @override
  Stream<List<PlannerItem>> contributions() {
    late final StreamController<List<PlannerItem>> controller;
    StreamSubscription<List<Habit>>? habitsSub;
    final completionSubs = <String, StreamSubscription<Set<DateTime>>>{};
    final completionsByHabit = <String, Set<DateTime>>{};
    // Ids whose completion stream has delivered at least one value —
    // `emit()` withholds its first item list until every currently-known
    // habit has one, so an early subscriber calling `.first` never
    // observes a transient "no habit has any completions yet" list before
    // the real completion state has loaded (see the bug this fixed: a
    // `.first`-based caller completing a habit and immediately re-reading
    // `contributions().first` could otherwise race the completion
    // stream's own first emission and see stale `isCompleted: false`).
    final loadedIds = <String>{};
    var habits = const <Habit>[];

    void emit() {
      if (!habits.every((h) => loadedIds.contains(h.id))) return;
      final items = <PlannerItem>[];
      for (final habit in habits) {
        items.addAll(
          _itemsFor(habit, completionsByHabit[habit.id] ?? const {}),
        );
      }
      controller.add(items);
    }

    void listenTo(Habit habit) {
      completionSubs[habit.id] ??= _repository
          .watchCompletionDates(habit.id)
          .listen((dates) {
            completionsByHabit[habit.id] = dates;
            loadedIds.add(habit.id);
            emit();
          });
    }

    controller = StreamController<List<PlannerItem>>(
      onListen: () {
        habitsSub = _repository.watchAll().listen((updated) {
          habits = updated;
          final currentIds = updated.map((h) => h.id).toSet();

          // Stop tracking habits that no longer exist/were archived out of
          // watchAll()'s result, so this doesn't leak a subscription per
          // habit ever created.
          final staleIds = completionSubs.keys
              .where((id) => !currentIds.contains(id))
              .toList();
          for (final id in staleIds) {
            completionSubs.remove(id)?.cancel();
            completionsByHabit.remove(id);
            loadedIds.remove(id);
          }

          for (final habit in updated) {
            listenTo(habit);
          }
          emit();
        });
      },
      onCancel: () async {
        await habitsSub?.cancel();
        for (final sub in completionSubs.values) {
          await sub.cancel();
        }
      },
    );

    return controller.stream;
  }

  @override
  Future<void> complete(PlannerItem item, {required bool completed}) {
    return _repository.setCompletedForDate(
      item.sourceId,
      item.scheduledAt,
      completed: completed,
    );
  }

  /// Materializes one [PlannerItem] per scheduled day in the window,
  /// EXCEPT incomplete days strictly before today: [plannerDayFor]'s
  /// overdue-carryover logic (designed for Reminders, whose single-row
  /// model means an incomplete past `dueAt` genuinely means "still not
  /// done") would otherwise treat every incomplete day in the whole
  /// [_windowDays] past-window as "needs attention" — but a habit's past
  /// occurrences are independent per-day events, not a single carried-over
  /// task, so a day the user simply didn't do the habit isn't "overdue" in
  /// that sense and must not be fabricated as a Planner item at all (same
  /// "no historical occurrence fabrication" principle documented on
  /// `plannerDayFor`). A past day the habit WAS completed still gets an
  /// item, so that day's own timeline can show it.
  List<PlannerItem> _itemsFor(Habit habit, Set<DateTime> completedDates) {
    final today = dateOnly(DateTime.now());
    final items = <PlannerItem>[];
    for (var offset = -_windowDays; offset <= _windowDays; offset++) {
      final day = today.add(Duration(days: offset));
      if (!habit.schedule.occursOn(day)) continue;
      final isCompleted = completedDates.contains(day);
      if (day.isBefore(today) && !isCompleted) continue;
      items.add(
        PlannerItem(
          id: 'habit:${habit.id}:${day.localDateKey}',
          sourceType: PlannerSourceType.habit,
          sourceId: habit.id,
          title: habit.title,
          scheduledAt: day,
          isCompleted: isCompleted,
          isUrgent: false,
          isRecurring: true,
          routeName: RouteNames.habitDetail,
          pathParameters: {'habitId': habit.id},
        ),
      );
    }
    return items;
  }
}
