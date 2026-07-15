import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/durations.dart';

/// Wraps [child] in a [CustomTransitionPage] using [FadeThroughTransition],
/// so top-level route changes feel like a deliberate cross-fade rather than
/// the platform-default slide/push.
CustomTransitionPage<void> buildFadeThroughPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: AppDurations.page,
    reverseTransitionDuration: AppDurations.page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
