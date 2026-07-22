/// User-entered subjective sleep quality — not a medical "sleep score",
/// just a lightweight optional self-rating. Mirrors `MoodLevel`'s
/// storage-key pattern.
enum SleepQuality {
  poor,
  fair,
  good,
  great;

  String get storageKey => name;

  static SleepQuality fromStorageKey(String key) {
    return SleepQuality.values.firstWhere(
      (quality) => quality.storageKey == key,
      orElse: () => SleepQuality.fair,
    );
  }
}

/// Presentation strings live here, not on the enum itself — the only place
/// label text is resolved, mirroring `MoodLevelPresentation`.
extension SleepQualityPresentation on SleepQuality {
  String get label => switch (this) {
    SleepQuality.poor => 'Poor',
    SleepQuality.fair => 'Fair',
    SleepQuality.good => 'Good',
    SleepQuality.great => 'Great',
  };
}
