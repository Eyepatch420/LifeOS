import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/finance/domain/models/create_expense_request.dart';

/// Mock in-memory store — mirrors `home_providers.dart`'s `AsyncNotifier`
/// pattern so swapping in a real repository later is a `build()`-body-only
/// change; no call-site changes anywhere.
class ExpenseRequestsNotifier
    extends AsyncNotifier<List<CreateExpenseRequest>> {
  @override
  Future<List<CreateExpenseRequest>> build() async => const [];

  Future<void> addExpense(CreateExpenseRequest expense) async {
    state = AsyncData([...?state.value, expense]);
  }
}

final expenseRequestsProvider =
    AsyncNotifierProvider<ExpenseRequestsNotifier, List<CreateExpenseRequest>>(
      ExpenseRequestsNotifier.new,
    );
