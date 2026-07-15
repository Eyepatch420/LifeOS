/// Named spacing/sizing tokens. Never use a raw `EdgeInsets`/size literal in
/// feature code — pull from here so spacing stays consistent and easy to
/// retune app-wide. Mirrors the naming convention of `AppDurations`/`AppCurves`.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  static const double radiusSm = 10;
  static const double radiusMd = 12;
  static const double radiusLg = 18;
  static const double radiusXl = 20;

  /// Icon box used by list-tile-style rows (Up Next, Habit Streaks, Recent
  /// Notes, My Lists).
  static const double tileIconBoxSize = 36;

  /// Hero's search/notification icon buttons.
  static const double heroIconButtonSize = 44;

  /// Quick Actions circular button.
  static const double quickActionButtonSize = 52;

  /// Quick Actions label max width (keeps 2-line labels from overflowing).
  static const double quickActionLabelWidth = 72;

  /// Habit streak week-dot diameter.
  static const double streakDotSize = 8;

  /// Timeline connector dot diameter.
  static const double timelineDotSize = 10;
}
