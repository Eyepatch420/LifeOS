import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/habits/domain/contracts/habits_summary.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';

/// The Habits workspace's own "Active Streaks" section — real streaks
/// derived from [HabitStreakSummary.streakDays]/[HabitStreakSummary.last7Days],
/// same visual shape as Home's `HabitStreaksCard` (Home now watches the
/// same underlying [habitsDashboardProvider] data, just via its own thin
/// `HabitStreaksNotifier` wrapper — see that provider's doc comment).
class HabitsStreaksSection extends StatelessWidget {
  const HabitsStreaksSection({
    required this.streaks,
    required this.onTap,
    super.key,
  });

  final List<HabitStreakSummary> streaks;
  final void Function(String habitId) onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Active Streaks'),
          const SizedBox(height: AppSpacing.sm),
          for (final streak in streaks)
            _StreakTile(streak: streak, onTap: () => onTap(streak.id)),
        ],
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.streak, required this.onTap});

  final HabitStreakSummary streak;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.colorScheme.primary;
    return InkWell(
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
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                Icons.track_changes_outlined,
                size: 18,
                color: accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    streak.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${streak.streakDays} day streak',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      for (final done in streak.last7Days)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: Container(
                            width: AppSpacing.streakDotSize,
                            height: AppSpacing.streakDotSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done
                                  ? accent
                                  : accent.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
