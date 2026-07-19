import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/features/focus/domain/entities/focus_visual_stage.dart';
import 'package:lottie/lottie.dart';

/// Per-stage Lottie asset + atmosphere gradient. Feature-owned (not a
/// global theme token) since this atmosphere only ever applies to the
/// Focus session screen — see this file's module doc for why it isn't
/// added to `AppColorsExtension`.
class _StageArt {
  const _StageArt({
    required this.assetPath,
    required this.gradient,
    required this.semanticsLabel,
  });

  final String assetPath;
  final List<Color> gradient;
  final String semanticsLabel;
}

const _stageArt = {
  FocusVisualStage.growing: _StageArt(
    assetPath: 'assets/lottie/A Growing Epiphyte.json',
    gradient: [Color(0xFF1F3D2B), Color(0xFF3E6B4F), Color(0xFF6FA37B)],
    semanticsLabel: 'A young plant growing',
  ),
  FocusVisualStage.ripening: _StageArt(
    assetPath: 'assets/lottie/tomato animation.json',
    gradient: [Color(0xFF6B3A2A), Color(0xFFC97A4A), Color(0xFFF2B679)],
    semanticsLabel: 'A ripening tomato plant',
  ),
  FocusVisualStage.settling: _StageArt(
    assetPath: 'assets/lottie/Day to night.json',
    gradient: [Color(0xFF14213D), Color(0xFF3A4B7A), Color(0xFF6E7FA8)],
    semanticsLabel: 'A landscape transitioning from day to night',
  ),
};

/// Renders the Focus session's current visual "environment" — a
/// crossfading Lottie + background gradient pair whose only input is
/// [stage] (itself derived elsewhere from session progress; see
/// [FocusVisualStage]'s doc comment). Never touches the timer/session
/// state directly, so nothing here can drift from or influence
/// [FocusController]'s authoritative timing.
///
/// [isPaused] freezes the currently-visible Lottie (no further playback,
/// no stage advancement — the caller is responsible for not changing
/// [stage] while paused, since progress itself is frozen) rather than
/// removing it, so the screen doesn't visually reset on pause.
class FocusVisualStagePresenter extends StatelessWidget {
  const FocusVisualStagePresenter({
    required this.stage,
    required this.isPaused,
    super.key,
  });

  final FocusVisualStage stage;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final art = _stageArt[stage]!;

    return AnimatedContainer(
      duration: AppMotionPresets.focusStage.duration,
      curve: AppMotionPresets.focusStage.curve,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: art.gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(24),
      child: AnimatedSwitcher(
        duration: AppMotionPresets.focusStage.duration,
        switchInCurve: AppMotionPresets.focusStage.curve,
        switchOutCurve: AppMotionPresets.focusStage.curve,
        transitionBuilder: (child, animation) {
          // Outgoing: fade + a very small scale-down. Incoming: fade + a
          // small scale-up from ~0.95 to 1.0 — the "premium, organic"
          // transition described for this feature, expressed with
          // AnimatedSwitcher's own in/out animations rather than a bespoke
          // AnimationController per stage (avoids the controller
          // lifecycle/leak risk of manually managing one per Lottie swap).
          final scale = Tween<double>(begin: 0.95, end: 1).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
        child: Semantics(
          key: ValueKey(stage),
          label: art.semanticsLabel,
          child: SizedBox(
            width: double.infinity,
            height: 220,
            child: Lottie.asset(
              art.assetPath,
              fit: BoxFit.contain,
              animate: !isPaused,
              repeat: true,
            ),
          ),
        ),
      ),
    );
  }
}
