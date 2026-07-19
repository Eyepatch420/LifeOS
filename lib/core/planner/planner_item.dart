import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_item.freezed.dart';

/// One schedulable thing shown on the Planner's day timeline — a neutral
/// projection over whatever feature actually owns the underlying data, so
/// `PlannerScreen`/the day-derivation logic never needs direct knowledge of
/// `Reminder`/`Habit` (or, later, an Event/Bill entity). [sourceType]/
/// [sourceId] let Planner route taps/completion back to the owning
/// feature's real detail screen and repository without holding a reference
/// to either itself; [routeName]/[pathParameters] mirror
/// `SearchableEntity`'s existing navigation-metadata pattern so
/// `PlannerScreen` can push to detail generically instead of switching on
/// [sourceType].
///
/// Deliberately NOT reusing `core/agenda/AgendaEntry`: that type is shaped
/// for Home's Timeline row (fixed `icon`/`dotColor`, no completion state,
/// no recurrence flag) and forcing Planner onto it would mean either
/// bolting on fields Home's Agenda never needed or losing information
/// Planner requires (`isCompleted`, `isRecurring`) — see Phase 5's plan.
/// This is the smallest shape that covers today's two contributors
/// (Reminders, Habits) and stays addable-to for a future Event/Bill
/// contributor without a rewrite.
///
/// Lives in `core/planner/` (not `features/reminders/`) as of Phase 6:
/// Habits needed to produce this same shape, and a feature-owned type
/// can't be imported by a second feature without violating the Golden Rule
/// (see `test/contracts/import_boundary_test.dart`) — mirrors why
/// `AgendaEntry`/`SearchableEntity` also live under `core/`/a shared
/// feature rather than inside Reminders.
///
/// [temporalKind]/[canComplete] were added in Phase 7 once Calendar Events
/// became a third contributor: an event has no "complete" action (it isn't
/// a task) and an all-day event has no meaningful clock time, so both
/// PlannerScreen-visible capabilities became explicit neutral fields
/// instead of PlannerScreen switching on [sourceType] — see
/// [PlannerContributor]'s doc comment and `docs/architecture_principles.md`.
/// [scheduledAt] keeps its existing meaning for every source (the instant
/// used for day-classification/sorting); for an all-day item it is the
/// [dateOnly]-normalized day.
@freezed
abstract class PlannerItem with _$PlannerItem {
  const factory PlannerItem({
    required String id,
    required PlannerSourceType sourceType,
    required String sourceId,
    required String title,
    required DateTime scheduledAt,
    required bool isCompleted,
    required bool isUrgent,
    required bool isRecurring,
    required String routeName,
    required Map<String, String> pathParameters,
    @Default(PlannerTemporalKind.timed) PlannerTemporalKind temporalKind,
    @Default(true) bool canComplete,
  }) = _PlannerItem;
}

/// Which feature a [PlannerItem] was projected from. Exists so
/// [PlannerContributor]'s owner can be identified for completion routing
/// (see `plannerContributorsProvider`'s doc comment) without Planner
/// importing each feature's repository directly.
enum PlannerSourceType { reminder, habit, event }

/// Whether a [PlannerItem] has a specific clock time ([timed], the default —
/// Reminders/Habits both have one) or only a calendar date ([allDay] — an
/// all-day Calendar event). Lets `PlannerScreen` group/render all-day items
/// separately from a timeline without fabricating a misleading "12:00 AM"
/// time or special-casing `sourceType == event`.
enum PlannerTemporalKind { timed, allDay }
