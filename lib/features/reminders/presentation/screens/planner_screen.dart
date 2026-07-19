import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/planner_contributor_registrations.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/reminders/domain/planner/planner_day_data.dart';
import 'package:lifeos/features/reminders/presentation/providers/planner_day_data_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/planner_selected_date_provider.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planner/planner_completion_feedback.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planner/planner_day_summary.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planner/planner_timeline_item.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';
import 'package:lifeos/shared/widgets/planning/planner_date_strip.dart';
import 'package:lifeos/shared/widgets/planning/planner_header.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// `/reminders/planner` — a focused single-day planner view over the same
/// Reminder data Reminders itself owns (see `PlannerItem`'s doc comment on
/// why this is a projection, not a second data source). Hosted by the same
/// [PlanningWorkspaceScaffold] as `RemindersDashboardScreen`, so the hero,
/// workspace nav, sunset SVG, and hit-testing contract are shared, not
/// duplicated.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayAsync = ref.watch(plannerDayDataProvider);
    final selectedDate = ref.watch(plannerSelectedDateProvider);
    final theme = ref.watch(activeWorkspaceThemeProvider);
    final dateNotifier = ref.read(plannerSelectedDateProvider.notifier);

    return PlanningWorkspaceScaffold(
      activeSection: PlanningWorkspaceSection.planner,
      content: StaggeredEntrance(
        children: [
          PlannerHeader(
            selectedDate: selectedDate,
            onPreviousDay: dateNotifier.previousDay,
            onNextDay: dateNotifier.nextDay,
            onToday: dateNotifier.resetToToday,
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: PlannerDateStrip(
              selectedDate: selectedDate,
              onDateSelected: dateNotifier.selectDate,
              theme: theme,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: dayAsync.when(
              data: (data) =>
                  _PlannerDayContent(data: data, selectedDate: selectedDate),
              loading: () => const _PlannerLoading(),
              error: (error, stack) => _PlannerError(
                onRetry: () => ref.invalidate(plannerDayDataProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannerDayContent extends ConsumerWidget {
  const _PlannerDayContent({required this.data, required this.selectedDate});

  final PlannerDayData data;
  final DateTime selectedDate;

  void _openDetail(BuildContext context, PlannerItem item) {
    context.pushNamed(item.routeName, pathParameters: item.pathParameters);
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    PlannerItem item,
  ) {
    // `PlannerTimelineItem` never renders a complete action for an item
    // with `canComplete: false` (Calendar events), but guard here too so
    // this handler stays safe if ever reached another way.
    if (!item.canComplete) return Future.value();
    return completePlannerItemWithFeedback(
      context,
      item: item,
      contributors: ref.read(plannerContributorsProvider),
      remindersRepository: ref.read(remindersRepositoryProvider),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return EmptyState(
        icon: Icons.event_available_outlined,
        message: 'Nothing planned for this day',
        ctaLabel: 'Add Reminder',
        onCtaTap: () =>
            context.pushNamed(RouteNames.newReminder, extra: selectedDate),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlannerDaySummary(data: data),
        const SizedBox(height: AppSpacing.lg),
        if (data.overdueCarryover.isNotEmpty) ...[
          Text(
            'Needs Attention',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < data.overdueCarryover.length; i++)
            PlannerTimelineItem(
              item: data.overdueCarryover[i],
              showConnector: i != data.overdueCarryover.length - 1,
              onTap: () => _openDetail(context, data.overdueCarryover[i]),
              onComplete: () =>
                  _complete(context, ref, data.overdueCarryover[i]),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (data.allDayItems.isNotEmpty) ...[
          Text(
            'All Day',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < data.allDayItems.length; i++)
            PlannerTimelineItem(
              item: data.allDayItems[i],
              showConnector: i != data.allDayItems.length - 1,
              onTap: () => _openDetail(context, data.allDayItems[i]),
              onComplete: () => _complete(context, ref, data.allDayItems[i]),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
        for (var i = 0; i < data.timedItems.length; i++)
          PlannerTimelineItem(
            item: data.timedItems[i],
            showConnector: i != data.timedItems.length - 1,
            onTap: () => _openDetail(context, data.timedItems[i]),
            onComplete: () => _complete(context, ref, data.timedItems[i]),
          ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: TextButton.icon(
            onPressed: () =>
                context.pushNamed(RouteNames.newReminder, extra: selectedDate),
            icon: const Icon(Icons.add),
            label: const Text('Add Reminder'),
          ),
        ),
      ],
    );
  }
}

class _PlannerLoading extends StatelessWidget {
  const _PlannerLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 40),
        SizedBox(height: AppSpacing.lg),
        SectionLoadingPlaceholder(height: 200),
      ],
    );
  }
}

class _PlannerError extends StatelessWidget {
  const _PlannerError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: EmptyState(
        icon: Icons.error_outline,
        message: "Couldn't load your planner",
        ctaLabel: 'Retry',
        onCtaTap: onRetry,
      ),
    );
  }
}
