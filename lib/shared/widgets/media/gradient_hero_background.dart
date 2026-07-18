import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// The bottom-most Stack layer behind a workspace hero section: an SVG
/// illustration cropped via `BoxFit.cover`, plus a top-to-bottom tint
/// gradient and an optional dark-mode scrim layered on top (see
/// docs/theme.md for why no dark-mode SVG variant is authored).
///
/// [assetPath] defaults to the existing Home hero SVG so this widget stays
/// reusable by a future module's own hero without an API change later.
///
/// Deliberately feature-agnostic: it only ever receives a plain
/// [overlayGradient] color list, never a [TimeOfDayTint] or a
/// `WorkspaceTheme` directly — Home derives its gradient from the
/// time-of-day bucket, a future workspace can derive one from its
/// `WorkspaceTheme.heroGradient`, and this widget doesn't need to know
/// which. [overlayKey] identifies the gradient for [MorphSwitcher]'s
/// cross-fade — pass a stable key (e.g. an enum) when the gradient can
/// change while this widget stays mounted (Home's time-of-day bucket);
/// omit it for a gradient that's fixed for the widget's lifetime.
class GradientHeroBackground extends StatelessWidget {
  const GradientHeroBackground({
    required this.height,
    required this.overlayGradient,
    super.key,
    this.overlayKey,
    this.assetPath = 'assets/svg/home/home_hero_background.svg',
  });

  final double height;
  final List<Color> overlayGradient;
  final Object? overlayKey;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: OverflowBox(
                maxHeight: height,
                child: SvgPicture.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // Cross-fades between overlays rather than snapping, keyed on
            // the caller-supplied stable identity (not the color list
            // itself, which may not compare equal/could change for
            // unrelated reasons without that being a meaningful animation
            // trigger).
            MorphSwitcher(
              child: DecoratedBox(
                key: ValueKey(overlayKey),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: overlayGradient,
                  ),
                ),
              ),
            ),
            if (context.isDarkMode)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x8C000000), Color(0x40000000)],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
