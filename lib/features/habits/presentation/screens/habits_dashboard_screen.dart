import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/features/habits/presentation/widgets/habits_today_section.dart';
import 'package:lifeos/features/habits/presentation/widgets/habits_streaks_section.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

/// The Habits tab of the planning workspace — a real, Drift-backed Habits
/// dashboard, hosted as one of the four bodies switched by
/// `PlanningWorkspaceScaffold` (`planning_workspace_scaffold.dart`),
/// replacing the Module-3 mock `NewHabitScreen`/`habit_providers.dart`
/// triad's disconnected scope.
///
/// The sheet derives entirely from [habitsDashboardProvider], which itself
/// derives from `HabitsRepository.watchAll()` + each habit's completion
/// history — no section here holds independent state or a second data
/// source.
class HabitsDashboardScreen extends ConsumerWidget {
  const HabitsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(habitsDashboardProvider);

    return summaryAsync.when(
      data: (summary) => _HabitsDashboardContent(summary: summary),
      loading: () => const _HabitsDashboardLoading(),
      error: (error, stack) => _HabitsDashboardError(
        onRetry: () => ref.invalidate(habitsDashboardProvider),
      ),
    );
  }
}

class _HabitsDashboardContent extends StatelessWidget {
  const _HabitsDashboardContent({required this.summary});

  final HabitsSummary summary;

  @override
  Widget build(BuildContext context) {
    void openDetail(String habitId) {
      context.pushNamed(
        RouteNames.habitDetail,
        pathParameters: {'habitId': habitId},
      );
    }

    final sections = <Widget>[
      _HabitsOverviewSection(summary: summary),
      _HabitsQuickAddSection(
        onTap: () => context.pushNamed(RouteNames.newHabit),
      ),
      if (summary.streaks.isEmpty)
        const EmptyState(
          icon: Icons.track_changes_outlined,
          message: 'No habits yet — add one to start a streak',
        )
      else ...[
        HabitsTodaySection(streaks: summary.streaks, onTap: openDetail),
        HabitsStreaksSection(streaks: summary.streaks, onTap: openDetail),
      ],
    ];

    return StaggeredEntrance(
      children: [
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: section,
          ),
      ],
    );
  }
}

class _HabitsOverviewSection extends StatelessWidget {
  const _HabitsOverviewSection({required this.summary});

  final HabitsSummary summary;

  @override
  Widget build(BuildContext context) {
    final remaining = summary.scheduledTodayCount - summary.completedTodayCount;
    return SectionCard(
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Scheduled today',
              value: '${summary.scheduledTodayCount}',
            ),
          ),
          Expanded(
            child: _StatTile(
              label: 'Completed',
              value: '${summary.completedTodayCount}',
            ),
          ),
          Expanded(
            child: _StatTile(label: 'Remaining', value: '$remaining'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HabitsQuickAddSection extends StatelessWidget {
  const _HabitsQuickAddSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add habit',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: SectionCard(
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              const Text('Add Habit'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitsDashboardLoading extends StatelessWidget {
  const _HabitsDashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 80),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 220),
      ],
    );
  }
}

class _HabitsDashboardError extends StatelessWidget {
  const _HabitsDashboardError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: EmptyState(
        icon: Icons.error_outline,
        message: "Couldn't load your habits",
        ctaLabel: 'Retry',
        onCtaTap: onRetry,
      ),
    );
  }
}
