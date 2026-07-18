import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/planner/planner_item.dart';
import 'package:lifeos/features/reminders/presentation/widgets/planner/planner_item_visual_state.dart';
import 'package:lifeos/shared/widgets/media/animated_context_icon.dart';

/// One row of the Planner day timeline: time column, vertical connector,
/// and a content row whose icon/accent react to [PlannerItemVisualState]
/// (completed/urgent/recurring/normal — see that enum's doc comment on why
/// these four and not fabricated categories). Tapping opens the reminder's
/// existing detail screen; completing calls back to [onComplete] without
/// this widget knowing anything about recurrence (see
/// `RemindersRepository.setCompleted`'s doc comment — Planner never
/// reimplements that logic).
class PlannerTimelineItem extends StatelessWidget {
  const PlannerTimelineItem({
    required this.item,
    required this.onTap,
    required this.onComplete,
    super.key,
    this.showConnector = true,
  });

  final PlannerItem item;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final visualState = visualStateFor(item);
    final accent = _accentFor(context, visualState);

    return Semantics(
      button: true,
      label:
          '${item.title}, ${DateFormat('h:mm a').format(item.scheduledAt)}'
          '${item.isCompleted ? ', completed' : ''}'
          '${item.isUrgent ? ', urgent' : ''}'
          '${item.isRecurring ? ', recurring' : ''}',
      child: PressableScale(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    DateFormat('h:mm a').format(item.scheduledAt),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: AppSpacing.timelineDotSize,
                      height: AppSpacing.timelineDotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                      ),
                    ),
                    if (showConnector)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: context.colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: accent.withValues(
                        alpha: visualState == PlannerItemVisualState.urgent
                            ? 0.12
                            : 0.06,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: visualState == PlannerItemVisualState.urgent
                          ? Border.all(color: accent.withValues(alpha: 0.4))
                          : null,
                    ),
                    child: Row(
                      children: [
                        AnimatedContextIcon<PlannerItemVisualState>(
                          state: visualState,
                          iconFor: iconForVisualState,
                          colorFor: (_) => accent,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium?.copyWith(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCompleted
                                  ? context.colorScheme.onSurfaceVariant
                                  : null,
                            ),
                          ),
                        ),
                        if (!item.isCompleted)
                          Semantics(
                            button: true,
                            label: 'Mark ${item.title} as completed',
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: onComplete,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _accentFor(BuildContext context, PlannerItemVisualState state) {
    return switch (state) {
      PlannerItemVisualState.completed => context.colorScheme.onSurfaceVariant,
      PlannerItemVisualState.urgent => context.colorScheme.error,
      PlannerItemVisualState.recurring => context.colorScheme.secondary,
      PlannerItemVisualState.normal => context.colorScheme.primary,
    };
  }
}
