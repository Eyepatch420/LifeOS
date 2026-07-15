import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';

/// A small ring showing a streak's weekly completion ratio, tweening on
/// value change. Reusable by the future Habits feature.
class AnimatedStreakRing extends StatelessWidget {
  const AnimatedStreakRing({
    required this.progress,
    required this.label,
    required this.color,
    super.key,
    this.size = 40,
  });

  final double progress;
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: AppMotionPresets.section.duration,
            curve: AppMotionPresets.section.curve,
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              strokeWidth: 4,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
