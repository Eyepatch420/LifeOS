import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';

part 'create_reminder_request.freezed.dart';

/// Payload submitted from `NewReminderScreen`'s form. Persisted via
/// `RemindersRepository` (see `reminder_providers.dart`).
@freezed
abstract class CreateReminderRequest with _$CreateReminderRequest {
  const factory CreateReminderRequest({
    required String id,
    required String title,
    required DateTime dueAt,
    required bool isUrgent,
    @Default(RecurrenceRule.none) RecurrenceRule recurrence,
  }) = _CreateReminderRequest;
}
