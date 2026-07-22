import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/hydration/domain/contracts/hydration_dashboard_summary.dart';
import 'package:lifeos/features/hydration/presentation/providers/hydration_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Quick-add amounts (ml) offered on the Hydration screen — centralized here
/// rather than hardcoded per-widget, per the "quick-add configuration should
/// stay centralized" requirement.
const List<int> kHydrationQuickAddAmountsMl = [250, 500];

/// The Hydration feature's own detail screen — history + inline log/edit,
/// pushed from Health Overview. No separate "new entry" screen: logging is
/// a single quick-add tap or a short custom-amount dialog, not a full form.
class HydrationScreen extends ConsumerWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(hydrationDashboardProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Hydration'),
      content: summaryAsync.when(
        data: (summary) => _HydrationContent(summary: summary),
        loading: () => const _HydrationLoading(),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your hydration history",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(hydrationDashboardProvider),
        ),
      ),
    );
  }
}

class _HydrationContent extends ConsumerWidget {
  const _HydrationContent({required this.summary});

  final HydrationDashboardSummary summary;

  Future<void> _quickAdd(BuildContext context, WidgetRef ref, int ml) async {
    await ref
        .read(hydrationRepositoryProvider)
        .log(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          amountMl: ml,
        );
  }

  Future<void> _customAdd(BuildContext context, WidgetRef ref) async {
    final amount = await showDialog<int>(
      context: context,
      builder: (context) => const _CustomAmountDialog(),
    );
    if (amount == null) return;
    await ref
        .read(hydrationRepositoryProvider)
        .log(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          amountMl: amount,
        );
  }

  Future<void> _editGoal(BuildContext context, WidgetRef ref) async {
    final goal = await showDialog<int>(
      context: context,
      builder: (context) => _GoalDialog(currentGoalMl: summary.goalMl),
    );
    if (goal == null) return;
    await ref.read(hydrationRepositoryProvider).setGoalMl(goal);
  }

  Future<void> _deleteEntry(WidgetRef ref, String id) async {
    await ref.read(hydrationRepositoryProvider).delete(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: StaggeredEntrance(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _TodayHydrationSection(
              summary: summary,
              onEditGoal: () => _editGoal(context, ref),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _QuickAddSection(
              onQuickAdd: (ml) => _quickAdd(context, ref, ml),
              onCustom: () => _customAdd(context, ref),
            ),
          ),
          if (summary.recentEntries.isEmpty)
            const EmptyState(
              icon: Icons.water_drop_outlined,
              message: 'No water logged today',
            )
          else
            _HistorySection(
              entries: summary.recentEntries,
              onDelete: (id) => _deleteEntry(ref, id),
            ),
        ],
      ),
    );
  }
}

class _TodayHydrationSection extends StatelessWidget {
  const _TodayHydrationSection({
    required this.summary,
    required this.onEditGoal,
  });

  final HydrationDashboardSummary summary;
  final VoidCallback onEditGoal;

  @override
  Widget build(BuildContext context) {
    final progress = summary.goalMl == 0
        ? 0.0
        : (summary.todayTotalMl / summary.goalMl).clamp(0.0, 1.0);
    final totalL = (summary.todayTotalMl / 1000).toStringAsFixed(1);
    final goalL = (summary.goalMl / 1000).toStringAsFixed(1);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$totalL / $goalL L',
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
            '${(progress * 100).round()}% of daily goal',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddSection extends StatelessWidget {
  const _QuickAddSection({required this.onQuickAdd, required this.onCustom});

  final void Function(int ml) onQuickAdd;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add water', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final ml in kHydrationQuickAddAmountsMl)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: Text('+$ml ml'),
                  onPressed: () => onQuickAdd(ml),
                ),
              ActionChip(
                avatar: const Icon(Icons.edit, size: 16),
                label: const Text('Custom'),
                onPressed: onCustom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.entries, required this.onDelete});

  final List<HydrationEntrySummary> entries;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s entries', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text('${entry.amountMl} ml')),
                  Text(
                    DateFormat('h:mm a').format(entry.recordedAt),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete entry',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => onDelete(entry.id),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomAmountDialog extends StatefulWidget {
  const _CustomAmountDialog();

  @override
  State<_CustomAmountDialog> createState() => _CustomAmountDialogState();
}

class _CustomAmountDialogState extends State<_CustomAmountDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = int.tryParse(_controller.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter an amount greater than 0');
      return;
    }
    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Custom amount'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Amount (ml)',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}

class _GoalDialog extends StatefulWidget {
  const _GoalDialog({required this.currentGoalMl});

  final int currentGoalMl;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _controller = TextEditingController(
    text: widget.currentGoalMl.toString(),
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
      title: const Text('Daily goal'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Goal (ml)', errorText: _error),
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

class _HydrationLoading extends StatelessWidget {
  const _HydrationLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 100),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 80),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 220),
      ],
    );
  }
}
