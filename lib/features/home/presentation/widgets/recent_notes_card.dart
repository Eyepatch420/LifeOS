import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/home/domain/models/dashboard_card_data.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';
import 'package:lifeos/shared/widgets/cards/section_header.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';

class RecentNotesCard extends StatelessWidget {
  const RecentNotesCard({
    required this.notes,
    super.key,
    this.onNoteTap,
    this.onViewAll,
  });

  final List<NoteSummary> notes;

  /// Called with the tapped note's `id` — omitted (no gesture wiring) for
  /// mock-seeded rows that have no `id` (see [NoteSummary.id]).
  final void Function(String id)? onNoteTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Recent Notes', onViewAll: onViewAll),
          const SizedBox(height: AppSpacing.sm),
          if (notes.isEmpty)
            const EmptyState(
              icon: Icons.note_alt_outlined,
              message: 'No notes yet',
            )
          else
            for (final note in notes) _NoteTile(note: note, onTap: onNoteTap),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note, this.onTap});

  final NoteSummary note;
  final void Function(String id)? onTap;

  @override
  Widget build(BuildContext context) {
    final id = note.id;
    return InkWell(
      onTap: id == null || onTap == null ? null : () => onTap!(id),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
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
                note.icon,
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
                    note.title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    note.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(note.timestamp, style: context.textTheme.labelSmall),
                ],
              ),
            ),
            if (note.isPinned)
              Icon(
                Icons.push_pin,
                size: 16,
                color: context.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
