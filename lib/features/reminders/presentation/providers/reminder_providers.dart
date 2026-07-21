import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/reminders/domain/models/create_reminder_request.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';

/// [CreateReminderRequest] stays the form payload `NewReminderScreen`
/// submits; `addReminder` now persists via [RemindersRepository] instead of
/// holding an in-memory list, but the notifier's public API is unchanged —
/// no call-site elsewhere needed to change for this swap (mirrors
/// `note_providers.dart`'s exact pattern).
class ReminderRequestsNotifier
    extends AsyncNotifier<List<CreateReminderRequest>> {
  @override
  Future<List<CreateReminderRequest>> build() async => const [];

  Future<void> addReminder(CreateReminderRequest reminder) async {
    await ref
        .read(remindersRepositoryProvider)
        .create(
          id: reminder.id,
          title: reminder.title,
          dueAt: reminder.dueAt,
          isUrgent: reminder.isUrgent,
          recurrence: reminder.recurrence,
          category: reminder.category,
        );
    state = AsyncData([...?state.value, reminder]);
  }
}

final reminderRequestsProvider =
    AsyncNotifierProvider<
      ReminderRequestsNotifier,
      List<CreateReminderRequest>
    >(ReminderRequestsNotifier.new);
