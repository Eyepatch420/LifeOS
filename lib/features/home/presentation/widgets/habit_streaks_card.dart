import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

class HabitStreaksCard extends StatelessWidget {
  const HabitStreaksCard({required this.streaks, super.key});

  final List<HabitStreak> streaks;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Habit Streaks'),
          const SizedBox(height: AppSpacing.sm),
          if (streaks.isEmpty)
            const EmptyState(
              icon: Icons.local_fire_department_outlined,
              message: 'No habits tracked yet',
            )
          else
            for (final streak in streaks) _HabitStreakTile(streak: streak),
        ],
      ),
    );
  }
}

class _HabitStreakTile extends StatelessWidget {
  const _HabitStreakTile({required this.streak});

  final HabitStreak streak;

  @override
  Widget build(BuildContext context) {
    final accent = context.colorScheme.primary;
    return Padding(
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
            child: Icon(streak.icon, size: 18, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak.title,
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
    );
  }
}
