import 'package:flutter/material.dart';

/// Carries color values beyond what [ColorScheme] covers — gradients, FAB,
/// selected-chip color, and chart palette. Implements a real [lerp] so
/// workspace switches interpolate smoothly (driven by the root
/// [AnimatedTheme]) instead of snapping.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.heroGradient,
    required this.fabColor,
    required this.chipSelectedColor,
    required this.chartPalette,
  });

  final List<Color> heroGradient;
  final Color fabColor;
  final Color chipSelectedColor;
  final List<Color> chartPalette;

  @override
  AppColorsExtension copyWith({
    List<Color>? heroGradient,
    Color? fabColor,
    Color? chipSelectedColor,
    List<Color>? chartPalette,
  }) {
    return AppColorsExtension(
      heroGradient: heroGradient ?? this.heroGradient,
      fabColor: fabColor ?? this.fabColor,
      chipSelectedColor: chipSelectedColor ?? this.chipSelectedColor,
      chartPalette: chartPalette ?? this.chartPalette,
    );
  }

  @override
  AppColorsExtension lerp(covariant AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      heroGradient: _lerpColorList(heroGradient, other.heroGradient, t),
      fabColor: Color.lerp(fabColor, other.fabColor, t) ?? fabColor,
      chipSelectedColor:
          Color.lerp(chipSelectedColor, other.chipSelectedColor, t) ??
          chipSelectedColor,
      chartPalette: _lerpColorList(chartPalette, other.chartPalette, t),
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return [for (var i = 0; i < length; i++) Color.lerp(a[i], b[i], t) ?? a[i]];
  }
}
