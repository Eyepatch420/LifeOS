import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_data_provider.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_hero_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/shared/widgets/layouts/floating_page_layout.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// Which workspace-nav item is currently active — drives both the pill
/// highlight in [RemindersWorkspaceNav] and which item is navigation-target
/// vs. currently-selected (see [RemindersWorkspaceNavItem.onSelected]'s doc
/// comment: an item with no `onSelected` renders as a non-navigating
/// placeholder).
enum PlanningWorkspaceSection { reminders, planner, habits, calendar }

/// Shared shell for every screen that belongs to the orange
/// Reminders/Planner planning workspace: hero (sunset SVG, greeting,
/// search/notifications/profile, workspace nav) + [FloatingPageLayout]/
/// [HeroScaffold] composition, with only [content] and [activeSection]
/// varying per screen.
///
/// Extracted from what was `RemindersDashboardScreen`'s own build method in
/// Phase 3/4 so `PlannerScreen` (Phase 5) can reuse the identical shell
/// instead of duplicating the hero/nav/scaffold wiring — see Phase 5 plan's
/// requirement that Reminders remain visually and behaviorally unchanged.
/// `RemindersDashboardScreen` now itself calls this with
/// `activeSection: PlanningWorkspaceSection.reminders`.
///
/// Does NOT modify [HeroScaffold] itself — that stays a fully generic,
/// feature-agnostic scroll/hero primitive; all planning-workspace-specific
/// knowledge (which hero, which nav items, workspace theme) lives here,
/// one level below it.
class PlanningWorkspaceScaffold extends ConsumerWidget {
  const PlanningWorkspaceScaffold({
    required this.activeSection,
    required this.content,
    super.key,
  });

  final PlanningWorkspaceSection activeSection;
  final Widget content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(remindersClockTickProvider).value ?? DateTime.now();
    final theme = ref.watch(activeWorkspaceThemeProvider);
    final profile = ref.watch(userProfileNotifierProvider).value;

    final navItems = [
      RemindersWorkspaceNavItem(
        label: 'Reminders',
        icon: Icons.notifications_outlined,
        onSelected: activeSection == PlanningWorkspaceSection.reminders
            ? null
            : () => context.goNamed(RouteNames.reminders),
      ),
      RemindersWorkspaceNavItem(
        label: 'Planner',
        icon: Icons.calendar_month_outlined,
        onSelected: activeSection == PlanningWorkspaceSection.planner
            ? null
            : () => context.pushNamed(RouteNames.planner),
      ),
      RemindersWorkspaceNavItem(
        label: 'Habits',
        icon: Icons.track_changes_outlined,
        onSelected: activeSection == PlanningWorkspaceSection.habits
            ? null
            : () => context.pushNamed(RouteNames.habits),
      ),
      RemindersWorkspaceNavItem(
        label: 'Calendar',
        icon: Icons.calendar_today_outlined,
        onSelected: activeSection == PlanningWorkspaceSection.calendar
            ? null
            : () => context.pushNamed(RouteNames.calendar),
      ),
    ];
    final selectedIndex = switch (activeSection) {
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
          child: content,
        ),
      ),
    );
  }
}
