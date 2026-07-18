import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';

part 'habit.freezed.dart';

/// A persisted habit. This is the feature's own domain entity, distinct
/// from the Drift `Habit` row shape — [HabitsRepository] is the only place
/// that maps between them, mirroring `Reminder`/`RemindersRepository`'s
/// split.
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    required HabitSchedule schedule,
    required String icon,
    required DateTime createdAt,
    DateTime? archivedAt,
  }) = _Habit;
}

extension HabitActive on Habit {
  bool get isActive => archivedAt == null;
}
