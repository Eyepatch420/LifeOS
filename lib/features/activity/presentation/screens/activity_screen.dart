import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/activity/domain/contracts/activity_dashboard_summary.dart';
import 'package:lifeos/features/activity/presentation/providers/activity_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// The Activity feature's own detail screen — today's steps + progress,
/// recent-days history, pushed from Health Overview. No per-entry history
/// list: Activity is a daily aggregate (see `DailyActivity`'s table doc
/// comment), so "history" is one row per day, not per action.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(activityDashboardProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Activity'),
      content: summaryAsync.when(
        data: (summary) => _ActivityContent(summary: summary),
        loading: () => const _ActivityLoading(),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your activity",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(activityDashboardProvider),
        ),
      ),
    );
  }
}

class _ActivityContent extends ConsumerWidget {
  const _ActivityContent({required this.summary});

  final ActivityDashboardSummary summary;

  Future<void> _updateSteps(BuildContext context, WidgetRef ref) async {
    final steps = await showDialog<int>(
      context: context,
      builder: (context) => _StepsDialog(currentSteps: summary.todaySteps),
    );
    if (steps == null) return;
    await ref.read(activityRepositoryProvider).setTodaySteps(steps: steps);
  }

  Future<void> _editGoal(BuildContext context, WidgetRef ref) async {
    final goal = await showDialog<int>(
      context: context,
      builder: (context) => _GoalDialog(currentGoalSteps: summary.goalSteps),
    );
    if (goal == null) return;
    await ref.read(activityRepositoryProvider).setGoalSteps(goal);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: StaggeredEntrance(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _TodayStepsSection(
              summary: summary,
              onUpdateSteps: () => _updateSteps(context, ref),
              onEditGoal: () => _editGoal(context, ref),
            ),
          ),
          if (summary.recentDays.isEmpty)
            const EmptyState(
              icon: Icons.directions_walk,
              message: 'No activity recorded today',
            )
          else
            _RecentDaysSection(days: summary.recentDays),
        ],
      ),
    );
  }
}

class _TodayStepsSection extends StatelessWidget {
  const _TodayStepsSection({
    required this.summary,
    required this.onUpdateSteps,
    required this.onEditGoal,
  });

  final ActivityDashboardSummary summary;
  final VoidCallback onUpdateSteps;
  final VoidCallback onEditGoal;

  @override
  Widget build(BuildContext context) {
    final progress = summary.goalSteps == 0
        ? 0.0
        : (summary.todaySteps / summary.goalSteps).clamp(0.0, 1.0);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${summary.todaySteps} / ${summary.goalSteps} steps',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit daily goal',
                icon: const Icon(Icons.tune),
                onPressed: onEditGoal,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${(progress * 100).round()}% of goal',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onUpdateSteps,
            icon: const Icon(Icons.edit),
            label: const Text('Update steps'),
          ),
        ],
      ),
    );
  }
}

class _RecentDaysSection extends StatelessWidget {
  const _RecentDaysSection({required this.days});

  final List<DailyActivitySummary> days;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent days', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final day in days)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(child: Text(day.dayKey)),
                  Text(
                    '${day.steps} / ${day.goalSteps}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StepsDialog extends StatefulWidget {
  const _StepsDialog({required this.currentSteps});

  final int currentSteps;

  @override
  State<_StepsDialog> createState() => _StepsDialogState();
}

class _StepsDialogState extends State<_StepsDialog> {
  late final _controller = TextEditingController(
    text: widget.currentSteps == 0 ? '' : widget.currentSteps.toString(),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final steps = int.tryParse(_controller.text.trim());
    if (steps == null || steps < 0) {
      setState(() => _error = 'Enter a step count of 0 or more');
      return;
    }
    Navigator.of(context).pop(steps);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update steps'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Steps today',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

class _GoalDialog extends StatefulWidget {
  const _GoalDialog({required this.currentGoalSteps});

  final int currentGoalSteps;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _controller = TextEditingController(
    text: widget.currentGoalSteps.toString(),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final goal = int.tryParse(_controller.text.trim());
    if (goal == null || goal <= 0) {
      setState(() => _error = 'Enter a goal greater than 0');
      return;
    }
    Navigator.of(context).pop(goal);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Daily step goal'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Goal (steps)',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

class _ActivityLoading extends StatelessWidget {
  const _ActivityLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 140),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 180),
      ],
    );
  }
}
