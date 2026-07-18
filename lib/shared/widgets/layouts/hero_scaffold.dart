import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/shared/widgets/layouts/rect_excluding_pointer.dart';

/// Reports a hero-provided widget's measured "interactive controls" region
/// (e.g. a row of buttons), in GLOBAL (screen) coordinates, so
/// [HeroScaffold] can keep the sheet's [CustomScrollView] from swallowing
/// taps meant for those controls. Pass `null` if there's nothing to report
/// (e.g. no controls, or they haven't laid out yet).
///
/// Global coordinates are required (not local to whatever widget measured
/// them) because [HeroScaffold] has no way to know which render box a
/// caller-local rect would be relative to — the hero and the scroll view
/// are separate `Positioned` children of the same `Stack` with no
/// guaranteed shared origin, so global coordinates are the only
/// unambiguous common space. Typically obtained via
/// `(renderBox.localToGlobal(Offset.zero) & renderBox.size)`.
typedef HeroControlsRegionReporter = void Function(Rect? globalRegion);

/// Scroll-driven hero-behind-sheet layout (Apple Health / Fitness style):
///
/// - The [heroBuilder] is a fixed layer pinned to the top — it never
///   scrolls.
/// - The entire page is one [CustomScrollView]; it opens with a spacer of
///   `heroHeight - heroOverlap` so the rounded sheet initially "peeks" over
///   the hero's bottom edge, then the sheet (one rounded container holding
///   [content]) slides up over the hero as the user scrolls.
/// - The scaffold owns the [ScrollController] and drives the hero's fade:
///   the hero stays fully opaque until the scroll offset passes
///   [heroOverlap], then fades linearly to 0 by the time the sheet reaches
///   the top of the screen.
/// - [heroBuilder] receives a [HeroControlsRegionReporter]: call it with the
///   bounds of any interactive controls (search/notification/avatar
///   buttons, etc.) so the sheet's scroll view stops swallowing taps meant
///   for them while the hero is genuinely visible and interactive. This
///   keeps `HeroScaffold` itself free of any Home-specific knowledge — it
///   only ever sees a `Rect` its caller chose to report.
///
/// Reusable by any module wanting a hero header, not just Home.
class HeroScaffold extends StatefulWidget {
  const HeroScaffold({
    required this.heroBuilder,
    required this.content,
    super.key,
    this.heroOverlap = 24,
    this.sheetRadius = 36,
  });

  final Widget Function(
    BuildContext context,
    HeroControlsRegionReporter reportControlsRegion,
  )
  heroBuilder;

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

  /// The [CustomScrollView]'s own render box — used to convert the
  /// hero-reported controls region (received in global coordinates) into
  /// this box's local space, which is what `hitTest`'s `position` argument
  /// is expressed in. Never assume the hero and scroll view share an
  /// origin: they're separate `Positioned` children of the same `Stack`,
  /// with no guarantee of that (e.g. if either gains its own internal
  /// offset/padding later).
  final GlobalKey _scrollViewKey = GlobalKey();

  /// Last rect reported by the hero, in global coordinates (pre-conversion)
  /// — kept so we can skip re-converting/rebuilding when a remeasure
  /// reports the same bounds, since the hero remeasures on every layout
  /// pass (e.g. every frame while [FadeSlideIn] animates in).
  Rect? _lastReportedGlobalRect;

  /// The same region, converted into the scroll view wrapper's local
  /// space — what's actually passed to [RectExcludingPointer].
  Rect? _excludedRectInScrollViewSpace;

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

  /// Whether the hero's controls should still receive the pointer-down
  /// before the sheet's scroll view does. Driven directly from the scroll
  /// offset (the same source of truth as [_heroOpacityFor]) rather than
  /// comparing the derived opacity to `0`: floating-point fade math can
  /// leave `opacity` at a tiny non-zero residue past [sheetTop] depending
  /// on rounding, so anchoring the threshold to the offset itself avoids an
  /// exclusion that lingers (or drops out early) by a fraction of a pixel
  /// of scroll. Matches [sheetTop] exactly — the same point the sheet's
  /// top edge reaches the screen top and the hero finishes fading out.
  bool _heroControlsInteractiveFor(double offset, double sheetTop) {
    return offset < sheetTop;
  }

  void _handleControlsRegionReported(Rect? globalRect) {
    if (globalRect == _lastReportedGlobalRect) return;
    _lastReportedGlobalRect = globalRect;

    if (globalRect == null) {
      if (_excludedRectInScrollViewSpace == null) return;
      setState(() => _excludedRectInScrollViewSpace = null);
      return;
    }

    final scrollViewBox = _scrollViewKey.currentContext?.findRenderObject();
    if (scrollViewBox is! RenderBox || !scrollViewBox.attached) return;

    final converted = Rect.fromPoints(
      scrollViewBox.globalToLocal(globalRect.topLeft),
      scrollViewBox.globalToLocal(globalRect.bottomRight),
    );

    if (converted == _excludedRectInScrollViewSpace) return;
    setState(() => _excludedRectInScrollViewSpace = converted);
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
                child: widget.heroBuilder(
                  context,
                  _handleControlsRegionReported,
                ),
              ),
            ),
            // The whole page scrolls; the sheet is one rounded container.
            // Wrapped in `RectExcludingPointer` so the hero-reported
            // controls region (search/notification/avatar, etc.) can fall
            // through to the hero layer above instead of being swallowed by
            // this full-screen scroll view — hit-testing only, no change to
            // layout/paint/scroll behavior. See `rect_excluding_pointer.dart`.
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  final offset = _scrollController.hasClients
                      ? _scrollController.offset
                      : 0.0;
                  return RectExcludingPointer(
                    excludedRect: _excludedRectInScrollViewSpace,
                    excluding: _heroControlsInteractiveFor(offset, sheetTop),
                    child: child,
                  );
                },
                child: CustomScrollView(
                  key: _scrollViewKey,
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: sheetTop)),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        // Tall enough to fully cover the hero when scrolled
                        // to the end, even if the content itself is short.
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
            ),
          ],
        );
      },
    );
  }
}
