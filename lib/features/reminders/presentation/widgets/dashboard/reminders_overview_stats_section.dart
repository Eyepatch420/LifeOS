import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/models/reminders_dashboard_data.dart';
import 'package:lifeos/shared/responsive/breakpoints.dart';
import 'package:lifeos/shared/widgets/cards/stat_card.dart';

/// The 4 Reminders overview stat tiles (Today / Upcoming / Pending /
/// Overdue), reflowing 2x2 on phone to a single row on tablet — the same
/// breakpoint/layout strategy as Home's `OverviewStatsRow`, reused here as
/// a Reminders-specific composition since `OverviewStatsRow` itself is
/// driven by Home's own `OverviewStat` model, not a generic one.
///
/// `progress` on each [StatCard] is a proportion of `data.pendingCount`
/// purely as a visual indicator — it is not a claim about task completion
/// percentage.
///
/// Phase 4 note: this used to show "Completed" (`completedCount`), but
/// completing a recurring reminder now advances it to its next occurrence
/// instead of leaving an `isCompleted = true` row behind (the single-row
/// recurring model — see `RemindersRepository.setCompleted`'s doc
/// comment), so `completedCount` would silently stop reflecting most
/// real-world completions and become a misleading metric (only one-off
/// reminders would ever count). The schema also has no completion-history
/// table to build a true "completed today"/"completed this week" stat
/// from without a larger migration. "Pending" (`pendingCount` — every
/// non-completed reminder, i.e. Today + Upcoming + Overdue combined) is
/// shown instead: it's always accurately derivable from the current
/// schema regardless of recurrence, and remains a meaningful at-a-glance
/// number. Revisit if/when a completion-history table is added.
class RemindersOverviewStatsSection extends StatelessWidget {
  const RemindersOverviewStatsSection({required this.data, super.key});

  final RemindersDashboardData data;

  @override
  Widget build(BuildContext context) {
    final accent = context.colorScheme.primary;
    final totalActionable = data.pendingCount == 0 ? 1 : data.pendingCount;

    final cards = [
      StatCard(
        icon: Icons.today_outlined,
        label: 'Today',
        value: '${data.todayCount}',
        subtitle: data.todayCount == 1 ? 'reminder' : 'reminders',
        progress: data.todayCount / totalActionable,
        accentColor: accent,
      ),
      StatCard(
        icon: Icons.event_outlined,
        label: 'Upcoming',
        value: '${data.upcoming.length}',
        subtitle: data.upcoming.length == 1 ? 'reminder' : 'reminders',
        progress: data.upcoming.length / totalActionable,
        accentColor: accent,
      ),
      StatCard(
        icon: Icons.pending_actions_outlined,
        label: 'Pending',
        value: '${data.pendingCount}',
        subtitle: 'total active',
        progress: 1,
        accentColor: accent,
      ),
      StatCard(
        icon: Icons.error_outline,
        label: 'Overdue',
        value: '${data.overdueCount}',
        subtitle: 'needs attention',
        progress: data.overdueCount / totalActionable,
        accentColor: accent,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= kTabletBreakpoint;
        final columns = isTablet ? 4 : 2;

        final rows = <Widget>[];
        for (var i = 0; i < cards.length; i += columns) {
          final rowCards = cards.skip(i).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < rowCards.length; j++) ...[
                    if (j > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: rowCards[j]),
                  ],
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              rows[i],
            ],
          ],
        );
      },
    );
  }
}
