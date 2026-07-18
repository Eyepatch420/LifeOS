import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';

/// Scroll-driven hero-behind-sheet layout (Apple Health / Fitness style):
///
/// - The [hero] is a fixed layer pinned to the top — it never scrolls.
/// - The entire page is one [CustomScrollView]; it opens with a spacer of
///   `heroHeight - heroOverlap` so the rounded sheet initially "peeks" over
///   the hero's bottom edge, then the sheet (one rounded container holding
///   [content]) slides up over the hero as the user scrolls.
/// - The scaffold owns the [ScrollController] and drives the hero's fade:
///   the hero stays fully opaque until the scroll offset passes
///   [heroOverlap], then fades linearly to 0 by the time the sheet reaches
///   the top of the screen.
///
/// Reusable by any module wanting a hero header, not just Home.
class HeroScaffold extends StatefulWidget {
  const HeroScaffold({
    required this.hero,
    required this.content,
    super.key,
    this.heroOverlap = 24,
    this.sheetRadius = 36,
  });

  final Widget hero;

  /// Everything that lives inside the sheet — sections, padding included.
  final Widget content;

  /// How far the sheet's top edge initially overlaps the hero's bottom edge.
  final double heroOverlap;

  /// Corner radius of the sheet's rounded top.
  final double sheetRadius;

  /// Single source of truth for the hero's height at a given screen width:
  /// a responsive fraction of width so the tablet-landscape SVG art crops
  /// sensibly via `cover` on any phone size (see docs/theme.md).
  static double heroHeightFor(double width) =>
      (width * 0.62).clamp(330.0, 380.0);

  @override
  State<HeroScaffold> createState() => _HeroScaffoldState();
}

class _HeroScaffoldState extends State<HeroScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 1.0 until the offset passes [HeroScaffold.heroOverlap], then a linear
  /// fade reaching 0.0 exactly when the sheet's top hits the screen top
  /// (offset == sheetTop).
  double _heroOpacityFor(double offset, double sheetTop) {
    final fadeStart = widget.heroOverlap;
    final fadeDistance = sheetTop - fadeStart;
    if (fadeDistance <= 0) return offset >= fadeStart ? 0 : 1;
    return (1 - (offset - fadeStart) / fadeDistance).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = HeroScaffold.heroHeightFor(constraints.maxWidth);
        final sheetTop = (heroHeight - widget.heroOverlap).clamp(
          0.0,
          double.infinity,
        );

        return Stack(
          children: [
            // Hero layer: pinned, never scrolls, fades with the offset.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              // Bound the hero's height explicitly: a Positioned child gets
              // unbounded height otherwise, which breaks heroes that use
              // Spacer/Expanded internally.
              height: heroHeight,
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  final offset = _scrollController.hasClients
                      ? _scrollController.offset
                      : 0.0;
                  final opacity = _heroOpacityFor(offset, sheetTop);
                  return IgnorePointer(
                    ignoring: opacity == 0,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: widget.hero,
              ),
            ),
            // The whole page scrolls; the sheet is one rounded container.
            Positioned.fill(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: sheetTop)),
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      // Tall enough to fully cover the hero when scrolled to
                      // the end, even if the content itself is short.
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(widget.sheetRadius),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: AppSpacing.xxl),
                      child: widget.content,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
