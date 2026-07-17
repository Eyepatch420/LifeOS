import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
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

  testWidgets('tapping Mark Done toggles completed state', (tester) async {
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

  testWidgets('tapping delete removes the reminder and pops', (tester) async {
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

    final reminder = await repository.getById('r1');
    expect(reminder, isNull);
  });
}
