import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:lifeos/features/reminders/presentation/screens/new_reminder_screen.dart';

void main() {
  testWidgets('renders title field, due tile, urgent toggle, and a Save '
      'Reminder CTA', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final router = GoRouter(
      initialLocation: '/reminder',
      routes: [
        GoRoute(
          path: '/reminder',
          builder: (context, state) => const NewReminderScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.text('Due'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
    expect(find.text('Repeat daily'), findsOneWidget);
    expect(find.text('Save Reminder'), findsOneWidget);
  });

  testWidgets('saving adds a reminder and pops', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/reminder',
          builder: (context, state) => const NewReminderScreen(),
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

    // See new_note_screen_test.dart for why this listener is held open —
    // Riverpod 3.x defaults every provider to auto-dispose, so a plain
    // container.read() after the screen pops (and its ref stops listening)
    // would race the provider's own disposal.
    final sub = container.listen(reminderRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    router.push('/reminder');
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Test');
    await tester.tap(find.text('Save Reminder'));
    await tester.pumpAndSettle();

    expect(container.read(reminderRequestsProvider).value?.length, 1);
  });
}
