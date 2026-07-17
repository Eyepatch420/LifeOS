import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_expense_request.freezed.dart';

/// Payload submitted from `NewExpenseScreen`'s form. Mock-backed for now
/// (see `expense_providers.dart`) — swapping in a real repository later is
/// a `build()`-body-only change, same seam as the 7 Home dashboard sections.
@freezed
abstract class CreateExpenseRequest with _$CreateExpenseRequest {
  const factory CreateExpenseRequest({
    required String id,
    required String title,
    required double amount,
    required String category,
  }) = _CreateExpenseRequest;
}
