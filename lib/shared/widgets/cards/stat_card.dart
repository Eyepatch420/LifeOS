import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// One of the 4 overview stat tiles — icon, count, subtext, progress bar.
/// Reusable for future stat tiles (e.g. Finance summary cards).
///
/// [onTap] is optional — most existing stat cards (Tasks, Habits, Mood as
/// of Phase 8) have no wired destination yet and stay inert exactly as
/// before; only a card whose caller supplies [onTap] (Focus, as of Phase
/// 8) becomes a real [PressableScale] button with a semantics label.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.accentColor,
    super.key,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final double progress;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: AppDurations.slow,
              curve: AppCurves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: accentColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(accentColor),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Semantics(
      button: true,
      label: '$label, $value, $subtitle',
      child: PressableScale(onTap: onTap, child: card),
    );
  }
}
