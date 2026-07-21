import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';

part 'reminder.freezed.dart';

/// A persisted reminder. This is the feature's own domain entity, distinct
/// from [CreateReminderRequest] (the form payload) and the Drift `Reminder`
/// data class (the row shape) — [RemindersRepository] is the only place
/// that maps between them.
///
/// [recurrence]/[customRule] support the full recurrence taxonomy from day
/// one even though `NewReminderScreen` only exposes a None/Daily toggle —
/// see [RecurrenceRule]'s doc comment.
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String title,
    required DateTime dueAt,
    required bool isUrgent,
    required bool isCompleted,
    required RecurrenceRule recurrence,
    @Default(ReminderCategory.other) ReminderCategory category,
    DateTime? completedAt,
    String? customRule,
  }) = _Reminder;
}
