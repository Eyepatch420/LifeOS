import 'package:flutter/animation.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';

/// A named (duration, curve) pair for one interaction category. Composes
/// [AppDurations]/[AppCurves] — it does not invent new timing values unless
/// a category genuinely needs one. Widgets should reference a preset here
/// instead of inlining duration/curve literals, so future modules reuse the
/// same named motion instead of re-deriving it.
class MotionPreset {
  const MotionPreset(this.duration, this.curve);

  final Duration duration;
  final Curve curve;
}

/// Catalogue of reusable motion presets by interaction category.
abstract final class AppMotionPresets {
  /// Top-level route changes (splash/onboarding/user-setup/home hops).
  static const MotionPreset pageEnter = MotionPreset(
    AppDurations.page,
    AppCurves.easeOutCubic,
  );

  /// Card/section entrance (see `StaggeredEntrance`/`FadeSlideIn`).
  static const MotionPreset cardEnter = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Card/section exit — mirrors [cardEnter] timing so removal doesn't feel
  /// abrupt relative to how the card arrived.
  static const MotionPreset cardExit = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Floating action button state changes (scale/color morph).
  static const MotionPreset fab = MotionPreset(
    AppDurations.fast,
    AppCurves.easeOutCubic,
  );

  /// Button press/release/hover/loading/disabled crossfades.
  static const MotionPreset button = MotionPreset(
    AppDurations.fast,
    AppCurves.easeOutCubic,
  );

  /// Hero header content changes (time-of-day tint, greeting swap).
  static const MotionPreset hero = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Bottom nav pill slide + icon morph.
  static const MotionPreset bottomNav = MotionPreset(
    AppDurations.medium,
    AppCurves.navPill,
  );

  /// Generic section header/content reveal (non-card sections).
  static const MotionPreset section = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Timeline step reveal/progress.
  static const MotionPreset timeline = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Dialog show/hide.
  static const MotionPreset dialog = MotionPreset(
    AppDurations.medium,
    AppCurves.easeOutCubic,
  );

  /// Focus session visual-stage crossfade (Lottie + background atmosphere
  /// transitioning as session progress advances) — see
  /// `AppDurations.focusStage`'s doc comment.
  static const MotionPreset focusStage = MotionPreset(
    AppDurations.focusStage,
    AppCurves.easeOutCubic,
  );

  /// Bottom sheet show/hide.
  static const MotionPreset bottomSheet = MotionPreset(
    AppDurations.slow,
    AppCurves.easeOutCubic,
  );

  /// Onboarding illustration/text hand-off transition — the one category
  /// with a duration wider than the standard `medium`/`slow` presets,
  /// justified by the "passing one object to another" full-exit choreography
  /// (see docs/animation_spec.md).
  static const MotionPreset onboardingIllustration = MotionPreset(
    Duration(milliseconds: 500),
    AppCurves.easeOutCubic,
  );
}
