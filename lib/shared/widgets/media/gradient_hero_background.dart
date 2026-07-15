import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';

/// The bottom-most Stack layer behind the Home hero section: the wave
/// illustration SVG cropped via `BoxFit.cover`, plus a time-of-day tint
/// gradient and an optional dark-mode scrim layered on top (see
/// docs/theme.md for why no dark-mode SVG variant is authored).
///
/// [assetPath] defaults to the existing Home hero SVG so this widget stays
/// reusable by a future module's own hero without an API change later.
class GradientHeroBackground extends StatelessWidget {
  const GradientHeroBackground({
    required this.height,
    required this.tint,
    super.key,
    this.assetPath = 'assets/svg/home/home_hero_background.svg',
  });

  final double height;
  final TimeOfDayTint tint;
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
            // Time-of-day tint — cross-fades between buckets rather than
            // snapping, keyed on the stable `bucket` enum (not the
            // `greeting` string, which could change with a future
            // locale/copy edit without that being a meaningful animation
            // trigger).
            MorphSwitcher(
              child: DecoratedBox(
                key: ValueKey(tint.bucket),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: tint.gradient,
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
