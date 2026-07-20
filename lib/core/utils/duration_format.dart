/// Human-readable duration formatting shared across features that display
/// Focus/time-tracking durations (e.g. "1 hr 30 min" instead of raw
/// "90 minutes") — a single place so every screen renders the same style.
extension DurationFormat on Duration {
  /// `"45 min"`, `"1 hr"`, `"1 hr 30 min"`. Never shows minutes as `"0 min"`
  /// once there's a whole hour (`"2 hr"`, not `"2 hr 0 min"`).
  String get toShortLabel {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    if (hours == 0) return '$minutes min';
    if (minutes == 0) return '$hours hr';
    return '$hours hr $minutes min';
  }
}
