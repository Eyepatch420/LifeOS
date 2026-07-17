import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/notes/domain/entities/note.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Sort order for the notes list — pinned-first is the default (matches
/// the Home dashboard summary), but a full list benefits from an explicit
/// "most recent" toggle too since pinned notes may be few or none.
enum _NotesSort { pinnedFirst, recent }

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  _NotesSort _sort = _NotesSort.pinnedFirst;
  final _filterController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  List<Note> _sorted(List<Note> notes) {
    final filtered = _filter.isEmpty
        ? notes
        : notes
              .where(
                (n) =>
                    n.title.toLowerCase().contains(_filter) ||
                    n.body.toLowerCase().contains(_filter),
              )
              .toList();
    final sorted = [...filtered];
    switch (_sort) {
      case _NotesSort.pinnedFirst:
        sorted.sort((a, b) {
          if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
          return b.updatedAt.compareTo(a.updatedAt);
        });
      case _NotesSort.recent:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    return sorted;
  }

  Future<void> _deleteWithUndo(Note note) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.delete(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${note.title.isEmpty ? '(Untitled)' : note.title}" deleted',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => repository.restore(note.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(notesRepositoryProvider);
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Notes'),
      content: StreamBuilder<List<Note>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          final notes = snapshot.data;
          if (notes == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notes.isEmpty) {
            return const EmptyState(
              icon: Icons.note_alt_outlined,
              message: 'No notes yet',
            );
          }
          final visible = _sorted(notes);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  labelText: 'Filter notes',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) =>
                    setState(() => _filter = value.trim().toLowerCase()),
              ),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<_NotesSort>(
                segments: const [
                  ButtonSegment(
                    value: _NotesSort.pinnedFirst,
                    label: Text('Pinned first'),
                  ),
                  ButtonSegment(
                    value: _NotesSort.recent,
                    label: Text('Most recent'),
                  ),
                ],
                selected: {_sort},
                onSelectionChanged: (selection) =>
                    setState(() => _sort = selection.first),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        message: 'No notes match your filter',
                      )
                    : StaggeredEntrance(
                        children: [
                          for (final note in visible)
                            _NoteListTile(
                              note: note,
                              onTogglePin: () =>
                                  repository.setPinned(note.id, !note.isPinned),
                              onDismissed: () => _deleteWithUndo(note),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoteListTile extends StatelessWidget {
  const _NoteListTile({
    required this.note,
    required this.onTogglePin,
    required this.onDismissed,
  });

  final Note note;
  final VoidCallback onTogglePin;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      resizeDuration: AppMotionPresets.cardExit.duration,
      movementDuration: AppMotionPresets.cardExit.duration,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          Icons.delete_outline,
          color: context.colorScheme.onErrorContainer,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: 0,
        ),
        leading: Icon(
          Icons.note_alt_outlined,
          color: context.colorScheme.primary,
        ),
        title: Text(
          note.title.isEmpty ? '(Untitled)' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(note.body, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: Icon(
            note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            size: 20,
            color: note.isPinned ? context.colorScheme.primary : null,
          ),
          onPressed: onTogglePin,
        ),
        onTap: () => context.pushNamed(
          RouteNames.noteDetail,
          pathParameters: {'noteId': note.id},
        ),
      ),
    );
  }
}
