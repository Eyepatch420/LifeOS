/// App-wide, non-theme, non-animation constants.
abstract final class AppConstants {
  static const String appName = 'LifeOS';
  static const String appTagline = 'Your life, organized.';

  /// Splash screen minimum hold time before navigating away, so the
  /// animation always gets to play out even on a fast cold start.
  static const Duration splashMinimumDuration = Duration(milliseconds: 2200);
}
