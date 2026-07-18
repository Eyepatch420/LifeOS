import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/shared/widgets/cards/section_card.dart';

/// The Quick Add entry point — opens the existing `NewReminderScreen`
/// (Phase 3 reuses the real creation flow rather than building a second,
/// dashboard-local creation form or a direct-create shortcut).
class RemindersQuickAddSection extends StatelessWidget {
  const RemindersQuickAddSection({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.colorScheme.primary;

    return Semantics(
      button: true,
      label: 'Add reminder',
      child: PressableScale(
        onTap: onTap,
        child: SectionCard(
          child: Row(
            children: [
              Container(
                width: AppSpacing.quickActionButtonSize,
                height: AppSpacing.quickActionButtonSize,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Reminder',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Create a new reminder',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
