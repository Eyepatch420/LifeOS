import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';

/// The pill-shaped motivational message banner at the bottom of the hero.
/// Content is data-driven (see `motivationalMessageProvider`), not
/// hardcoded. Only one of [onTap]/[onDismiss] is expected to be supplied —
/// a banner that's both tappable-to-navigate and dismissable is confusing,
/// so when [onDismiss] is set it takes precedence and shows a close icon
/// instead of the decorative chevron.
class MotivationalBanner extends StatelessWidget {
  const MotivationalBanner({
    required this.message,
    super.key,
    this.onTap,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final trailing = onDismiss != null
        ? IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 18),
            onPressed: onDismiss,
            visualDensity: VisualDensity.compact,
          )
        : (onTap != null
              ? const Icon(Icons.chevron_right, color: Colors.white70, size: 20)
              : null);

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
          ),
          ?trailing,
        ],
      ),
    );

    if (onTap == null) return content;
    return Semantics(
      button: true,
      label: message,
      child: GestureDetector(onTap: onTap, child: content),
    );
  }
}
