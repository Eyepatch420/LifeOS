import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/mood/domain/contracts/mood_dashboard_summary.dart';
import 'package:lifeos/features/mood/presentation/providers/mood_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

/// The Mood tab of the Health workspace — derives entirely from
/// [moodDashboardProvider], no independent state, mirrors
/// `HabitsDashboardScreen`.
class MoodDashboardScreen extends ConsumerWidget {
  const MoodDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(moodDashboardProvider);

    return summaryAsync.when(
      data: (summary) => _MoodDashboardContent(summary: summary),
      loading: () => const _MoodDashboardLoading(),
      error: (error, stack) => SizedBox(
        height: 400,
        child: EmptyState(
          icon: Icons.error_outline,
          message: "Couldn't load your mood history",
          ctaLabel: 'Retry',
          onCtaTap: () => ref.invalidate(moodDashboardProvider),
        ),
      ),
    );
  }
}

class _MoodDashboardContent extends StatelessWidget {
  const _MoodDashboardContent({required this.summary});

  final MoodDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return StaggeredEntrance(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: _TodayMoodSection(levelLabel: summary.todayLevelLabel),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: _LogMoodSection(
            onTap: () => context.pushNamed(RouteNames.logMood),
          ),
        ),
        if (summary.recentEntries.isEmpty)
          const EmptyState(
            icon: Icons.mood_rounded,
            message: 'No mood entries yet — log how you feel',
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: _RecentEntriesSection(entries: summary.recentEntries),
          ),
      ],
    );
  }
}

class _TodayMoodSection extends StatelessWidget {
  const _TodayMoodSection({required this.levelLabel});

  final String? levelLabel;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Text(
            levelLabel == null ? '—' : '🙂',
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelLabel ?? 'Log how you feel',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Today\'s mood',
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

class _LogMoodSection extends StatelessWidget {
  const _LogMoodSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Log mood',
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
              const Text('Log Mood'),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentEntriesSection extends StatelessWidget {
  const _RecentEntriesSection({required this.entries});

  final List<MoodEntrySummary> entries;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Entries', style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Text(entry.levelEmoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.levelLabel),
                        if (entry.note != null)
                          Text(
                            entry.note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, h:mm a').format(entry.recordedAt),
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

class _MoodDashboardLoading extends StatelessWidget {
  const _MoodDashboardLoading();

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
