import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';

/// Reusable primitive that transitions smoothly whenever the *semantic
/// state* behind an icon changes — not tied to any one feature's enum.
/// Callers pass a [state] (any value with a working `==`, e.g. an enum) and
/// an [iconFor] mapping; when [state] changes between rebuilds, the icon
/// swaps via a subtle vertical slide + fade instead of popping instantly.
///
/// Introduced for Planner's timeline items (normal/urgent/recurring/
/// completed reminder icons — see `PlannerTimelineItem`) but deliberately
/// generic: the same primitive is meant to be reused later for Habit
/// types, Finance transaction categories, and Document categories (see
/// Phase 5 plan) without modification — it has zero knowledge of
/// `RecurrenceRule` or any other feature enum.
class AnimatedContextIcon<T> extends StatelessWidget {
  const AnimatedContextIcon({
    required this.state,
    required this.iconFor,
    super.key,
    this.colorFor,
    this.size = 20,
    this.duration = AppDurations.fast,
  });

  final T state;
  final IconData Function(T state) iconFor;
  final Color? Function(T state)? colorFor;
  final double size;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final icon = iconFor(state);
    final color = colorFor?.call(state);

    return ClipRect(
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: AppCurves.easeOutCubic,
        switchOutCurve: AppCurves.easeOutCubic,
        transitionBuilder: (child, animation) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: Icon(icon, key: ValueKey<T>(state), size: size, color: color),
      ),
    );
  }
}
