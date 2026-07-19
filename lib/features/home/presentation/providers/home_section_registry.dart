import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/quick_action_handler_registrations.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/home/domain/models/home_section_config.dart';
import 'package:lifeos/features/home/presentation/providers/home_providers.dart';
import 'package:lifeos/features/home/presentation/widgets/habit_streaks_card.dart';
import 'package:lifeos/features/home/presentation/widgets/my_lists_card.dart';
import 'package:lifeos/features/home/presentation/widgets/overview_stats_row.dart';
import 'package:lifeos/features/home/presentation/widgets/quick_actions_row.dart';
import 'package:lifeos/features/home/presentation/widgets/recent_notes_card.dart';
import 'package:lifeos/features/home/presentation/widgets/timeline_stepper_card.dart';
import 'package:lifeos/features/home/presentation/widgets/up_next_card.dart';
import 'package:lifeos/shared/responsive/responsive_builder.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

/// Stable ids for the 7 dashboard sections (excludes the Hero — see
/// docs/architecture.md for why the Hero isn't a reorderable "section" in
/// this sense). The Up Next/Habit Streaks pair and Recent Notes/My Lists
/// pair are each registered as ONE combined entry so their tablet
/// side-by-side layout survives reordering as a unit.
abstract final class HomeSectionIds {
  static const String overview = 'overview';
  static const String quickActions = 'quickActions';
  static const String upNextAndHabits = 'upNextAndHabits';
  static const String timeline = 'timeline';
  static const String notesAndLists = 'notesAndLists';
}

/// The default, ordered, all-visible section metadata — this is
/// `homeSectionsProvider`'s initial state (see `home_providers.dart`) and
/// what a future Settings screen reorders/toggles. Plain data, no builder
/// closures — see `HomeSectionMeta`'s doc comment for why.
const List<HomeSectionMeta> kDefaultHomeSections = [
  HomeSectionMeta(
    id: HomeSectionIds.overview,
    order: 0,
    visible: true,
    displayName: 'Overview',
    icon: Icons.bar_chart_rounded,
  ),
  HomeSectionMeta(
    id: HomeSectionIds.quickActions,
    order: 1,
    visible: true,
    displayName: 'Quick Actions',
    icon: Icons.bolt_rounded,
  ),
  HomeSectionMeta(
    id: HomeSectionIds.upNextAndHabits,
    order: 2,
    visible: true,
    displayName: 'Up Next & Habit Streaks',
    icon: Icons.event_available_rounded,
  ),
  HomeSectionMeta(
    id: HomeSectionIds.timeline,
    order: 3,
    visible: true,
    displayName: "Today's Timeline",
    icon: Icons.timeline_rounded,
  ),
  HomeSectionMeta(
    id: HomeSectionIds.notesAndLists,
    order: 4,
    visible: true,
    displayName: 'Recent Notes & My Lists',
    icon: Icons.note_alt_rounded,
  ),
];

/// One dashboard section's complete contribution: its metadata (for
/// ordering/visibility, unchanged from [HomeSectionMeta]) paired with its
/// live builder. Replaces the previous two-step "const meta list +
/// separately keyed builder map" — `HomeScreen` now renders
/// `dashboardSections(ref)` directly instead of joining two collections by
/// id, which is the seam a future contributed section (e.g. a Health
/// module's "Today's Water") plugs into without `HomeScreen` changing.
/// [HomeSectionMeta]'s own ordering/visibility fields and
/// `homeSectionsProvider` are unchanged — this only restructures how a
/// section's meta and builder travel together.
@immutable
class DashboardSection {
  const DashboardSection({required this.meta, required this.builder});

  final HomeSectionMeta meta;
  final HomeSectionBuilder builder;
}

/// Combines [kDefaultHomeSections]' live (possibly reordered/hidden)
/// counterpart from `homeSectionsProvider` with each id's builder from
/// [buildHomeSectionBuilders]. `HomeScreen` reads this directly instead of
/// looking up a builder map by id itself.
List<DashboardSection> dashboardSections(WidgetRef ref) {
  final metas = [...ref.watch(homeSectionsProvider)]
    ..sort((a, b) => a.order.compareTo(b.order));
  final builders = buildHomeSectionBuilders(ref);
  return [
    for (final meta in metas)
      DashboardSection(meta: meta, builder: builders[meta.id]!),
  ];
}

/// Unwraps an `AsyncValue<List<T>>` into a widget: the shared loading
/// placeholder while loading, an empty list on error (never crashes the
/// dashboard on a data-layer failure), or [builder] applied to the
/// resolved list.
Widget _unwrapList<T>(
  AsyncValue<List<T>> value,
  Widget Function(List<T> data) builder,
) {
  return value.when(
    data: builder,
    loading: () => const SectionLoadingPlaceholder(),
    error: (error, stackTrace) => builder(const []),
  );
}

/// Builds the live id→builder map. A function (not a static const) since
/// each closure needs `ref` for its `AsyncValue` unwrap — called once per
/// `HomeScreen` build. Keys match [HomeSectionIds] / [kDefaultHomeSections]
/// ids exactly; `HomeScreen` looks up each visible, ordered
/// `HomeSectionMeta.id` here to get its widget.
Map<String, HomeSectionBuilder> buildHomeSectionBuilders(WidgetRef ref) {
  return {
    HomeSectionIds.overview: (context) => _unwrapList(
      ref.watch(overviewStatsProvider),
      (stats) => OverviewStatsRow(
        stats: [
          for (final stat in stats)
            if (stat.label == 'Focus')
              stat.copyWith(onTap: () => context.pushNamed(RouteNames.focus))
            else
              stat,
        ],
      ),
    ),
    HomeSectionIds.quickActions: (context) =>
        _unwrapList(ref.watch(quickActionsProvider), (actions) {
          final handlers = ref.watch(quickActionHandlersProvider);
          return QuickActionsRow(
            actions: actions,
            onActionTap: {
              for (final entry in handlers.entries)
                entry.key: () => entry.value(context),
            },
            onViewAll: () {},
          );
        }),
    HomeSectionIds.upNextAndHabits: (context) => _unwrapList(
      ref.watch(upNextProvider),
      (upNext) => _unwrapList(
        ref.watch(habitStreaksProvider),
        (habits) => ResponsiveBuilder(
          phone: (context) => Column(
            children: [
              UpNextCard(
                items: upNext,
                onDismiss: (id) =>
                    ref.read(upNextProvider.notifier).dismiss(id),
              ),
              const SizedBox(height: AppSpacing.lg),
              HabitStreaksCard(streaks: habits),
            ],
          ),
          tablet: (context) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: UpNextCard(
                  items: upNext,
                  onDismiss: (id) =>
                      ref.read(upNextProvider.notifier).dismiss(id),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: HabitStreaksCard(streaks: habits)),
            ],
          ),
        ),
      ),
    ),
    HomeSectionIds.timeline: (context) => _unwrapList(
      ref.watch(timelineProvider),
      (steps) => TimelineStepperCard(
        steps: steps,
        onDismiss: (id) => ref.read(timelineProvider.notifier).dismiss(id),
        onStepTap: (id) => context.pushNamed(
          RouteNames.timelineDetail,
          pathParameters: {'stepId': id},
        ),
      ),
    ),
    HomeSectionIds.notesAndLists: (context) => _unwrapList(
      ref.watch(recentNotesProvider),
      (notes) => _unwrapList(
        ref.watch(myListsProvider),
        (lists) => ResponsiveBuilder(
          phone: (context) => Column(
            children: [
              RecentNotesCard(
                notes: notes,
                onNoteTap: (id) => context.pushNamed(
                  RouteNames.noteDetail,
                  pathParameters: {'noteId': id},
                ),
                onViewAll: () => context.pushNamed(RouteNames.notes),
              ),
              const SizedBox(height: AppSpacing.lg),
              MyListsCard(
                lists: lists,
                onListTap: (id) => context.pushNamed(
                  RouteNames.listDetail,
                  pathParameters: {'listId': id},
                ),
                onViewAll: () => context.pushNamed(RouteNames.lists),
              ),
            ],
          ),
          tablet: (context) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RecentNotesCard(
                  notes: notes,
                  onNoteTap: (id) => context.pushNamed(
                    RouteNames.noteDetail,
                    pathParameters: {'noteId': id},
                  ),
                  onViewAll: () => context.pushNamed(RouteNames.notes),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: MyListsCard(
                  lists: lists,
                  onListTap: (id) => context.pushNamed(
                    RouteNames.listDetail,
                    pathParameters: {'listId': id},
                  ),
                  onViewAll: () => context.pushNamed(RouteNames.lists),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  };
}
