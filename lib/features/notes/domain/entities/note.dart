import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

/// A persisted note. `body` is plain markdown text — rendered read-only in
/// the detail screen via `flutter_markdown_plus`, edited as plain text
/// (no rich-text delta format). This is the feature's own domain entity,
/// distinct from [CreateNoteRequest] (the form payload) and from the Drift
/// `Note` data class (the row shape) — [NotesRepository] is the only place
/// that maps between them.
@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isPinned,
  }) = _Note;
}
