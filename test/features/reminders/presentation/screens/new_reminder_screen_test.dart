import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/new_reminder_screen.dart';

void main() {
  Future<ProviderContainer> pump(
    WidgetTester tester, {
    DateTime? initialDate,
  }) async {
    // closeStreamsSynchronously avoids a pending zero-duration Timer when a
    // QueryStream detaches on widget disposal — matches
    // reminders_dashboard_screen_test.dart/reminders_list_screen_test.dart's
    // rationale; without it, a lingering detach Timer from this file's own
    // `repository.watchAll().first` call was observed to stall the test
    // runner isolate when this file runs alongside other reminders test
    // files in the same process.
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/reminder',
          builder: (context, state) =>
              NewReminderScreen(initialDate: initialDate),
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

  testWidgets('renders title field, date/time tiles, urgent toggle, repeat '
      'chips, and a Save Reminder CTA', (tester) async {
    await pump(tester);

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
    expect(find.text('Repeat'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Weekdays'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);
    // Custom is intentionally not offered — no rule language is defined.
    expect(find.text('Custom'), findsNothing);
    expect(find.text('Save Reminder'), findsOneWidget);
  });

  testWidgets('blank title shows a validation error and does not save', (
    tester,
  ) async {
    final container = await pump(tester);
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(container.read(reminderRequestsProvider).value, isEmpty);
  });

  testWidgets('whitespace-only title is rejected the same as a blank one', (
    tester,
  ) async {
    final container = await pump(tester);
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.enterText(find.widgetWithText(TextField, 'Title'), '   ');
    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(container.read(reminderRequestsProvider).value, isEmpty);
  });

  testWidgets('selecting a recurrence chip updates the selection', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Daily'));
    await tester.pump();

    final chip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('Daily'), matching: find.byType(ChoiceChip)),
    );
    expect(chip.selected, isTrue);
  });

  testWidgets('saving with valid input adds a reminder and pops', (
    tester,
  ) async {
    final container = await pump(tester);
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Test');
    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    expect(container.read(reminderRequestsProvider).value?.length, 1);
  });

  testWidgets('the created reminder persists the selected recurrence rule', (
    tester,
  ) async {
    final container = await pump(tester);
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Take medicine',
    );
    await tester.tap(find.text('Daily'));
    await tester.pump();
    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    // A one-shot Future read (not a fresh Stream subscription) — every
    // other passing test in this file reads state this way; avoids
    // establishing a new QueryStream this late in the test.
    final createdId = container.read(reminderRequestsProvider).value!.single.id;
    final repository = container.read(remindersRepositoryProvider);
    final created = await repository.getById(createdId);
    expect(created, isNotNull);
    expect(created!.title, 'Take medicine');
    expect(created.recurrence, RecurrenceRule.daily);
  });

  testWidgets('with no initialDate, the Date tile shows today (unchanged '
      'default behavior for every existing caller)', (tester) async {
    await pump(tester);

    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('with an initialDate supplied, the Date tile starts on that '
      'date instead of today', (tester) async {
    final future = DateTime.now().add(const Duration(days: 30));
    await pump(tester, initialDate: future);

    expect(find.text('Today'), findsNothing);
  });

  testWidgets('saving with an initialDate persists a reminder on that date '
      'unless the user changed it', (tester) async {
    final future = DateTime.now().add(const Duration(days: 5));
    final futureDateOnly = DateTime(future.year, future.month, future.day);
    final container = await pump(tester, initialDate: future);
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Future task',
    );
    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    final created = container.read(reminderRequestsProvider).value!.single;
    expect(
      DateTime(created.dueAt.year, created.dueAt.month, created.dueAt.day),
      futureDateOnly,
    );
  });
}
