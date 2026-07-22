import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/sleep/domain/contracts/sleep_dashboard_summary.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_quality.dart';
import 'package:lifeos/features/sleep/presentation/providers/sleep_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

String _formatDuration(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes % 60;
  return '${hours}h ${minutes}m';
}

/// The Sleep feature's own detail screen — history + inline log/edit,
/// pushed from Health Overview.
class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(sleepDashboardProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Sleep'),
      content: summaryAsync.when(
        data: (summary) => _SleepContent(summary: summary),
        loading: () => const _SleepLoading(),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your sleep history",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(sleepDashboardProvider),
        ),
      ),
    );
  }
}

class _SleepContent extends ConsumerWidget {
  const _SleepContent({required this.summary});

  final SleepDashboardSummary summary;

  Future<void> _logSleep(BuildContext context, WidgetRef ref) async {
    final clock = ref.read(clockManagerProvider);
    await showDialog<void>(
      context: context,
      builder: (context) => _LogSleepDialog(initialReference: clock.now()),
    );
  }

  Future<void> _deleteEntry(WidgetRef ref, String id) async {
    await ref.read(sleepRepositoryProvider).delete(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: StaggeredEntrance(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _LatestSleepSection(summary: summary),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _LogSleepSection(onTap: () => _logSleep(context, ref)),
          ),
          if (summary.recentEntries.isEmpty)
            const EmptyState(
              icon: Icons.bedtime_outlined,
              message: 'No sleep logged yet',
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

class _LatestSleepSection extends StatelessWidget {
  const _LatestSleepSection({required this.summary});

  final SleepDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Icon(Icons.bedtime, color: context.colorScheme.primary, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.latestDuration == null
                      ? '—'
                      : _formatDuration(summary.latestDuration!),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  summary.latestQualityLabel ?? 'No sleep logged',
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

class _LogSleepSection extends StatelessWidget {
  const _LogSleepSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Log sleep',
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
              const Text('Log Sleep'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.entries, required this.onDelete});

  final List<SleepEntrySummary> entries;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_formatDuration(entry.duration)),
                        Text(
                          '${DateFormat('h:mm a').format(entry.bedtime)} → '
                          '${DateFormat('h:mm a').format(entry.wakeTime)}'
                          '${entry.qualityLabel != null ? ' · ${entry.qualityLabel}' : ''}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

class _LogSleepDialog extends ConsumerStatefulWidget {
  const _LogSleepDialog({required this.initialReference});

  final DateTime initialReference;

  @override
  ConsumerState<_LogSleepDialog> createState() => _LogSleepDialogState();
}

class _LogSleepDialogState extends ConsumerState<_LogSleepDialog> {
  late TimeOfDay _bedtime = const TimeOfDay(hour: 23, minute: 0);
  late TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  SleepQuality? _quality;
  String? _error;
  bool _isSaving = false;

  Future<void> _pickBedtime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedtime,
    );
    if (picked != null) setState(() => _bedtime = picked);
  }

  Future<void> _pickWakeTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null) setState(() => _wakeTime = picked);
  }

  Future<void> _save() async {
    final reference = widget.initialReference;
    // Bedtime is anchored to the reference day; wake time rolls onto the
    // next calendar day whenever its clock time is not strictly after
    // bedtime's — this is what makes an overnight 11pm→7am log produce a
    // positive 8h duration instead of a negative one.
    final bedtimeDate = DateTime(
      reference.year,
      reference.month,
      reference.day,
      _bedtime.hour,
      _bedtime.minute,
    );
    var wakeDate = DateTime(
      reference.year,
      reference.month,
      reference.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );
    if (!wakeDate.isAfter(bedtimeDate)) {
      wakeDate = wakeDate.add(const Duration(days: 1));
    }

    setState(() => _isSaving = true);
    await ref
        .read(sleepRepositoryProvider)
        .log(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          bedtime: bedtimeDate,
          wakeTime: wakeDate,
          quality: _quality,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Sleep'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bedtime'),
            trailing: Text(_bedtime.format(context)),
            onTap: _pickBedtime,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Wake'),
            trailing: Text(_wakeTime.format(context)),
            onTap: _pickWakeTime,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final quality in SleepQuality.values)
                ChoiceChip(
                  label: Text(quality.label),
                  selected: _quality == quality,
                  onSelected: (_) => setState(() => _quality = quality),
                ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _SleepLoading extends StatelessWidget {
  const _SleepLoading();

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
