import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';

part 'mood_entry.freezed.dart';

/// A single logged mood entry. This is the feature's own domain entity,
/// distinct from the Drift `MoodEntry` row shape — [MoodRepository] is the
/// only place that maps between them, mirroring `Habit`/`HabitsRepository`'s
/// split. Append-only: multiple entries may share the same local day.
@freezed
abstract class MoodEntry with _$MoodEntry {
  const factory MoodEntry({
    required String id,
    required MoodLevel level,
    String? note,
    required DateTime recordedAt,
    required DateTime createdAt,
  }) = _MoodEntry;
}
