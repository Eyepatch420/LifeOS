import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminder_preview_tile.dart';

/// The single nearest actionable reminder (see
/// `remindersForDashboard`/`RemindersDashboardData.upNext`) — a compact,
/// contextual empty state when there is none, never the full-screen
/// `EmptyState` treatment.
class RemindersUpNextSection extends StatelessWidget {
  const RemindersUpNextSection({
    required this.upNext,
    required this.now,
    required this.onTap,
    super.key,
    this.isOverdue = false,
  });

  final Reminder? upNext;
  final DateTime now;
  final void Function(String reminderId) onTap;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Up Next'),
          const SizedBox(height: AppSpacing.sm),
          if (upNext == null)
            const EmptyState(
              icon: Icons.event_available_outlined,
              message: "You're all caught up",
            )
          else
            ReminderPreviewTile(
              reminder: upNext!,
              now: now,
              isOverdue: isOverdue,
              onTap: () => onTap(upNext!.id),
            ),
        ],
      ),
    );
  }
}
