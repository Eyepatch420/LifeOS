/// The four greeting/tint buckets used by the Home hero section.
enum TimeOfDayBucket { morning, afternoon, evening, night }

extension TimeOfDayExtensions on DateTime {
  /// Buckets this [DateTime]'s hour into a [TimeOfDayBucket]:
  /// 5–11 morning, 12–16 afternoon, 17–20 evening, otherwise night.
  TimeOfDayBucket get timeOfDayBucket {
    if (hour >= 5 && hour < 12) return TimeOfDayBucket.morning;
    if (hour >= 12 && hour < 17) return TimeOfDayBucket.afternoon;
    if (hour >= 17 && hour < 21) return TimeOfDayBucket.evening;
    return TimeOfDayBucket.night;
  }
}

extension TimeOfDayBucketGreeting on TimeOfDayBucket {
  String get greeting => switch (this) {
    TimeOfDayBucket.morning => 'Good morning',
    TimeOfDayBucket.afternoon => 'Good afternoon',
    TimeOfDayBucket.evening => 'Good evening',
    TimeOfDayBucket.night => 'Good night',
  };
}

extension LocalDateKey on DateTime {
  /// This date's `yyyy-MM-dd` key in local time — the canonical day
  /// boundary used everywhere a feature needs "today" as an id (habit
  /// completions, mood entries, per-day dismissals), so every feature
  /// agrees on where midnight falls instead of mixing local/UTC cutoffs.
  String get localDateKey {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
