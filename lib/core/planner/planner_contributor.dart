import 'package:lifeos/core/planner/planner_item.dart';

/// A feature's contribution to the Planner's flat, cross-feature
/// [PlannerItem] stream — the same "contributor registered at the
/// composition layer" shape as [SearchContributor]/[NotificationContributor]/
/// `AgendaContributor`, introduced in Phase 6 once a second real source
/// (Habits) existed alongside Reminders. Before this, `_plannerItemsProvider`
/// only ever watched `RemindersRepository` directly — with two sources,
/// doing that for both would mean Planner's own provider importing
/// `HabitsRepository`, so this interface exists to keep that seam neutral
/// exactly like the other three contributor types (see
/// `docs/architecture_principles.md`'s Architecture Constraint 3).
///
/// [complete] is the only feature-specific *behavior* this interface needs
/// to expose (not just data): completing a [PlannerItem] means different
/// things per source (Reminders: advance/complete via `setCompleted`;
/// Habits: `setCompletedForDate` for the item's own [PlannerItem.scheduledAt]
/// day) and Planner must never encode that branching itself. Navigation is
/// NOT part of this interface — [PlannerItem.routeName]/[PlannerItem.pathParameters]
/// already carry everything `PlannerScreen` needs to push to the right
/// detail screen generically (mirrors `SearchableEntity`'s existing
/// pattern), so a `navigate`/`open` method here would be redundant data,
/// not new capability.
abstract interface class PlannerContributor {
  /// The [PlannerSourceType] this contributor produces items for — lets
  /// callers (e.g. Planner's completion handler) find "the contributor that
  /// owns this item" via `contributors.firstWhere((c) => c.sourceType ==
  /// item.sourceType)` instead of matching on concrete runtime types.
  PlannerSourceType get sourceType;

  /// Live [PlannerItem]s this feature currently contributes, across all
  /// dates — day-filtering is [plannerDayFor]'s job, not the contributor's.
  ///
  /// [anchor] is the date Planner is currently showing (see
  /// `plannerSelectedDateProvider`). Contributors backed by real persisted
  /// rows (Reminders, Calendar Events) can ignore it entirely — every row
  /// is already a real item regardless of date. It exists for contributors
  /// that must *materialize* items on the fly because an "occurrence" isn't
  /// itself a stored row (Habits: a habit occurrence only exists
  /// conceptually on days its schedule says yes — see
  /// `HabitsPlannerContributor`), so they can center their materialization
  /// window on whatever date the user is actually viewing instead of a
  /// fixed window around "today" that silently stops covering the Planner
  /// once the user navigates far enough away (the Phase 6 limitation this
  /// parameter replaces — see `docs/future_work.md`'s prior entry on it).
  Stream<List<PlannerItem>> contributions(DateTime anchor);

  /// Completes (or un-completes) the occurrence [item] represents, using
  /// whatever semantics the owning feature defines for "complete" — a
  /// contributor only ever receives back a [PlannerItem] it itself
  /// produced (matched by [PlannerItem.sourceType]), so it's safe to assume
  /// [item.sourceId] is one of its own entity ids. Never called for an item
  /// with [PlannerItem.canComplete] false (Calendar Events) — `PlannerScreen`
  /// doesn't render a complete action for those at all.
  Future<void> complete(PlannerItem item, {required bool completed});
}
