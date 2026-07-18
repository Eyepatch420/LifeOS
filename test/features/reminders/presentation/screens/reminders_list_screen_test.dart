import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/features/reminders/presentation/screens/reminders_list_screen.dart';

void main() {
  Future<ProviderContainer> pump(WidgetTester tester) async {
    // closeStreamsSynchronously avoids a pending zero-duration Timer when a
    // QueryStream detaches on widget disposal — matches
    // notes_list_screen_test.dart's rationale.
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    late ProviderContainer container;
    final router = GoRouter(
      initialLocation: '/reminders',
      routes: [
        GoRoute(
          path: '/reminders',
          builder: (context, state) => const RemindersListScreen(),
        ),
        GoRoute(
          path: '/new-reminder',
          name: RouteNames.newReminder,
          builder: (context, state) =>
              const Scaffold(body: Text('New Reminder')),
        ),
        GoRoute(
          path: '/reminder-detail/:reminderId',
          name: RouteNames.reminderDetail,
          builder: (context, state) => Scaffold(
            body: Text('Reminder ${state.pathParameters['reminderId']}'),
          ),
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
    return container;
  }

  testWidgets('shows empty state when no reminders exist', (tester) async {
    await pump(tester);
    await tester.pump();

    expect(find.text('No reminders yet'), findsOneWidget);
  });

  testWidgets('renders a tile per reminder, soonest first', (tester) async {
    final container = await pump(tester);
    final sub = container.listen(remindersRepositoryProvider, (_, _) {});
    addTearDown(sub.close);

    final repository = container.read(remindersRepositoryProvider);
    await repository.create(
      id: 'r1',
      title: 'Later task',
      dueAt: DateTime(2026, 1, 2),
      isUrgent: false,
    );
    await repository.create(
      id: 'r2',
      title: 'Sooner task',
      dueAt: DateTime(2026, 1, 1),
      isUrgent: false,
    );
    await tester.pumpAndSettle();

    expect(find.text('Later task'), findsOneWidget);
    expect(find.text('Sooner task'), findsOneWidget);
  });

  testWidgets('tapping the completion icon toggles completed state', (
    tester,
  ) async {
    final container = await pump(tester);
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

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isTrue);
  });

  testWidgets('the empty state offers an Add Reminder CTA that opens '
      'NewReminderScreen', (tester) async {
    await pump(tester);
    await tester.pump();

    await tester.tap(find.text('Add Reminder'));
    await tester.pumpAndSettle();

    expect(find.text('New Reminder'), findsOneWidget);
  });

  testWidgets('the app bar + icon opens NewReminderScreen', (tester) async {
    await pump(tester);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New Reminder'), findsOneWidget);
  });

  testWidgets('tapping a tile opens ReminderDetailScreen for that reminder', (
    tester,
  ) async {
    final container = await pump(tester);
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

    await tester.tap(find.text('Pay rent'));
    await tester.pumpAndSettle();

    expect(find.text('Reminder r1'), findsOneWidget);
  });

  testWidgets('a recurring reminder shows a repeat indicator', (tester) async {
    final container = await pump(tester);
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

    expect(find.byIcon(Icons.repeat), findsOneWidget);
  });

  testWidgets('completing a recurring reminder shows a snackbar naming the '
      'next occurrence and the reminder stays in the list (not removed, '
      'not permanently completed)', (tester) async {
    final container = await pump(tester);
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

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pump();

    expect(find.textContaining('Next reminder:'), findsOneWidget);
    expect(find.text('Take medicine'), findsOneWidget);

    final reminder = await repository.getById('r1');
    expect(reminder!.isCompleted, isFalse);
    expect(reminder.dueAt, DateTime(2026, 6, 16, 9));
  });

  testWidgets('completing a non-recurring reminder shows a plain '
      'confirmation snackbar', (tester) async {
    final container = await pump(tester);
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

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pump();

    expect(find.text('Reminder completed'), findsOneWidget);
  });
}
