import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/reminders/domain/models/create_reminder_request.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminder_providers.dart';

void main() {
  ProviderContainer makeContainer() {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    return container;
  }

  test('reminderRequestsProvider starts empty', () async {
    final container = makeContainer();
    expect(await container.read(reminderRequestsProvider.future), isEmpty);
  });

  test(
    'addReminder appends to the list and persists via RemindersRepository',
    () async {
      final container = makeContainer();
      await container.read(reminderRequestsProvider.future);

      final reminder = CreateReminderRequest(
        id: '1',
        title: 'Pay rent',
        dueAt: DateTime(2026, 1, 1),
        isUrgent: true,
      );
      await container
          .read(reminderRequestsProvider.notifier)
          .addReminder(reminder);

      expect(container.read(reminderRequestsProvider).value, [reminder]);
    },
  );
}
