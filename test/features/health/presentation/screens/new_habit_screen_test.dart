import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/features/health/presentation/providers/habit_providers.dart';
import 'package:lifeos/features/health/presentation/screens/new_habit_screen.dart';

void main() {
  testWidgets('renders title field, frequency chips, and a Save Habit CTA', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/habit',
      routes: [
        GoRoute(
          path: '/habit',
          builder: (context, state) => const NewHabitScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump();

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Weekdays'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Save Habit'), findsOneWidget);
  });

  testWidgets('saving adds a habit and pops', (tester) async {
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/habit',
          builder: (context, state) => const NewHabitScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pump();

    // See new_note_screen_test.dart for why this listener is held open.
    final sub = container.listen(habitRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    router.push('/habit');
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Drink water',
    );
    await tester.tap(find.text('Weekly'));
    await tester.pump();
    await tester.tap(find.text('Save Habit'));
    await tester.pumpAndSettle();

    final habits = container.read(habitRequestsProvider).value;
    expect(habits?.length, 1);
    expect(habits?.first.targetFrequency, 'Weekly');
  });
}
