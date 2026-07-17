import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/finance/domain/models/create_expense_request.dart';
import 'package:lifeos/features/finance/presentation/providers/expense_providers.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('expenseRequestsProvider starts empty', () async {
    final container = makeContainer();
    expect(await container.read(expenseRequestsProvider.future), isEmpty);
  });

  test('addExpense appends to the list', () async {
    final container = makeContainer();
    await container.read(expenseRequestsProvider.future);

    final expense = CreateExpenseRequest(
      id: '1',
      title: 'Coffee',
      amount: 4.5,
      category: 'Food',
    );
    await container.read(expenseRequestsProvider.notifier).addExpense(expense);

    expect(container.read(expenseRequestsProvider).value, [expense]);
  });
}
