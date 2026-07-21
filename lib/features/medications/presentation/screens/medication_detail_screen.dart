import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/medications/domain/entities/medication.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

final _medicationByIdProvider = StreamProvider.autoDispose
    .family<Medication?, String>((ref, id) {
      return ref
          .watch(medicationsRepositoryProvider)
          .watchAll()
          .map((meds) => meds.where((m) => m.id == id).firstOrNull);
    });

/// A medication's detail screen — reached from the dashboard's "Today"
/// list, global search, and a tapped dose-reminder notification
/// (`medication:<id>` deep-link, see `app.dart`'s `_handleTap`). Read-only
/// view of the schedule plus archive/delete actions; editing a medication's
/// schedule is not in this phase's minimum UI surface (the repository API
/// already supports it via `update()` for a later pass).
class MedicationDetailScreen extends ConsumerWidget {
  const MedicationDetailScreen({required this.medicationId, super.key});

  final String medicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationAsync = ref.watch(_medicationByIdProvider(medicationId));

    return medicationAsync.when(
      data: (medication) => medication == null
          ? _NotFound(onBack: () => context.pop())
          : _MedicationDetailContent(medication: medication),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _NotFound(onBack: () => context.pop()),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Medication'),
      content: EmptyState(
        icon: Icons.medication_outlined,
        message: "This medication couldn't be found",
        ctaLabel: 'Back',
        onCtaTap: onBack,
      ),
    );
  }
}

class _MedicationDetailContent extends ConsumerStatefulWidget {
  const _MedicationDetailContent({required this.medication});

  final Medication medication;

  @override
  ConsumerState<_MedicationDetailContent> createState() =>
      _MedicationDetailContentState();
}

class _MedicationDetailContentState
    extends ConsumerState<_MedicationDetailContent> {
  bool _isWorking = false;

  Future<void> _archive() async {
    setState(() => _isWorking = true);
    await ref.read(medicationsRepositoryProvider).archive(widget.medication.id);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete medication?'),
        content: const Text(
          'This permanently removes the medication and its dose history.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isWorking = true);
    await ref.read(medicationsRepositoryProvider).delete(widget.medication.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;
    final schedule = medication.schedule;

    return PushedScreenLayout(
      header: PushedScreenHeader(title: medication.name),
      content: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (medication.dosageText != null) ...[
              Text('Dosage', style: context.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(medication.dosageText!),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (medication.instructions != null) ...[
              Text('Instructions', style: context.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(medication.instructions!),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text('Schedule', style: context.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              schedule.isDaily
                  ? 'Daily at ${schedule.times.map((t) => t.storageKey).join(', ')}'
                  : 'Selected days at ${schedule.times.map((t) => t.storageKey).join(', ')}',
            ),
            const SizedBox(height: AppSpacing.xxl),
            OutlinedButton(
              onPressed: _isWorking ? null : _archive,
              child: const Text('Archive'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _isWorking ? null : _delete,
              child: Text(
                'Delete',
                style: TextStyle(color: context.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
