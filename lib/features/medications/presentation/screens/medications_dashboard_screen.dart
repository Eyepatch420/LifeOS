import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/medications/domain/contracts/medications_dashboard_summary.dart';
import 'package:lifeos/features/medications/domain/entities/medication_occurrence.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

/// The Medications tab of the Health workspace — derives entirely from
/// [medicationsDashboardProvider], no independent state, mirrors
/// `HabitsDashboardScreen`.
class MedicationsDashboardScreen extends ConsumerWidget {
  const MedicationsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(medicationsDashboardProvider);

    return summaryAsync.when(
      data: (summary) => _MedicationsDashboardContent(summary: summary),
      loading: () => const _MedicationsDashboardLoading(),
      error: (error, stack) => SizedBox(
        height: 400,
        child: EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your medications",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(medicationsDashboardProvider),
        ),
      ),
    );
  }
}

class _MedicationsDashboardContent extends ConsumerWidget {
  const _MedicationsDashboardContent({required this.summary});

  final MedicationsDashboardSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> record(MedicationOccurrenceSummary occ, bool taken) async {
      await ref
          .read(medicationsRepositoryProvider)
          .recordOccurrence(
            id: '${occ.medicationId}-${occ.scheduledFor.millisecondsSinceEpoch}',
            medicationId: occ.medicationId,
            scheduledFor: occ.scheduledFor,
            taken: taken,
          );
      ref.invalidate(medicationsDashboardProvider);
    }

    void openDetail(String medicationId) {
      context.pushNamed(
        RouteNames.medicationDetail,
        pathParameters: {'medicationId': medicationId},
      );
    }

    return StaggeredEntrance(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: _MedicationsOverviewSection(summary: summary),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: _AddMedicationSection(
            onTap: () => context.pushNamed(RouteNames.newMedication),
          ),
        ),
        if (summary.todayOccurrences.isEmpty)
          const EmptyState(
            icon: Icons.medication_outlined,
            message: 'No medications yet — add one to get reminders',
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _TodaySection(
              occurrences: summary.todayOccurrences,
              onTake: (occ) => record(occ, true),
              onSkip: (occ) => record(occ, false),
              onTap: (occ) => openDetail(occ.medicationId),
            ),
          ),
      ],
    );
  }
}

class _MedicationsOverviewSection extends StatelessWidget {
  const _MedicationsOverviewSection({required this.summary});

  final MedicationsDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final takenCount = summary.todayOccurrences
        .where((o) => o.status == MedicationOccurrenceStatus.taken)
        .length;
    return SectionCard(
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Active medications',
              value: '${summary.activeMedicationCount}',
            ),
          ),
          Expanded(
            child: _StatTile(
              label: 'Doses today',
              value: '${summary.todayOccurrences.length}',
            ),
          ),
          Expanded(
            child: _StatTile(label: 'Taken', value: '$takenCount'),
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

class _AddMedicationSection extends StatelessWidget {
  const _AddMedicationSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add medication',
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
              const Text('Add Medication'),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodaySection extends StatelessWidget {
  const _TodaySection({
    required this.occurrences,
    required this.onTake,
    required this.onSkip,
    required this.onTap,
  });

  final List<MedicationOccurrenceSummary> occurrences;
  final void Function(MedicationOccurrenceSummary) onTake;
  final void Function(MedicationOccurrenceSummary) onSkip;
  final void Function(MedicationOccurrenceSummary) onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final occ in occurrences)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: InkWell(
                onTap: () => onTap(occ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Row(
                  children: [
                    _StatusIcon(status: occ.status),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(occ.medicationName),
                          Text(
                            DateFormat('h:mm a').format(occ.scheduledFor),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (occ.status == MedicationOccurrenceStatus.scheduled ||
                        occ.status == MedicationOccurrenceStatus.missed) ...[
                      IconButton(
                        tooltip: 'Mark taken',
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () => onTake(occ),
                      ),
                      IconButton(
                        tooltip: 'Skip',
                        icon: const Icon(Icons.close),
                        onPressed: () => onSkip(occ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final MedicationOccurrenceStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      MedicationOccurrenceStatus.taken => const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      MedicationOccurrenceStatus.skipped => Icon(
        Icons.remove_circle,
        color: context.colorScheme.onSurfaceVariant,
      ),
      MedicationOccurrenceStatus.missed => Icon(
        Icons.error_outline,
        color: context.colorScheme.error,
      ),
      MedicationOccurrenceStatus.scheduled => Icon(
        Icons.schedule,
        color: context.colorScheme.onSurfaceVariant,
      ),
    };
  }
}

class _MedicationsDashboardLoading extends StatelessWidget {
  const _MedicationsDashboardLoading();

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
