import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/presentation/widgets/dashboard/reminder_due_label.dart';

/// One reminder row shared by the Up Next / Today / Upcoming dashboard
/// sections — a compact preview, distinct from `RemindersListScreen`'s own
/// `ListTile`-based row (which shows the full management affordances:
/// swipe-to-delete, completion toggle). Tapping always opens
/// `ReminderDetailScreen` for [reminder.id]; the dashboard has no
/// mutation affordance of its own.
class ReminderPreviewTile extends StatelessWidget {
  const ReminderPreviewTile({
    required this.reminder,
    required this.now,
    required this.onTap,
    super.key,
    this.isOverdue = false,
  });

  final Reminder reminder;
  final DateTime now;
  final VoidCallback onTap;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: reminder.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: AppSpacing.tileIconBoxSize,
                height: AppSpacing.tileIconBoxSize,
                decoration: BoxDecoration(
                  color:
                      (isOverdue
                              ? context.colorScheme.error
                              : context.colorScheme.primary)
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  isOverdue
                      ? Icons.priority_high_rounded
                      : Icons.notifications_active_outlined,
                  size: 18,
                  color: isOverdue
                      ? context.colorScheme.error
                      : context.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      reminderDueLabel(reminder.dueAt, now: now),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isOverdue
                            ? context.colorScheme.error
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (reminder.isUrgent)
                Icon(
                  Icons.priority_high_rounded,
                  size: 16,
                  color: context.colorScheme.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
