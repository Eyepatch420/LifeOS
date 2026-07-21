import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/health/presentation/providers/health_workspace_section_provider.dart';
import 'package:lifeos/features/health/presentation/widgets/health_hero_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/shared/widgets/layouts/floating_page_layout.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// Which workspace-nav item is currently active — drives both the pill
/// highlight in [RemindersWorkspaceNav] (reused as-is; it's feature-agnostic
/// despite the name) and which of the two workspace bodies
/// [HealthWorkspaceScaffold] shows.
enum HealthWorkspaceSection { mood, medications }

/// Shared shell AND sole owner of the two tabs that belong to the green
/// Health workspace (Mood, Medications) — mirrors
/// `PlanningWorkspaceScaffold` exactly (same hero/scaffold composition, same
/// kept-alive tab-switching mechanism), scoped down to two tabs instead of
/// four. See that class's doc comment for the full rationale behind the
/// `_WorkspaceBodySwitcher`/`_KeepAlive` mechanics duplicated below (private
/// to that file, so not directly reusable from here).
class HealthWorkspaceScaffold extends ConsumerWidget {
  const HealthWorkspaceScaffold({
    required this.moodBody,
    required this.medicationsBody,
    super.key,
  });

  /// `MoodDashboardScreen()`, supplied by the router.
  final Widget moodBody;

  /// `MedicationsDashboardScreen()`, supplied by the router.
  final Widget medicationsBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final theme = ref.watch(activeWorkspaceThemeProvider);
    final profile = ref.watch(userProfileNotifierProvider).value;
    final section = ref.watch(healthWorkspaceSectionProvider);
    final sectionNotifier = ref.read(healthWorkspaceSectionProvider.notifier);

    final navItems = [
      RemindersWorkspaceNavItem(
        label: 'Mood',
        icon: Icons.mood_rounded,
        onSelected: section == HealthWorkspaceSection.mood
            ? null
            : () => sectionNotifier.select(HealthWorkspaceSection.mood),
      ),
      RemindersWorkspaceNavItem(
        label: 'Medications',
        icon: Icons.medication_outlined,
        onSelected: section == HealthWorkspaceSection.medications
            ? null
            : () => sectionNotifier.select(HealthWorkspaceSection.medications),
      ),
    ];
    final selectedIndex = switch (section) {
      HealthWorkspaceSection.mood => 0,
      HealthWorkspaceSection.medications => 1,
    };

    return FloatingPageLayout(
      body: HeroScaffold(
        heroBuilder: (context, reportControlsRegion) => HealthHeroSection(
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
              _KeepAlive(child: moodBody),
              _KeepAlive(child: medicationsBody),
            ],
          ),
        ),
      ),
    );
  }
}

/// Crossfades between workspace bodies without ever disposing or re-keying
/// [children] — see `PlanningWorkspaceScaffold._WorkspaceBodySwitcher`'s doc
/// comment for the full rationale (deliberately not `MorphSwitcher`, not
/// `IndexedStack`).
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

/// Keeps [child] mounted even while it's the inactive tab — see
/// `PlanningWorkspaceScaffold._KeepAlive`'s doc comment.
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
