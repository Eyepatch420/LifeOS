import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/indicators/animated_streak_ring.dart';

class MyListsCard extends StatelessWidget {
  const MyListsCard({required this.lists, super.key});

  final List<ListSummary> lists;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'My Lists'),
          const SizedBox(height: AppSpacing.sm),
          if (lists.isEmpty)
            const EmptyState(
              icon: Icons.checklist_outlined,
              message: 'No lists yet',
            )
          else
            for (final list in lists) _ListTile(list: list),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.list});

  final ListSummary list;

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
            child: Icon(list.icon, size: 18, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  list.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AnimatedStreakRing(
            progress: list.progress,
            label: '${(list.progress * 100).round()}%',
            color: accent,
          ),
        ],
      ),
    );
  }
}
