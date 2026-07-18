import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminder_preview_tile.dart';

/// A capped, chronologically-sorted preview of future reminders (see
/// `RemindersDashboardData.upcoming`) with a "View all" action that opens
/// the full `RemindersListScreen` — the dashboard stays an overview, the
/// full list remains the dedicated management screen.
class RemindersUpcomingSection extends StatelessWidget {
  const RemindersUpcomingSection({
    required this.reminders,
    required this.now,
    required this.onTap,
    required this.onViewAll,
    super.key,
    this.maxVisible = 5,
  });

  final List<Reminder> reminders;
  final DateTime now;
  final void Function(String reminderId) onTap;
  final VoidCallback onViewAll;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visible = reminders.take(maxVisible).toList();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Upcoming', onViewAll: onViewAll),
          const SizedBox(height: AppSpacing.sm),
          if (visible.isEmpty)
            const EmptyState(
              icon: Icons.calendar_month_outlined,
              message: 'No upcoming reminders',
            )
          else
            for (final reminder in visible)
              ReminderPreviewTile(
                reminder: reminder,
                now: now,
                onTap: () => onTap(reminder.id),
              ),
        ],
      ),
    );
  }
}
