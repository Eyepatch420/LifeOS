import 'package:flutter/animation.dart';

/// Named curves. Everything animated in the app pulls its curve from here.
abstract final class AppCurves {
  /// Primary curve for nearly all transitions — decelerates smoothly,
  /// reads as "premium" rather than mechanical.
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Slightly springier feel for the bottom nav pill sliding between tabs.
  static const Curve navPill = Curves.easeOutBack;

  /// Emphasized deceleration for large-scale transitions (page changes).
  static const Curve emphasizedDecelerate = Curves.easeOutExpo;
}
