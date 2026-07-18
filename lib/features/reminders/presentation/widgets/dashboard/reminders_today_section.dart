import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminder_preview_tile.dart';

/// A capped preview of today's reminders (see
/// `RemindersDashboardData.today`, already sorted soonest-first by
/// `remindersForDashboard`). Shows at most [maxVisible] rows.
class RemindersTodaySection extends StatelessWidget {
  const RemindersTodaySection({
    required this.reminders,
    required this.now,
    required this.onTap,
    required this.overdueIds,
    super.key,
    this.maxVisible = 4,
  });

  final List<Reminder> reminders;
  final DateTime now;
  final void Function(String reminderId) onTap;
  final Set<String> overdueIds;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visible = reminders.take(maxVisible).toList();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Today'),
          const SizedBox(height: AppSpacing.sm),
          if (visible.isEmpty)
            const EmptyState(
              icon: Icons.wb_sunny_outlined,
              message: 'Nothing due today',
            )
          else
            for (final reminder in visible)
              ReminderPreviewTile(
                reminder: reminder,
                now: now,
                isOverdue: overdueIds.contains(reminder.id),
                onTap: () => onTap(reminder.id),
              ),
        ],
      ),
    );
  }
}
