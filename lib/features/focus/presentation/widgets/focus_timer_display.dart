import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_controller.dart';

/// The only widget in the Focus screen that watches [focusTickerProvider] —
/// isolates the once-a-second rebuild to this fixed-size text, so the
/// screen shell, Lottie stage, and pause/resume controls never rebuild
/// just because a second passed. [session] is read once per parent build
/// (via [focusControllerProvider] upstream, not re-read here), so a
/// status change (pause/resume/complete) still propagates normally through
/// the parent — only the per-second tick is scoped to this widget.
///
/// Fixed [minFontSize]-driven layout (a monospace-style fixed-width digit
/// area) so the countdown text never reflows/jumps as digits change width
/// (e.g. "9:59" -> "10:00").
class FocusTimerDisplay extends ConsumerWidget {
  const FocusTimerDisplay({required this.session, super.key});

  final FocusSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(focusTickerProvider);
    final now = tick.value ?? DateTime.now();
    final remaining = session.remainingAt(now);

    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return Semantics(
      label: 'Time remaining',
      value: '$minutes minutes $seconds seconds',
      child: Text(
        '$minutes:$seconds',
        style: context.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
