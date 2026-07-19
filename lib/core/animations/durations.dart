/// Named animation durations. Never use a raw `Duration(milliseconds: ...)`
/// literal in feature code — pull from here so timing stays consistent and
/// easy to retune app-wide.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);
  static const Duration page = Duration(milliseconds: 500);

  /// Focus session visual-stage crossfades (Lottie + background atmosphere)
  /// — deliberately slower than [slow], since these should read as the
  /// environment gradually evolving, not a UI state change.
  static const Duration focusStage = Duration(milliseconds: 1400);
}
