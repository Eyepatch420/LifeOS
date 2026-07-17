import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_habit_request.freezed.dart';

/// Payload submitted from `NewHabitScreen`'s form. Mock-backed for now (see
/// `habit_providers.dart`) — swapping in a real repository later is a
/// `build()`-body-only change, same seam as the 7 Home dashboard sections.
@freezed
abstract class CreateHabitRequest with _$CreateHabitRequest {
  const factory CreateHabitRequest({
    required String id,
    required String title,
    required String targetFrequency,
  }) = _CreateHabitRequest;
}
