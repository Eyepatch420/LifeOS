import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/shared/widgets/media/lottie_illustration.dart';

/// Choreographs the outgoing/incoming illustration hand-off per
/// docs/animation_spec.md: outgoing shrinks to 92%, fully exits to the
/// left (translates by the full available width, not a fractional
/// `SlideTransition` offset — that read as a subtle nudge rather than a
/// clear exit), and fades to 0.4. Incoming starts at 85% scale fully
/// outside the right edge, slides to center, and grows to 100%.
///
/// Both animate simultaneously across the same duration so it reads as
/// "passing one object to another," not a hard cut.
///
/// Detection of which child is incoming (`child.key == ValueKey(assetPath)`)
/// relies on no two adjacent onboarding pages sharing a `lottieAssetPath` —
/// true for `kOnboardingPages` today, but worth keeping in mind if pages
/// are ever restructured to reuse an asset.
class OnboardingIllustrationMorph extends StatelessWidget {
  const OnboardingIllustrationMorph({required this.assetPath, super.key});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final preset = AppMotionPresets.onboardingIllustration;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Fall back to a generous fixed width if constraints are unbounded
        // (shouldn't happen in practice here, but keeps this widget safe to
        // reuse in a context without a bounded width).
        final exitDistance = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 320.0;

        return AnimatedSwitcher(
          duration: preset.duration,
          switchInCurve: preset.curve,
          switchOutCurve: preset.curve,
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.center,
            children: [...previousChildren, ?currentChild],
          ),
          transitionBuilder: (child, animation) {
            final isIncoming = child.key == ValueKey(assetPath);

            if (reduceMotion) {
              // Reduce Motion: communicate the page change with a plain
              // crossfade, no translation/scale movement.
              return FadeTransition(opacity: animation, child: child);
            }

            final scaleTween = isIncoming
                ? Tween<double>(begin: 0.85, end: 1)
                : Tween<double>(begin: 1, end: 0.92);
            final opacityTween = isIncoming
                ? Tween<double>(begin: 0, end: 1)
                : Tween<double>(begin: 1, end: 0.4);
            final translateTween = isIncoming
                ? Tween<double>(begin: exitDistance, end: 0)
                : Tween<double>(begin: 0, end: -exitDistance);

            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                return Opacity(
                  opacity: opacityTween.evaluate(animation),
                  child: Transform.translate(
                    offset: Offset(translateTween.evaluate(animation), 0),
                    child: Transform.scale(
                      scale: scaleTween.evaluate(animation),
                      child: child,
                    ),
                  ),
                );
              },
            );
          },
          child: LottieIllustration(
            key: ValueKey(assetPath),
            assetPath: assetPath,
          ),
        );
      },
    );
  }
}
