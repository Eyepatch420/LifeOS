import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/features/notes/data/repositories/notes_repository.dart';
import 'package:lifeos/features/notes/domain/contracts/recent_notes_summary.dart';
import 'package:lifeos/features/notes/domain/entities/note.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(
    ref.watch(databaseProvider).notesDao,
    ref.watch(eventBusProvider),
  );
});

/// The Notes feature's own dashboard provider — the only thing another
/// feature (Home) is allowed to `ref.watch()`. Maps the repository's
/// [Note] stream to [RecentNotesSummary], keeping pinned notes first and
/// capping the list to the 5 most relevant, same shape Home always
/// rendered. Home never sees [Note] or [NotesRepository].
final notesDashboardProvider = StreamProvider<RecentNotesSummary>((ref) {
  return ref.watch(notesRepositoryProvider).watchAll().map((notes) {
    final sorted = [...notes]
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    return RecentNotesSummary(
      notes: [
        for (final note in sorted.take(5))
          RecentNoteSummary(
            id: note.id,
            title: note.title,
            preview: note.body,
            timestamp: _relativeTimestamp(note.updatedAt),
            isPinned: note.isPinned,
          ),
      ],
    );
  });
});

String _relativeTimestamp(DateTime updatedAt) {
  final diff = DateTime.now().difference(updatedAt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${updatedAt.month}/${updatedAt.day}/${updatedAt.year}';
}
