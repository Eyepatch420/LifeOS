import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_note_request.freezed.dart';

/// Payload submitted from `NewNoteScreen`'s form. Mock-backed for now (see
/// `note_providers.dart`) — swapping in a real repository later is a
/// `build()`-body-only change, same seam as the 7 Home dashboard sections.
@freezed
abstract class CreateNoteRequest with _$CreateNoteRequest {
  const factory CreateNoteRequest({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
  }) = _CreateNoteRequest;
}
