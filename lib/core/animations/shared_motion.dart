import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/stagger.dart';

/// Fades and slides [child] upward into place. Used for card/section
/// entrances so content never simply "appears".
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = AppDurations.medium,
    this.offset = 16,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: delay + duration,
      curve: Interval(
        delay.inMicroseconds / (delay + duration).inMicroseconds,
        1,
        curve: AppCurves.easeOutCubic,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * offset),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Wraps a list of [children] so each one plays a [FadeSlideIn] entrance
/// with an index-driven delay from [Stagger] — e.g. the 4 overview cards,
/// the quick actions row, or a habit-streak list.
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    required this.children,
    super.key,
    this.perItemDelay,
    this.itemDuration = AppDurations.medium,
  });

  final List<Widget> children;
  final Duration? perItemDelay;
  final Duration itemDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          FadeSlideIn(
            delay: Stagger.delayForIndex(i, perItemDelay: perItemDelay),
            duration: itemDuration,
            child: children[i],
          ),
      ],
    );
  }
}

/// Thin wrapper over [AnimatedSwitcher] + [FadeThroughTransition] for content
/// swaps (onboarding illustration/text swap, timeline step reveal, etc.).
class MorphSwitcher extends StatelessWidget {
  const MorphSwitcher({
    required this.child,
    super.key,
    this.duration = AppDurations.medium,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: duration,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Wraps any tappable in a tactile [AnimatedScale] press response.
/// Used by [PrimaryButton], [CircularActionButton], and nav icons.
class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    required this.onTap,
    super.key,
    this.pressedScale = 0.94,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    // Reduce Motion: communicate the press without any scale movement.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final scale = reduceMotion ? 1.0 : (_pressed ? widget.pressedScale : 1.0);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: scale,
        duration: AppDurations.fast,
        curve: AppCurves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
