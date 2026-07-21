/// A logged mood's intensity bucket. Stored as [name] (the enum name, e.g.
/// 'good') in `MoodEntries.moodLevel` — never a presentation string, so the
/// UI owns label/icon/color for a given level.
enum MoodLevel {
  veryBad,
  bad,
  neutral,
  good,
  great;

  String get storageKey => name;

  static MoodLevel fromStorageKey(String key) {
    return MoodLevel.values.firstWhere(
      (level) => level.storageKey == key,
      orElse: () => MoodLevel.neutral,
    );
  }
}

/// Presentation strings for each level — the single place both the Mood
/// feature's own UI and its dashboard-summary mapping (never Home directly,
/// see `MoodDashboardSummary`'s doc comment) resolve a [MoodLevel] into
/// something displayable.
extension MoodLevelPresentation on MoodLevel {
  String get label => switch (this) {
    MoodLevel.veryBad => 'Very Bad',
    MoodLevel.bad => 'Bad',
    MoodLevel.neutral => 'Neutral',
    MoodLevel.good => 'Good',
    MoodLevel.great => 'Great',
  };

  String get emoji => switch (this) {
    MoodLevel.veryBad => '😞',
    MoodLevel.bad => '🙁',
    MoodLevel.neutral => '😐',
    MoodLevel.good => '🙂',
    MoodLevel.great => '😄',
  };
}
