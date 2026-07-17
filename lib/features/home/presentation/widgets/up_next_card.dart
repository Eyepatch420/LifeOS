import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

class UpNextCard extends StatelessWidget {
  const UpNextCard({required this.items, required this.onDismiss, super.key});

  final List<UpNextItem> items;

  /// Called with the dismissed item's [UpNextItem.id] after a swipe.
  final void Function(String id) onDismiss;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Up Next'),
          const SizedBox(height: AppSpacing.sm),
          if (items.isEmpty)
            const EmptyState(
              icon: Icons.event_available_outlined,
              message: "You're all caught up",
            )
          else
            for (final item in items)
              Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                resizeDuration: AppMotionPresets.cardExit.duration,
                movementDuration: AppMotionPresets.cardExit.duration,
                onDismissed: (_) => onDismiss(item.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.onErrorContainer,
                  ),
                ),
                child: _UpNextTile(item: item),
              ),
        ],
      ),
    );
  }
}

class _UpNextTile extends StatelessWidget {
  const _UpNextTile({required this.item});

  final UpNextItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: AppSpacing.tileIconBoxSize,
            height: AppSpacing.tileIconBoxSize,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: item.isUrgent
                        ? context.colorScheme.error
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.notifications_outlined,
            size: 18,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
