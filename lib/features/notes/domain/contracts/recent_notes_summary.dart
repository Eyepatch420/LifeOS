import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_notes_summary.freezed.dart';

/// One entry in the Notes feature's dashboard summary — deliberately
/// narrower than [Note] (no `body`, no markdown) since Home only ever
/// renders a preview tile. Home imports this and [RecentNotesSummary]
/// only; it never imports [Note] or `NotesRepository` — see
/// `docs/architecture_principles.md`'s Architecture Constraint 1.
@freezed
abstract class RecentNoteSummary with _$RecentNoteSummary {
  const factory RecentNoteSummary({
    required String id,
    required String title,
    required String preview,
    required String timestamp,
    required bool isPinned,
  }) = _RecentNoteSummary;
}

/// The Notes feature's full dashboard contribution — Home watches
/// `notesDashboardProvider` (which resolves to this) instead of the
/// feature's repository or entity.
@freezed
abstract class RecentNotesSummary with _$RecentNotesSummary {
  const factory RecentNotesSummary({required List<RecentNoteSummary> notes}) =
      _RecentNotesSummary;
}
