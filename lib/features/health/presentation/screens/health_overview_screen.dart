import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/activity/presentation/providers/activity_dashboard_provider.dart';
import 'package:lifeos/features/health/presentation/providers/health_workspace_section_provider.dart';
import 'package:lifeos/features/health/presentation/widgets/health_workspace_scaffold.dart';
import 'package:lifeos/features/hydration/presentation/providers/hydration_dashboard_provider.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
import 'package:lifeos/features/mood/presentation/providers/mood_dashboard_provider.dart';
import 'package:lifeos/features/sleep/presentation/providers/sleep_dashboard_provider.dart';
import 'package:lifeos/features/weight/presentation/providers/weight_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';

String _formatSleepDuration(Duration d) => '${d.inHours}h ${d.inMinutes % 60}m';

/// A single row of [HealthOverviewScreen]'s scalable card list — one entry
/// per Health domain. Adding a future 7th module (e.g. a later phase's
/// Symptoms tracker) means appending one more `_OverviewCardData` to the
/// list this screen builds, not restructuring the layout.
class _OverviewCardData {
  const _OverviewCardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final VoidCallback onTap;
}

/// Health's "at a glance" landing tab — the default section, summarizing
/// all six Health domains (Medication, Mood, Hydration, Sleep, Weight,
/// Activity) from their real dashboard providers. Every value is
/// database-backed; an honest empty state is shown when a domain has no
/// data yet, never a fabricated placeholder. Tapping Mood/Medication
/// switches the workspace's own nav tab; tapping any of the four newer
/// domains pushes that feature's dedicated screen.
class HealthOverviewScreen extends ConsumerWidget {
  const HealthOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationsDashboardProvider);
    final moodAsync = ref.watch(moodDashboardProvider);
    final hydrationAsync = ref.watch(hydrationDashboardProvider);
    final sleepAsync = ref.watch(sleepDashboardProvider);
    final weightAsync = ref.watch(weightDashboardProvider);
    final activityAsync = ref.watch(activityDashboardProvider);

    void selectSection(HealthWorkspaceSection section) {
      ref.read(healthWorkspaceSectionProvider.notifier).select(section);
    }

    final cards = <_OverviewCardData>[
      medicationsAsync.when(
        data: (summary) {
          // Compares against the enum's `.name` rather than importing
          // `MedicationOccurrenceStatus` directly — this screen lives in
          // the Health aggregator, which may only see Medication's
          // dashboard-summary DTOs, not its domain entities (Golden Rule,
          // enforced by `test/contracts/import_boundary_test.dart`).
          final takenCount = summary.todayOccurrences
              .where((o) => o.status.name == 'taken')
              .length;
          return _OverviewCardData(
            icon: Icons.medication_outlined,
            label: 'Medication',
            value: summary.todayOccurrences.isEmpty
                ? '—'
                : '$takenCount of ${summary.todayOccurrences.length} taken',
            subtitle: summary.todayOccurrences.isEmpty
                ? 'No doses scheduled today'
                : '${summary.activeMedicationCount} active medications',
            onTap: () => selectSection(HealthWorkspaceSection.medications),
          );
        },
        loading: () => _OverviewCardData(
          icon: Icons.medication_outlined,
          label: 'Medication',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => selectSection(HealthWorkspaceSection.medications),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.medication_outlined,
          label: 'Medication',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => selectSection(HealthWorkspaceSection.medications),
        ),
      ),
      moodAsync.when(
        data: (summary) => _OverviewCardData(
          icon: Icons.mood_rounded,
          label: 'Mood',
          value: summary.todayLevelLabel ?? '—',
          subtitle: summary.todayLevelLabel == null
              ? 'Log how you feel'
              : 'Today',
          onTap: () => selectSection(HealthWorkspaceSection.mood),
        ),
        loading: () => _OverviewCardData(
          icon: Icons.mood_rounded,
          label: 'Mood',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => selectSection(HealthWorkspaceSection.mood),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.mood_rounded,
          label: 'Mood',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => selectSection(HealthWorkspaceSection.mood),
        ),
      ),
      hydrationAsync.when(
        data: (summary) => _OverviewCardData(
          icon: Icons.water_drop_rounded,
          label: 'Hydration',
          value: summary.todayTotalMl == 0
              ? '—'
              : '${(summary.todayTotalMl / 1000).toStringAsFixed(1)} / '
                    '${(summary.goalMl / 1000).toStringAsFixed(1)} L',
          subtitle: summary.todayTotalMl == 0
              ? 'No water logged today'
              : 'Today',
          onTap: () => context.pushNamed(RouteNames.hydration),
        ),
        loading: () => _OverviewCardData(
          icon: Icons.water_drop_rounded,
          label: 'Hydration',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => context.pushNamed(RouteNames.hydration),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.water_drop_rounded,
          label: 'Hydration',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => context.pushNamed(RouteNames.hydration),
        ),
      ),
      sleepAsync.when(
        data: (summary) => _OverviewCardData(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          value: summary.latestDuration == null
              ? '—'
              : _formatSleepDuration(summary.latestDuration!),
          subtitle: summary.latestQualityLabel ?? 'No sleep logged',
          onTap: () => context.pushNamed(RouteNames.sleep),
        ),
        loading: () => _OverviewCardData(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => context.pushNamed(RouteNames.sleep),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => context.pushNamed(RouteNames.sleep),
        ),
      ),
      weightAsync.when(
        data: (summary) => _OverviewCardData(
          icon: Icons.monitor_weight_outlined,
          label: 'Weight',
          value: summary.latestWeightKg == null
              ? '—'
              : '${summary.latestWeightKg!.toStringAsFixed(1)} kg',
          subtitle: summary.latestWeightKg == null
              ? 'No weight recorded yet'
              : 'Latest',
          onTap: () => context.pushNamed(RouteNames.weight),
        ),
        loading: () => _OverviewCardData(
          icon: Icons.monitor_weight_outlined,
          label: 'Weight',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => context.pushNamed(RouteNames.weight),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.monitor_weight_outlined,
          label: 'Weight',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => context.pushNamed(RouteNames.weight),
        ),
      ),
      activityAsync.when(
        data: (summary) => _OverviewCardData(
          icon: Icons.directions_walk_rounded,
          label: 'Activity',
          value: summary.todaySteps == 0 ? '—' : '${summary.todaySteps} steps',
          subtitle: summary.todaySteps == 0
              ? 'No activity recorded today'
              : '${((summary.todaySteps / summary.goalSteps) * 100).round()}% of goal',
          onTap: () => context.pushNamed(RouteNames.activity),
        ),
        loading: () => _OverviewCardData(
          icon: Icons.directions_walk_rounded,
          label: 'Activity',
          value: '—',
          subtitle: 'Loading…',
          onTap: () => context.pushNamed(RouteNames.activity),
        ),
        error: (_, _) => _OverviewCardData(
          icon: Icons.directions_walk_rounded,
          label: 'Activity',
          value: '—',
          subtitle: "Couldn't load",
          onTap: () => context.pushNamed(RouteNames.activity),
        ),
      ),
    ];

    return SingleChildScrollView(
      child: StaggeredEntrance(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text("Today's Health", style: context.textTheme.labelLarge),
          ),
          for (final card in cards)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _HealthOverviewCard(data: card),
            ),
        ],
      ),
    );
  }
}

class _HealthOverviewCard extends StatelessWidget {
  const _HealthOverviewCard({required this.data});

  final _OverviewCardData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: data.label,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: SectionCard(
          child: Row(
            children: [
              Icon(data.icon, color: context.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.label,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      data.value,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                data.subtitle,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
