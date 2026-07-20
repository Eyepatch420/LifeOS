import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/features/focus/domain/entities/focus_visual_stage.dart';
import 'package:lottie/lottie.dart';

/// Per-stage environment art. Feature-owned (not a global theme token)
/// since this atmosphere only ever applies to the Focus session screen —
/// see this file's module doc for why it isn't added to
/// `AppColorsExtension`.
///
/// [backgroundAsset] is null for [FocusVisualStage.settling]: unlike
/// green.png/orange.png, "Day to night.json" is a self-contained circular
/// vignette illustration (its own composition includes a "Circle" mask/frame
/// shape layer, confirmed by inspecting the JSON) rather than a full-bleed
/// landscape photo, so it's rendered inside a dedicated circular container
/// with an ambient glow instead of stretched to cover the screen — see
/// [_ReflectEnvironment].
class _StageArt {
  const _StageArt({
    required this.foregroundAsset,
    required this.foregroundAlignment,
    required this.scrimColor,
    required this.semanticsLabel,
    this.backgroundAsset,
  });

  final String? backgroundAsset;
  final String foregroundAsset;
  final Alignment foregroundAlignment;

  /// Base tint shown under the environment before/if the image/Lottie has
  /// painted, and blended into the readability scrim — keeps each stage's
  /// gradient overlay (see [_ReadabilityScrim]) color-matched to its art
  /// instead of a single neutral dark for all three.
  final Color scrimColor;
  final String semanticsLabel;
}

const _stageArt = {
  FocusVisualStage.growing: _StageArt(
    backgroundAsset: 'assets/backgrounds/green.png',
    foregroundAsset: 'assets/lottie/A Growing Epiphyte.json',
    // Deliberately low: the terrain silhouette needs to sit down near
    // where the screen's own readability gradient (the dark
    // bottom-anchored overlay painted above this stage — see
    // `_ReadabilityScrim`) starts darkening, so it reads as ground the
    // plant grows up out of rather than a disconnected shape floating in
    // open sky mid-screen. Not lower than this: the gradient is nearly
    // opaque black below ~0.72 of the stage, which swallowed the terrain
    // silhouette entirely at a lower alignment — see `_GrowEnvironment`.
    foregroundAlignment: Alignment(0, 0.18),
    scrimColor: Color(0xFF0F2116),
    semanticsLabel: 'A young plant growing in a green forest',
  ),
  FocusVisualStage.ripening: _StageArt(
    backgroundAsset: 'assets/backgrounds/orange.png',
    foregroundAsset: 'assets/lottie/tomato animation.json',
    foregroundAlignment: Alignment(0, -0.15),
    scrimColor: Color(0xFF3A1F10),
    semanticsLabel: 'A ripening tomato plant in a warm sunset landscape',
  ),
  FocusVisualStage.settling: _StageArt(
    foregroundAsset: 'assets/lottie/Day to night.json',
    foregroundAlignment: Alignment.center,
    scrimColor: Color(0xFF0B1020),
    semanticsLabel: 'A landscape transitioning from day to night',
  ),
};

/// Renders the Focus session's current full-screen visual "environment" —
/// a crossfading background + foreground pair whose only input is [stage]
/// (itself derived elsewhere from session progress; see
/// [FocusVisualStage]'s doc comment). Never touches the timer/session state
/// directly, so nothing here can drift from or influence
/// [FocusController]'s authoritative timing.
///
/// Each stage's foreground content is delegated to a small dedicated widget
/// ([_GrowEnvironment] / [_ThriveEnvironment] / [_ReflectEnvironment]) so
/// each can own its own extra visual machinery (CustomPainter ridge,
/// off-screen branch overflow, independently-looping glow) without
/// complicating the other two.
///
/// [isPaused] freezes the currently-visible Lottie (no further playback,
/// no stage advancement — the caller is responsible for not changing
/// [stage] while paused, since progress itself is frozen) rather than
/// removing it, so the screen doesn't visually reset on pause. Stage 3's
/// ambient loop is presentational only (see [_ReflectEnvironment]) and is
/// not frozen by [isPaused] except under reduced motion.
///
/// [dayToNightProgress] is accepted for API compatibility with the caller
/// but is no longer used to scrub the settling-stage Lottie — that
/// coupling was removed; the Day-to-night animation now loops
/// independently of Focus progress (see [_ReflectEnvironment]'s doc
/// comment for why).
class FocusVisualStagePresenter extends StatelessWidget {
  const FocusVisualStagePresenter({
    required this.stage,
    required this.isPaused,
    required this.dayToNightProgress,
    super.key,
  });

  final FocusVisualStage stage;
  final bool isPaused;
  final double dayToNightProgress;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final art = _stageArt[stage]!;
    final duration = reduceMotion
        ? AppDurations.fast
        : AppMotionPresets.focusStage.duration;
    final curve = AppMotionPresets.focusStage.curve;

    return ColoredBox(
      color: art.scrimColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: duration,
            switchInCurve: curve,
            switchOutCurve: curve,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              fit: StackFit.expand,
              children: [...previousChildren, ?currentChild],
            ),
            child: art.backgroundAsset == null
                ? const SizedBox.shrink(key: ValueKey('bg-none'))
                : Image.asset(
                    art.backgroundAsset!,
                    key: ValueKey(art.backgroundAsset),
                    fit: BoxFit.cover,
                    // Keeps the visually "busy" lower portion of each
                    // landscape (canopy/horizon) on screen across common
                    // phone aspect ratios instead of centering blindly.
                    alignment: Alignment.topCenter,
                  ),
          ),
          AnimatedSwitcher(
            duration: duration,
            switchInCurve: curve,
            switchOutCurve: curve,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              fit: StackFit.expand,
              children: [...previousChildren, ?currentChild],
            ),
            transitionBuilder: (child, animation) {
              // Outgoing: fade + a very small scale-down. Incoming: fade +
              // a small scale-up from ~0.95 to 1.0 — the "premium,
              // organic" transition described for this feature, expressed
              // with AnimatedSwitcher's own in/out animations rather than
              // a bespoke AnimationController per stage (avoids the
              // controller lifecycle/leak risk of manually managing one
              // per Lottie swap).
              final scale = reduceMotion
                  ? const AlwaysStoppedAnimation(1.0)
                  : Tween<double>(begin: 0.95, end: 1).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: scale, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(stage),
              child: switch (stage) {
                FocusVisualStage.growing => _GrowEnvironment(
                  art: art,
                  isPaused: isPaused,
                ),
                FocusVisualStage.ripening => _ThriveEnvironment(
                  art: art,
                  isPaused: isPaused,
                ),
                FocusVisualStage.settling => _ReflectEnvironment(
                  art: art,
                  isPaused: isPaused,
                  reduceMotion: reduceMotion,
                ),
              },
            ),
          ),
          const _ReadabilityScrim(),
        ],
      ),
    );
  }
}

/// Grow stage: the Epiphyte Lottie and its extreme-foreground terrain
/// (forest floor, rocks, low foliage) rendered as ONE composition sharing a
/// single responsive coordinate system — see [GrowPlantComposition]. This
/// replaces an earlier version where the Lottie was positioned via
/// `Align`/`FractionallySizedBox` against the full stage while a
/// `CustomPainter` computed independent geometry from the stage's own
/// `size.width`/`size.height`: two decoupled layout systems that only lined
/// up by coincidence on the one device profile they were tuned against, and
/// drifted apart (exposing the Lottie's baked-in rod) on other aspect
/// ratios. Now the painter and the Lottie both read the same
/// `LayoutBuilder` constraints, so they scale together on any screen, while
/// [GrowPlantComposition.plantAlignment] independently controls how much of
/// the plant sits above vs. below the terrain within that shared box.
class _GrowEnvironment extends StatelessWidget {
  const _GrowEnvironment({required this.art, required this.isPaused});

  final _StageArt art;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: art.foregroundAlignment,
          child: GrowPlantComposition(
            semanticsLabel: art.semanticsLabel,
            isPaused: isPaused,
          ),
        ),
        // Painted at the full-stage level (not inside the plant's own
        // bounded box) specifically so its canvas can extend all the way
        // to the bottom of the screen — an earlier version confined the
        // terrain to the plant's own square box, which ended partway down
        // the stage and left a visible seam where its bottom edge met the
        // plain (unpainted-by-terrain) readability scrim continuing below
        // it. Now there's nothing below the terrain's own canvas for a
        // seam to appear against.
        const Positioned.fill(child: _GrowTerrainLayer()),
      ],
    );
  }
}

/// Positions [_ForegroundTerrainPainter] against the FULL stage (not the
/// plant's own bounded box the way an earlier version did) so its canvas
/// can extend all the way to the literal bottom of the screen — that
/// previous version's terrain canvas ended partway down the stage, leaving
/// a visible seam where its bottom edge met the plain readability scrim
/// continuing below it with no terrain painted against it. [_terrainTop]
/// is a fixed fraction of the stage height (tuned to visually line up
/// with the plant's own position/size) rather than being derived from
/// [GrowPlantComposition]'s internal layout, so the two stay decoupled but
/// visually aligned by design rather than by a fragile cross-widget
/// coordinate dependency.
class _GrowTerrainLayer extends StatelessWidget {
  const _GrowTerrainLayer();

  /// Fraction of the full stage height where the terrain BAND's rolling
  /// top edge sits — tuned to align with where the plant's base/leaves
  /// currently render (see `GrowPlantComposition.plantAlignment` and
  /// `_stageArt`'s `foregroundAlignment` for Grow).
  static const double _terrainTop = 0.62;

  /// The terrain band's own height, as a fraction of the full stage
  /// height — deliberately small/fixed regardless of how far down
  /// [_terrainTop] sits, so rock/grass feature sizes (normalized against
  /// this band's height inside [_TerrainMetrics]) stay constant instead of
  /// scaling up if the band were sized to fill all remaining space down to
  /// the screen bottom.
  static const double _bandHeightFraction = 0.16;

  /// Terrain width as a fraction of the full stage width — wide enough to
  /// extend past both horizontal edges of the plant above it.
  static const double _terrainWidthFraction = 1.1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, stageConstraints) {
        final stageWidth = stageConstraints.maxWidth;
        final stageHeight = stageConstraints.maxHeight;
        final terrainWidth = stageWidth * _terrainWidthFraction;
        final bandTopY = stageHeight * _terrainTop;
        final bandHeight = stageHeight * _bandHeightFraction;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Solid fill from the bottom of the painted band down to the
            // literal bottom of the screen — this, not an inflated
            // painter canvas, is what removes the seam: a single flat
            // rect in the ground's own color needs no feature-size
            // normalization the way rocks/grass do.
            Positioned(
              left: 0,
              right: 0,
              top: bandTopY + bandHeight,
              bottom: 0,
              child: const ColoredBox(color: _TerrainMetrics.ground),
            ),
            Positioned(
              left: (stageWidth - terrainWidth) / 2,
              top: bandTopY,
              width: terrainWidth,
              height: bandHeight,
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(terrainWidth, bandHeight),
                  // plantBoxWidth here is only used to normalize the
                  // rock/grass *horizontal* spacing relative to the
                  // terrain's own width — passing terrainWidth directly
                  // (rather than trying to recover the plant's actual box
                  // width) keeps this self-contained.
                  painter: _ForegroundTerrainPainter(
                    plantBoxWidth: terrainWidth / _terrainWidthFactor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The Epiphyte Lottie, laid out inside one bounded, screen-proportional
/// box (via [FractionallySizedBox] + [AspectRatio], matching how
/// Thrive/Reflect size their own foreground elements). The terrain is
/// painted separately by [_GrowTerrainLayer] at the full-stage level (see
/// its doc comment for why) — this widget only owns the plant itself,
/// positioned via [plantAlignment] so more of the stem/rod reads as
/// visible above the terrain rather than only the leaf cluster.
class GrowPlantComposition extends StatelessWidget {
  const GrowPlantComposition({
    required this.semanticsLabel,
    required this.isPaused,
    super.key,
  });

  final String semanticsLabel;
  final bool isPaused;

  /// Shifts the Lottie upward relative to the terrain (which stays
  /// bottom-anchored) so more of the plant growing up the rod reads as
  /// visible, not just a small leaf cluster near the terrain line.
  static const Alignment plantAlignment = Alignment(0, -0.5);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: AspectRatio(
          // Matches "A Growing Epiphyte.json"'s own 500x500 composition —
          // a bounded, screen-proportional box instead of an infinite one,
          // so `BoxFit.contain` sizes the plant like a foreground element
          // sitting in the landscape rather than a giant shape stretched
          // to fill the screen.
          aspectRatio: 1,
          // The Epiphyte's baked-in vertical "rod" (a stroked line in the
          // source Lottie) was measured directly from the composition
          // JSON: in its own 500x500 canvas space it runs from y ~= -16 to
          // y ~= 852, spanning the entire frame and overshooting both
          // edges — and the leaves are attached to a null layer whose
          // position is itself animated over the growth timeline, so no
          // fixed zoom/crop/fade of the Lottie alone stays correctly
          // positioned across the whole animation (tried and discarded:
          // ShaderMask fade, static OverflowBox crop, and a 2.1x zoom —
          // see git history). Positioned via [plantAlignment] so more of
          // the stem is visible above the terrain (painted separately, at
          // the full-stage level — see `_GrowTerrainLayer`) than at its
          // default bottom-center rest position.
          child: Align(
            alignment: plantAlignment,
            child: Lottie.asset(
              'assets/lottie/A Growing Epiphyte.json',
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

/// How much wider than the plant's own square box ([GrowPlantComposition]'s
/// `plantBox`) the terrain canvas is — lets the ground/rock silhouette
/// extend past both of the plant's horizontal edges (so its own boundary
/// never reads as a floating rectangle) while every coordinate inside the
/// painter is still expressed as a fraction of `plantBoxWidth`, not of this
/// wider canvas, so the terrain's scale stays locked to the plant.
const double _terrainWidthFactor = 1.6;

/// Paints ONLY the extreme foreground the camera is conceptually close to:
/// a low, gently uneven forest-floor line hugging the very bottom of the
/// composition, 3 small rock clusters at the plant's base, and a few soft
/// grass blades — never another mountain range (green.png already supplies
/// distant/midground mountains; an earlier version's second painted range
/// competed with it and read as an artificial sine-wave hill).
///
/// [plantBoxWidth] is the *plant's* square box width (not this painter's
/// own wider canvas — see [_terrainWidthFactor]); every fraction in
/// [_TerrainMetrics] is normalized against it and against the shared
/// [Size.height], so ground/rock/grass positions stay locked to the
/// Lottie's own layout box and cannot drift from it on a different screen.
///
/// Layered back-to-front: the ground silhouette (rearmost), 3 rock
/// clusters, then grass blades (frontmost) — the rocks sit directly under
/// the plant's horizontal center to occlude the Lottie's baked-in rod
/// where it terminates, so the plant reads as emerging from behind/between
/// them rather than the terrain being a flat mask drawn under it.
class _ForegroundTerrainPainter extends CustomPainter {
  const _ForegroundTerrainPainter({required this.plantBoxWidth});

  final double plantBoxWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final m = _TerrainMetrics(canvasSize: size, plantBoxWidth: plantBoxWidth);
    final top = _TerrainMetrics._groundTopFraction * size.height;

    // Each terrain element's fill fades from its own color into
    // [_TerrainMetrics.ground] by the bottom of this band — matching
    // exactly the flat-color fill `_GrowTerrainLayer` paints below this
    // band to reach the screen's bottom, so the two meet without a
    // visible seam. (Fading all the way to transparent was tried and
    // reverted: it let the Lottie behind this Stack layer show through as
    // a ghosted double-exposure.)
    Paint fadeToGround(Color base) {
      return Paint()
        ..shader = ui.Gradient.linear(Offset(0, top), Offset(0, size.height), [
          base,
          _TerrainMetrics.ground,
        ]);
    }

    canvas.drawPath(m.groundPath(), fadeToGround(_TerrainMetrics.ground));
    for (final rock in m.rocks) {
      canvas.drawPath(rock.path, fadeToGround(rock.color));
    }
    for (final blade in m.grassBlades) {
      canvas.drawPath(blade, fadeToGround(_TerrainMetrics.grass));
    }
  }

  @override
  bool shouldRepaint(_ForegroundTerrainPainter oldDelegate) =>
      oldDelegate.plantBoxWidth != plantBoxWidth;
}

class _Rock {
  const _Rock(this.path, this.color);
  final Path path;
  final Color color;
}

/// Normalized terrain geometry. Horizontal fractions (`_px`) are relative
/// to [plantBoxWidth] and centered within the wider [canvasSize] (so `0`
/// means "the plant box's left edge," not the painter's own canvas edge);
/// vertical fractions (`_py`) are relative to [canvasSize.height], which
/// is shared 1:1 with the plant's box height. This split is what keeps the
/// terrain locked to the plant regardless of how much wider the terrain
/// canvas is than the plant's own square box.
class _TerrainMetrics {
  _TerrainMetrics({required Size canvasSize, required this.plantBoxWidth})
    : _canvasWidth = canvasSize.width,
      _canvasHeight = canvasSize.height,
      _plantLeft = (canvasSize.width - plantBoxWidth) / 2;

  final double plantBoxWidth;
  final double _canvasWidth;
  final double _canvasHeight;
  final double _plantLeft;

  double _px(double plantFraction) =>
      _plantLeft + plantFraction * plantBoxWidth;
  double _py(double fraction) => fraction * _canvasHeight;

  /// Where the ground silhouette's top edge sits, as a fraction of box
  /// height, within this painter's own (small, fixed-height) band canvas —
  /// see [_GrowTerrainLayer] for how a separate solid-color fill extends
  /// the visual terrain the rest of the way to the screen bottom without
  /// this canvas itself growing (which would otherwise inflate every
  /// rock/grass feature size along with it).
  static const double _groundTopFraction = 0.22;

  static const ground = Color(0xFF13291B);
  static const _rockLight = Color(0xFF4C7350);
  static const _rockDark = Color(0xFF24462C);
  static const grass = Color(0xFF3D6B3F);

  /// The forest-floor silhouette — a single irregular line (no repeating
  /// sine pattern) running the full (wider-than-plant) canvas width, so it
  /// reads as ground continuing past both sides of the plant rather than a
  /// box drawn behind it. Uses noticeably larger vertical swings than an
  /// earlier version (whose ±0.04 fraction was nearly flat and read as a
  /// hard-edged block rather than uneven terrain) and dips lowest directly
  /// under the plant so the rocks/plant base can sit visually "in" a
  /// shallow hollow rather than on a flat shelf.
  Path groundPath() {
    final top = _groundTopFraction;
    return Path()
      ..moveTo(0, _py(top + 0.03))
      ..cubicTo(
        _canvasWidth * 0.12,
        _py(top - 0.06),
        _canvasWidth * 0.22,
        _py(top + 0.05),
        _canvasWidth * 0.32,
        _py(top - 0.02),
      )
      ..cubicTo(
        _canvasWidth * 0.4,
        _py(top - 0.08),
        _canvasWidth * 0.46,
        _py(top + 0.06),
        _canvasWidth * 0.5,
        _py(top + 0.08),
      )
      ..cubicTo(
        _canvasWidth * 0.54,
        _py(top + 0.06),
        _canvasWidth * 0.6,
        _py(top - 0.08),
        _canvasWidth * 0.68,
        _py(top - 0.02),
      )
      ..cubicTo(
        _canvasWidth * 0.78,
        _py(top + 0.05),
        _canvasWidth * 0.88,
        _py(top - 0.06),
        _canvasWidth,
        _py(top + 0.03),
      )
      ..lineTo(_canvasWidth, _canvasHeight)
      ..lineTo(0, _canvasHeight)
      ..close();
  }

  /// 3 rock clusters centered on the plant's base — the element actually
  /// responsible for hiding the rod's termination, since the plant appears
  /// to emerge from directly behind/between them. Sized noticeably larger
  /// than an earlier pass (whose small radii read as barely-visible
  /// pebbles) and alternates [_rockLight]/[_rockDark], both now bright
  /// enough to separate clearly from [ground] instead of blending into one
  /// dark mass.
  List<_Rock> get rocks {
    final top = _groundTopFraction;
    return [
      _rock(cx: 0.35, cy: top + 0.05, rw: 0.15, rh: 0.09, color: _rockDark),
      _rock(cx: 0.5, cy: top + 0.03, rw: 0.13, rh: 0.11, color: _rockLight),
      _rock(cx: 0.64, cy: top + 0.06, rw: 0.14, rh: 0.08, color: _rockDark),
    ];
  }

  _Rock _rock({
    required double cx,
    required double cy,
    required double rw,
    required double rh,
    required Color color,
  }) {
    final centerX = _px(cx);
    final centerY = _py(cy);
    final radiusX = plantBoxWidth * rw;
    final radiusY = _canvasHeight * rh;
    // A rounded, irregular silhouette (not a sharp hexagon) reads as a
    // smooth river rock rather than a shard — six points at uneven radii,
    // connected with quadratic curves instead of straight lines.
    final path = Path()
      ..moveTo(centerX - radiusX, centerY + radiusY * 0.5)
      ..quadraticBezierTo(
        centerX - radiusX,
        centerY - radiusY * 0.6,
        centerX - radiusX * 0.35,
        centerY - radiusY,
      )
      ..quadraticBezierTo(
        centerX + radiusX * 0.15,
        centerY - radiusY * 1.15,
        centerX + radiusX * 0.65,
        centerY - radiusY * 0.7,
      )
      ..quadraticBezierTo(
        centerX + radiusX,
        centerY - radiusY * 0.2,
        centerX + radiusX * 0.85,
        centerY + radiusY * 0.4,
      )
      ..quadraticBezierTo(
        centerX + radiusX * 0.4,
        centerY + radiusY * 0.75,
        centerX - radiusX,
        centerY + radiusY * 0.5,
      )
      ..close();
    return _Rock(path, color);
  }

  /// Small clumped grass tufts near the plant's base — wide, soft
  /// teardrop blades (not the earlier version's near-invisible 3px-wide
  /// spikes) in a lighter green that actually reads against [ground],
  /// clustered close to the plant rather than spread along the whole
  /// width, so they help sell "small foreground vegetation around the
  /// plant" rather than a decorative border.
  List<Path> get grassBlades {
    const positions = [0.4, 0.44, 0.56, 0.6];
    final top = _groundTopFraction;
    return [
      for (final cx in positions)
        Path()
          ..moveTo(_px(cx) - plantBoxWidth * 0.02, _py(top + 0.06))
          ..quadraticBezierTo(
            _px(cx) - plantBoxWidth * 0.03,
            _py(top - 0.02),
            _px(cx),
            _py(top - 0.09),
          )
          ..quadraticBezierTo(
            _px(cx) + plantBoxWidth * 0.03,
            _py(top - 0.02),
            _px(cx) + plantBoxWidth * 0.02,
            _py(top + 0.06),
          )
          ..close(),
    ];
  }
}

/// Thrive stage: the Tomato Lottie rendered wider than the viewport and
/// clipped to it, so the horizontal branch ("Batang" in the source
/// composition) visually continues beyond both screen edges instead of
/// visibly terminating on-screen. The Tomato itself stays centered and
/// undistorted since the whole composition is scaled uniformly (never
/// stretched on one axis only) via [OverflowBox] + a wider-than-viewport
/// width — [ClipRect] (implicit in [OverflowBox]'s parent clip behavior via
/// the surrounding [Stack]/screen bounds) then hides the branch's true
/// endpoints.
class _ThriveEnvironment extends StatelessWidget {
  const _ThriveEnvironment({required this.art, required this.isPaused});

  final _StageArt art;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: art.foregroundAlignment,
      child: Semantics(
        label: art.semanticsLabel,
        child: ClipRect(
          child: FractionallySizedBox(
            // Wider than the viewport (1.35x): pushes both of the
            // composition's branch endpoints off-screen while the parent
            // ClipRect hides them, without deforming the Lottie (still
            // rendered at its native 1:1 aspect ratio, just scaled up
            // uniformly and overflowing horizontally).
            widthFactor: 1.35,
            child: AspectRatio(
              aspectRatio: 1,
              child: Lottie.asset(
                art.foregroundAsset,
                fit: BoxFit.contain,
                animate: !isPaused,
                repeat: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reflect stage: the Day-to-night Lottie loops continuously and
/// independently of Focus session progress (previously it was scrubbed
/// frame-by-frame from session progress via `AnimationController.value`,
/// which made playback feel mechanically tied to the timer rather than
/// like ambient atmosphere — removed per product direction). It sits
/// inside a circular container with a soft ambient glow whose color/blur
/// evolve with the Lottie's own playback phase (day → sunset → dusk →
/// night → loop), driven by the same controller that plays the Lottie so
/// the two can never drift apart.
///
/// The glow's [AnimatedBuilder] is scoped tightly around just the circle +
/// shadow — [FocusVisualStagePresenter]'s AnimatedSwitcher, the readability
/// scrim, and the persistent timer/header/button UI (owned by
/// `_ActiveFocusView`) never rebuild from this controller's ticks.
class _ReflectEnvironment extends StatefulWidget {
  const _ReflectEnvironment({
    required this.art,
    required this.isPaused,
    required this.reduceMotion,
  });

  final _StageArt art;
  final bool isPaused;
  final bool reduceMotion;

  @override
  State<_ReflectEnvironment> createState() => _ReflectEnvironmentState();
}

class _ReflectEnvironmentState extends State<_ReflectEnvironment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.reduceMotion) {
      _controller.repeat();
    } else {
      _controller.value = 0;
    }
  }

  @override
  void didUpdateWidget(_ReflectEnvironment oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ambient loop is presentational only and intentionally keeps playing
    // through Focus pause (per product direction) — only reduced-motion
    // freezes it.
    if (widget.reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!widget.reduceMotion && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.art.foregroundAlignment,
      child: Semantics(
        label: widget.art.semanticsLabel,
        child: FractionallySizedBox(
          widthFactor: 0.85,
          child: AspectRatio(
            aspectRatio: 1,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final glow = _GlowPhase.at(_controller.value);
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: glow.color.withValues(alpha: glow.opacity),
                          blurRadius: glow.blurRadius,
                          spreadRadius: glow.spreadRadius,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: ClipOval(
                  child: Lottie.asset(
                    'assets/lottie/Day to night.json',
                    // `.contain`, not `.cover`: this composition is a
                    // circular vignette with its own transparent margins
                    // (its "Circle" shape layer is the visible frame), not
                    // a full-bleed photo.
                    fit: BoxFit.contain,
                    animate: !widget.reduceMotion,
                    repeat: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ambient glow color/blur/spread for a given point in the Day-to-night
/// loop (`0.0`-`1.0`), independent of [_ReflectEnvironmentState]'s own
/// Lottie playback controller only in the sense that it's *driven by* that
/// controller's value rather than by Focus progress — see this file's
/// module doc. Phases approximate the composition's day → sunset → dusk →
/// night → (loop) visual timeline; interpolated with [Color.lerp] so nothing
/// snaps at phase boundaries, including the wraparound back to phase 0 at
/// the loop point (night's color/intensity meets day's start-of-cycle
/// value, avoiding a flash).
class _GlowPhase {
  const _GlowPhase({
    required this.color,
    required this.opacity,
    required this.blurRadius,
    required this.spreadRadius,
  });

  final Color color;
  final double opacity;
  final double blurRadius;
  final double spreadRadius;

  static const _day = Color(0xFFFFC873);
  static const _sunset = Color(0xFFFF8A5C);
  static const _dusk = Color(0xFF9B6BFF);
  static const _night = Color(0xFF4A5AD6);

  static const _stops = [0.0, 0.28, 0.55, 0.8, 1.0];
  static const _colors = [_day, _sunset, _dusk, _night, _day];
  static const _opacities = [0.35, 0.45, 0.4, 0.3, 0.35];
  static const _blurs = [36.0, 46.0, 40.0, 32.0, 36.0];
  static const _spreads = [2.0, 4.0, 3.0, 1.0, 2.0];

  static _GlowPhase at(double t) {
    final clamped = t.clamp(0.0, 1.0);
    var segment = 0;
    for (var i = 0; i < _stops.length - 1; i++) {
      if (clamped >= _stops[i] && clamped <= _stops[i + 1]) {
        segment = i;
        break;
      }
    }
    final segStart = _stops[segment];
    final segEnd = _stops[segment + 1];
    final localT = segEnd > segStart
        ? ((clamped - segStart) / (segEnd - segStart)).clamp(0.0, 1.0)
        : 0.0;

    double lerpD(List<double> values) =>
        _lerpDouble(values[segment], values[segment + 1], localT);

    return _GlowPhase(
      color: Color.lerp(_colors[segment], _colors[segment + 1], localT) ?? _day,
      opacity: lerpD(_opacities),
      blurRadius: lerpD(_blurs),
      spreadRadius: lerpD(_spreads),
    );
  }
}

double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

/// Bottom-anchored transparent-to-dark gradient so the timer/controls
/// painted above this widget (by `FocusScreen`) stay legible regardless of
/// which stage's photo/Lottie is currently showing, without wrapping every
/// piece of text in its own opaque card.
class _ReadabilityScrim extends StatelessWidget {
  const _ReadabilityScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.45, 0.72, 1],
          colors: [
            Color(0x66000000),
            Color(0x00000000),
            Color(0xCC000000),
            Color(0xEE000000),
          ],
        ),
      ),
    );
  }
}
