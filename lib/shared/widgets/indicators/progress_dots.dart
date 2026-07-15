import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Onboarding-style page indicator. The active dot animates its own
/// width/opacity independently of whatever content transition is playing
/// alongside it (see docs/animation_spec.md).
///
/// Optional [color] override lets callers (e.g. onboarding's per-page
/// accent) drive the active dot's color — falls back to
/// `context.colorScheme.primary`.
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    required this.count,
    required this.activeIndex,
    super.key,
    this.color,
  });

  final int count;
  final int activeIndex;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppDurations.fast,
            curve: AppCurves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == activeIndex ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == activeIndex ? color : color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
