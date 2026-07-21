import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/presentation/providers/planning_workspace_section_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_data_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/planner_screen.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_hero_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/shared/widgets/layouts/floating_page_layout.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// Which workspace-nav item is currently active — drives both the pill
/// highlight in [RemindersWorkspaceNav] and which of the four workspace
/// bodies [PlanningWorkspaceScaffold] shows (see
/// [planningWorkspaceSectionProvider]).
enum PlanningWorkspaceSection { reminders, planner, habits, calendar }

/// Shared shell AND sole owner of the four tabs that belong to the orange
/// Reminders/Planner planning workspace: hero (sunset SVG, greeting,
/// search/notifications/profile, workspace nav) + [FloatingPageLayout]/
/// [HeroScaffold] composition, switching between [PlannerScreen] (same
/// feature, constructed directly) and [remindersBody]/[habitsBody]/
/// [calendarBody] (injected by the router, which — unlike this widget — is
/// allowed to import other features' `presentation/screens/` directly; see
/// `test/contracts/import_boundary_test.dart`) as pure local state
/// ([planningWorkspaceSectionProvider]) instead of navigation — so the hero
/// and the sheet's scroll position are never rebuilt/lost on tab switch, and
/// the floating bottom nav (which lives outside this widget, in
/// `AppShell`/`StatefulShellRoute`) is never covered by a pushed page.
///
/// All four bodies are kept mounted simultaneously via [Visibility]
/// (`maintainState: true`) + [_KeepAlive] rather than rebuilt on each
/// switch, so any future per-tab state (filters, selections, in-progress
/// search/text entry) survives switching away and back, matching how
/// [TabBarView] keeps its pages alive.
///
/// Does NOT modify [HeroScaffold] itself — that stays a fully generic,
/// feature-agnostic scroll/hero primitive; all planning-workspace-specific
/// knowledge (which hero, which nav items, which bodies, workspace theme)
/// lives here, one level below it.
class PlanningWorkspaceScaffold extends ConsumerWidget {
  const PlanningWorkspaceScaffold({
    required this.remindersBody,
    required this.habitsBody,
    required this.calendarBody,
    super.key,
  });

  /// `RemindersDashboardScreen()`, supplied by the router.
  final Widget remindersBody;

  /// `HabitsDashboardScreen()`, supplied by the router.
  final Widget habitsBody;

  /// `CalendarDashboardScreen()`, supplied by the router.
  final Widget calendarBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(remindersClockTickProvider).value ?? DateTime.now();
    final theme = ref.watch(activeWorkspaceThemeProvider);
    final profile = ref.watch(userProfileNotifierProvider).value;
    final section = ref.watch(planningWorkspaceSectionProvider);
    final sectionNotifier = ref.read(planningWorkspaceSectionProvider.notifier);

    final navItems = [
      RemindersWorkspaceNavItem(
        label: 'Reminders',
        icon: Icons.notifications_outlined,
        onSelected: section == PlanningWorkspaceSection.reminders
            ? null
            : () => sectionNotifier.select(PlanningWorkspaceSection.reminders),
      ),
      RemindersWorkspaceNavItem(
        label: 'Planner',
        icon: Icons.calendar_month_outlined,
        onSelected: section == PlanningWorkspaceSection.planner
            ? null
            : () => sectionNotifier.select(PlanningWorkspaceSection.planner),
      ),
      RemindersWorkspaceNavItem(
        label: 'Habits',
        icon: Icons.track_changes_outlined,
        onSelected: section == PlanningWorkspaceSection.habits
            ? null
            : () => sectionNotifier.select(PlanningWorkspaceSection.habits),
      ),
      RemindersWorkspaceNavItem(
        label: 'Calendar',
        icon: Icons.calendar_today_outlined,
        onSelected: section == PlanningWorkspaceSection.calendar
            ? null
            : () => sectionNotifier.select(PlanningWorkspaceSection.calendar),
      ),
    ];
    final selectedIndex = switch (section) {
      PlanningWorkspaceSection.reminders => 0,
      PlanningWorkspaceSection.planner => 1,
      PlanningWorkspaceSection.habits => 2,
      PlanningWorkspaceSection.calendar => 3,
    };

    return FloatingPageLayout(
      body: HeroScaffold(
        heroBuilder: (context, reportControlsRegion) => RemindersHeroSection(
          greeting: 'Good morning',
          dateLabel: DateFormat('EEEE, d MMMM yyyy').format(now),
          userName: profile?.name ?? '',
          theme: theme,
          navItems: navItems,
          navSelectedIndex: selectedIndex,
          onSearchTap: () => context.pushNamed(RouteNames.search),
          onNotificationsTap: () => context.pushNamed(RouteNames.notifications),
          onAvatarTap: () => context.pushNamed(RouteNames.profile),
          onControlsRegionMeasured: reportControlsRegion,
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            FloatingPageLayout.navClearance,
          ),
          child: _WorkspaceBodySwitcher(
            selectedIndex: selectedIndex,
            children: [
              _KeepAlive(child: remindersBody),
              const _KeepAlive(child: PlannerScreen()),
              _KeepAlive(child: habitsBody),
              _KeepAlive(child: calendarBody),
            ],
          ),
        ),
      ),
    );
  }
}

/// Crossfades between workspace bodies without ever disposing or re-keying
/// [children] — deliberately NOT `MorphSwitcher` (`PageTransitionSwitcher`),
/// since that widget swaps its child by identity/key and would tear down
/// and rebuild the whole group (including every [_KeepAlive] descendant) on
/// every tab switch, defeating the whole point of keeping inactive tabs
/// alive. Instead, [children] are built once and never rebuilt with a new
/// key; only [selectedIndex] and a locally-owned fade [Animation] change.
///
/// Deliberately NOT [IndexedStack] either: [IndexedStack] only paints/hit-
/// tests the active child, but — like [Stack] — still sizes itself to the
/// union of every non-positioned child (`RenderIndexedStack` overrides
/// painting and hit-testing but inherits `RenderStack`'s layout/sizing),
/// so with 4 kept-alive bodies mounted at once it reported a height equal
/// to the TALLEST of the four instead of just the active one — inflating
/// [HeroScaffold]'s `CustomScrollView.maxScrollExtent` and scrolling past
/// content that was actually already fully visible. A [Column] of
/// [Visibility] children (`maintainState: true`, no `maintainSize`) sizes
/// itself from only the visible child, since an invisible one without
/// `maintainSize` collapses to zero height while its subtree (and
/// [_KeepAlive] descendant) stays mounted.
class _WorkspaceBodySwitcher extends StatefulWidget {
  const _WorkspaceBodySwitcher({
    required this.selectedIndex,
    required this.children,
  });

  final int selectedIndex;
  final List<Widget> children;

  @override
  State<_WorkspaceBodySwitcher> createState() => _WorkspaceBodySwitcherState();
}

class _WorkspaceBodySwitcherState extends State<_WorkspaceBodySwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.medium,
    value: 1,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: AppCurves.easeOutCubic,
  );

  @override
  void didUpdateWidget(_WorkspaceBodySwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controller
        ..stop()
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < widget.children.length; i++)
            Visibility(
              visible: i == widget.selectedIndex,
              maintainState: true,
              child: widget.children[i],
            ),
        ],
      ),
    );
  }
}

/// Keeps [child] mounted (its `State` alive) even while it's the inactive
/// child of the enclosing [IndexedStack], so per-tab state (scroll offset,
/// filters, in-progress text entry, etc.) survives switching away and back
/// — the same mechanism [TabBarView]'s pages use internally.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
