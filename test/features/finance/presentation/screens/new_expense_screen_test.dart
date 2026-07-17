import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/features/finance/presentation/providers/expense_providers.dart';
import 'package:lifeos/features/finance/presentation/screens/new_expense_screen.dart';

void main() {
  testWidgets('renders title/amount fields, category dropdown, and a Save '
      'Expense CTA', (tester) async {
    final router = GoRouter(
      initialLocation: '/expense',
      routes: [
        GoRoute(
          path: '/expense',
          builder: (context, state) => const NewExpenseScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump();

    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Amount'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.text('Save Expense'), findsOneWidget);
  });

  testWidgets('saving adds an expense and pops', (tester) async {
    late ProviderContainer container;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/expense',
          builder: (context, state) => const NewExpenseScreen(),
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
    final sub = container.listen(expenseRequestsProvider, (_, _) {});
    addTearDown(sub.close);

    router.push('/expense');
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Coffee');
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '4.5');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();

    final expenses = container.read(expenseRequestsProvider).value;
    expect(expenses?.length, 1);
    expect(expenses?.first.amount, 4.5);
  });
}
