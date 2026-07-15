import 'package:flutter/material.dart';

/// The per-page accent for one onboarding pillar (Planning=Blue,
/// Security=Slate, Wellness=Green) — deliberately independent from
/// [WorkspaceTheme]/[AppColorsExtension], since onboarding's visual
/// identity may diverge from workspace branding later. Scoped to
/// `features/onboarding/` rather than `shared/` per the project's widget
/// placement rule: nothing else consumes this yet.
@immutable
class OnboardingAccent {
  const OnboardingAccent({required this.primary, required this.gradient});

  final Color primary;
  final List<Color> gradient;

  /// Interpolates between two accents color-by-color — mirrors
  /// `AppColorsExtension.lerp()`'s approach so the two systems stay
  /// consistent in style even though they're intentionally separate.
  static OnboardingAccent lerp(
    OnboardingAccent a,
    OnboardingAccent b,
    double t,
  ) {
    return OnboardingAccent(
      primary: Color.lerp(a.primary, b.primary, t) ?? a.primary,
      gradient: _lerpColorList(a.gradient, b.gradient, t),
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return [for (var i = 0; i < length; i++) Color.lerp(a[i], b[i], t) ?? a[i]];
  }
}

/// A [Tween] over [OnboardingAccent] so `TweenAnimationBuilder` can drive a
/// smooth color transition between onboarding pages instead of snapping.
class OnboardingAccentTween extends Tween<OnboardingAccent> {
  OnboardingAccentTween({
    required OnboardingAccent begin,
    required OnboardingAccent end,
  }) : super(begin: begin, end: end);

  @override
  OnboardingAccent lerp(double t) => OnboardingAccent.lerp(begin!, end!, t);
}
