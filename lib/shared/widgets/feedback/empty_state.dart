import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Shown by a section widget in place of its populated content when its
/// data list is empty. One shared widget so every Home (and future-module)
/// section renders empty states consistently instead of silently showing
/// "header + nothing".
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.message,
    super.key,
    this.ctaLabel,
    this.onCtaTap,
  });

  final IconData icon;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    final showCta = ctaLabel != null && onCtaTap != null;

    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Column(
          children: [
            Icon(icon, size: 32, color: context.colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (showCta) ...[
              const SizedBox(height: AppSpacing.xs),
              TextButton(onPressed: onCtaTap, child: Text(ctaLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
