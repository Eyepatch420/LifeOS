import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/weight/domain/contracts/weight_dashboard_summary.dart';
import 'package:lifeos/features/weight/presentation/providers/weight_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// The Weight feature's own detail screen — history + inline log/edit,
/// pushed from Health Overview. The change-from-previous indicator is
/// deliberately neutral (no red/green good/bad coloring) — a weight change
/// is tracking data, not a medical judgment.
class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(weightDashboardProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Weight'),
      content: summaryAsync.when(
        data: (summary) => _WeightContent(summary: summary),
        loading: () => const _WeightLoading(),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your weight history",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(weightDashboardProvider),
        ),
      ),
    );
  }
}

class _WeightContent extends ConsumerWidget {
  const _WeightContent({required this.summary});

  final WeightDashboardSummary summary;

  Future<void> _logWeight(BuildContext context, WidgetRef ref) async {
    final weight = await showDialog<double>(
      context: context,
      builder: (context) => const _WeightEntryDialog(),
    );
    if (weight == null) return;
    await ref
        .read(weightRepositoryProvider)
        .log(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          weightKg: weight,
        );
  }

  Future<void> _deleteEntry(WidgetRef ref, String id) async {
    await ref.read(weightRepositoryProvider).delete(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: StaggeredEntrance(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _LatestWeightSection(summary: summary),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _LogWeightSection(onTap: () => _logWeight(context, ref)),
          ),
          if (summary.recentEntries.isEmpty)
            const EmptyState(
              icon: Icons.monitor_weight_outlined,
              message: 'No weight recorded yet',
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

class _LatestWeightSection extends StatelessWidget {
  const _LatestWeightSection({required this.summary});

  final WeightDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final change = summary.changeFromPreviousKg;
    return SectionCard(
      child: Row(
        children: [
          Icon(
            Icons.monitor_weight_outlined,
            color: context.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.latestWeightKg == null
                      ? '—'
                      : '${summary.latestWeightKg!.toStringAsFixed(1)} kg',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (change != null)
                  Text(
                    '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)} kg',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Text(
                    'No weight recorded',
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

class _LogWeightSection extends StatelessWidget {
  const _LogWeightSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Log weight',
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
              const Text('Log Weight'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.entries, required this.onDelete});

  final List<WeightEntrySummary> entries;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('History', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${entry.weightKg.toStringAsFixed(1)} kg'),
                  ),
                  Text(
                    DateFormat('MMM d, h:mm a').format(entry.recordedAt),
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

class _WeightEntryDialog extends StatefulWidget {
  const _WeightEntryDialog();

  @override
  State<_WeightEntryDialog> createState() => _WeightEntryDialogState();
}

class _WeightEntryDialogState extends State<_WeightEntryDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final weight = double.tryParse(_controller.text.trim());
    if (weight == null || weight <= 0) {
      setState(() => _error = 'Enter a weight greater than 0');
      return;
    }
    Navigator.of(context).pop(weight);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Weight'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Weight (kg)',
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

class _WeightLoading extends StatelessWidget {
  const _WeightLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 80),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 80),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 220),
      ],
    );
  }
}
