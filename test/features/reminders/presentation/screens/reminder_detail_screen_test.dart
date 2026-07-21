import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminder_detail_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester, String reminderId) async {
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    late ProviderContainer container;
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/reminder',
          builder: (context, state) =>
              ReminderDetailScreen(reminderId: reminderId),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();
    router.push('/reminder');
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows EmptyState fallback for an unknown reminder id', (
    tester,
  ) async {
    await pump(tester, 'missing');
    await tester.pump();

    expect(find.text('This reminder no longer exists'), findsOneWidget);
  });

  testWidgets('renders the reminder title and due date', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Pay rent',
          dueAt: DateTime(2026, 1, 1),
          isUrgent: false,
        );
    await tester.pumpAndSettle();

    expect(find.text('Pay rent'), findsWidgets);
  });

  testWidgets('renders a human-readable repeat label for a recurring '
      'reminder, not the raw enum name', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Take medicine',
          dueAt: DateTime(2026, 1, 1),
          isUrgent: false,
          recurrence: RecurrenceRule.daily,
        );
    await tester.pumpAndSettle();

    expect(find.text('Repeats daily'), findsOneWidget);
    expect(find.textContaining('RecurrenceRule'), findsNothing);
  });

  testWidgets('a non-recurring reminder shows no repeat label', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'One-off',
          dueAt: DateTime(2026, 1, 1),
          isUrgent: false,
        );
    await tester.pumpAndSettle();

    expect(find.textContaining('Repeats'), findsNothing);
  });

  testWidgets('renders the reminder category as a chip with its label', (
    tester,
  ) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Take medicine',
          dueAt: DateTime(2026, 1, 1),
          isUrgent: false,
          category: ReminderCategory.medicine,
        );
    await tester.pumpAndSettle();

    expect(find.text('Medicine'), findsOneWidget);
  });

  testWidgets('editing the category, saving, persists the new category', (
    tester,
  ) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
      category: ReminderCategory.other,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Bills'));
    await tester.tap(find.text('Bills'));
    await tester.pump();
    await tester.ensureVisible(find.text('Save Changes'));
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    final reminder = await repository.getById('r1');
    expect(reminder!.category, ReminderCategory.bills);
  });

  testWidgets('tapping Mark Done on a non-recurring reminder marks it '
      'completed', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark Done'));
    await tester.pumpAndSettle();

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isTrue);
  });

  testWidgets('tapping Mark Done on a recurring reminder advances it and '
      'shows a snackbar naming the next occurrence, without marking it '
      'completed', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Take medicine',
      dueAt: DateTime(2026, 6, 15, 9),
      isUrgent: false,
      recurrence: RecurrenceRule.daily,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark Done'));
    await tester.pump();

    expect(find.textContaining('Next reminder:'), findsOneWidget);

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isFalse);
    expect(reminder.dueAt, DateTime(2026, 6, 16, 9));
  });

  testWidgets('editing the title, saving, updates the reminder reactively', (
    tester,
  ) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Old title',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Edit Reminder'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'New title',
    );
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    final reminder = await repository.getById('r1');
    expect(reminder!.title, 'New title');
    expect(find.text('New title'), findsWidgets);
  });

  testWidgets('editing with a blank title shows a validation error and '
      'does not save', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Original',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Title'), '');
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    final reminder = await repository.getById('r1');
    expect(reminder!.title, 'Original');
  });

  testWidgets('Cancel while editing discards changes and returns to the '
      'read-only view', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Original',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Discarded',
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Original'), findsWidgets);
    final reminder = await repository.getById('r1');
    expect(reminder!.title, 'Original');
  });

  testWidgets('deleting requires confirmation, and confirming removes the '
      'reminder and pops', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete reminder?'), findsOneWidget);
    // Not yet deleted — confirmation is pending.
    expect(await repository.getById('r1'), isNotNull);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await repository.getById('r1'), isNull);
  });

  testWidgets('cancelling the delete confirmation dialog keeps the '
      'reminder', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Pay rent',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await repository.getById('r1'), isNotNull);
  });

  testWidgets('the delete confirmation message calls out recurring series '
      'deletion for a recurring reminder', (tester) async {
    final container = await pump(tester, 'r1');
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    await container
        .read(remindersRepositoryProvider)
        .create(
          id: 'r1',
          title: 'Take medicine',
          dueAt: DateTime(2026, 1, 1),
          isUrgent: false,
          recurrence: RecurrenceRule.daily,
        );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.textContaining('recurring reminder'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
