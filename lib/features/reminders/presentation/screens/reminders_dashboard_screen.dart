import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/domain/models/reminders_dashboard_data.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_data_provider.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminders_overview_stats_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminders_quick_add_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminders_today_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminders_up_next_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminders_upcoming_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planning_workspace_scaffold.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/feedback/section_loading_placeholder.dart';

/// The `/reminders` tab root — the Reminders workspace dashboard (Phase 3):
/// hero + workspace nav (Phase 2, unchanged) + a real, Drift-backed
/// dashboard sheet, hosted by the shared [PlanningWorkspaceScaffold] (Phase
/// 5) that also hosts `PlannerScreen`.
///
/// The sheet derives entirely from [remindersDashboardDataProvider], which
/// itself derives from `RemindersRepository.watchAll()` — no dashboard
/// section here holds independent state or a second data source. The
/// existing full CRUD experience remains at `RemindersListScreen`,
/// reachable via "View all" (`RoutePaths.remindersAll`), not embedded here.
class RemindersDashboardScreen extends ConsumerWidget {
  const RemindersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(remindersClockTickProvider).value ?? DateTime.now();
    final dashboardAsync = ref.watch(remindersDashboardDataProvider);

    return PlanningWorkspaceScaffold(
      activeSection: PlanningWorkspaceSection.reminders,
      content: dashboardAsync.when(
        data: (data) => _RemindersDashboardContent(data: data, now: now),
        loading: () => const _RemindersDashboardLoading(),
        error: (error, stack) => _RemindersDashboardError(
          onRetry: () => ref.invalidate(remindersDashboardDataProvider),
        ),
      ),
    );
  }
}

class _RemindersDashboardContent extends StatelessWidget {
  const _RemindersDashboardContent({required this.data, required this.now});

  final RemindersDashboardData data;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final overdueIds = data.overdue.map((r) => r.id).toSet();

    void openDetail(String reminderId) {
      context.pushNamed(
        RouteNames.reminderDetail,
        pathParameters: {'reminderId': reminderId},
      );
    }

    return StaggeredEntrance(
      children:
          [
                RemindersOverviewStatsSection(data: data),
                RemindersQuickAddSection(
                  onTap: () => context.pushNamed(RouteNames.newReminder),
                ),
                RemindersUpNextSection(
                  upNext: data.upNext,
                  now: now,
                  isOverdue:
                      data.upNext != null &&
                      overdueIds.contains(data.upNext!.id),
                  onTap: openDetail,
                ),
                RemindersTodaySection(
                  reminders: data.today,
                  now: now,
                  overdueIds: overdueIds,
                  onTap: openDetail,
                ),
                RemindersUpcomingSection(
                  reminders: data.upcoming,
                  now: now,
                  onTap: openDetail,
                  onViewAll: () => context.pushNamed(RouteNames.remindersAll),
                ),
              ]
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: section,
                ),
              )
              .toList(),
    );
  }
}

class _RemindersDashboardLoading extends StatelessWidget {
  const _RemindersDashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SectionLoadingPlaceholder(height: 220),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 80),
        SizedBox(height: AppSpacing.xxl),
        SectionLoadingPlaceholder(height: 140),
      ],
    );
  }
}

class _RemindersDashboardError extends StatelessWidget {
  const _RemindersDashboardError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: EmptyState(
        icon: Icons.error_outline,
        message: "Couldn't load your reminders",
        ctaLabel: 'Retry',
        onCtaTap: onRetry,
      ),
    );
  }
}
