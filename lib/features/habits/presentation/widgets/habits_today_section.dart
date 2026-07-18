import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';

/// Today's scheduled habits, with a direct completion toggle — mirrors
/// `RemindersTodaySection`'s shape. Completion always goes through
/// [HabitsRepository.setCompletedForDate] (via [habitsRepositoryProvider]),
/// never independent widget-local state, so it stays correct wherever else
/// the same habit is shown (Home's Active Habit Streaks, Planner).
class HabitsTodaySection extends ConsumerWidget {
  const HabitsTodaySection({
    required this.streaks,
    required this.onTap,
    super.key,
  });

  final List<HabitStreakSummary> streaks;
  final void Function(String habitId) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: "Today's Habits"),
          const SizedBox(height: AppSpacing.sm),
          for (final streak in streaks)
            _TodayHabitTile(
              streak: streak,
              onTap: () => onTap(streak.id),
              onToggle: () => ref
                  .read(habitsRepositoryProvider)
                  .setCompletedForDate(
                    streak.id,
                    DateTime.now(),
                    completed: !streak.isCompletedToday,
                  ),
            ),
        ],
      ),
    );
  }
}

class _TodayHabitTile extends StatelessWidget {
  const _TodayHabitTile({
    required this.streak,
    required this.onTap,
    required this.onToggle,
  });

  final HabitStreakSummary streak;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          '${streak.title}'
          '${streak.isCompletedToday ? ', completed today' : ''}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  streak.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: streak.isCompletedToday
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: context.colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
              ),
              Semantics(
                button: true,
                label: streak.isCompletedToday
                    ? 'Undo completion'
                    : 'Mark done',
                child: PressableScale(
                  onTap: onToggle,
                  child: Icon(
                    streak.isCompletedToday
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: streak.isCompletedToday
                        ? context.colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
