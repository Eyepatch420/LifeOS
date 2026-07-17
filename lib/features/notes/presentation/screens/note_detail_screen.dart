import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/notes/domain/entities/note.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';
import 'package:share_plus/share_plus.dart';

/// Looks up [noteId] via a live stream rather than a one-shot read, so
/// editing/pinning elsewhere while this screen is open reflects
/// immediately — same "stale deep link falls back to EmptyState" pattern
/// `TimelineDetailScreen` established for a legitimate case: the note
/// having been deleted from another session or the list screen.
class NoteDetailScreen extends ConsumerWidget {
  const NoteDetailScreen({required this.noteId, super.key});

  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(notesRepositoryProvider);

    return StreamBuilder<List<Note>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final notes = snapshot.data;
        final note = notes?.where((n) => n.id == noteId).firstOrNull;

        return PushedScreenLayout(
          header: PushedScreenHeader(
            title: note?.title.isEmpty ?? true ? 'Note' : note!.title,
          ),
          content: note == null
              ? (notes == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.note_alt_outlined,
                        message: 'This note no longer exists',
                      ))
              : FadeSlideIn(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title.isEmpty ? '(Untitled)' : note.title,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Updated ${note.updatedAt.month}/${note.updatedAt.day}/${note.updatedAt.year}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        MarkdownBody(data: note.body),
                      ],
                    ),
                  ),
                ),
          ctaButton: note == null
              ? null
              : Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: note.isPinned ? 'Unpin' : 'Pin',
                        onPressed: () =>
                            repository.setPinned(note.id, !note.isPinned),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => context.pushNamed(
                        RouteNames.noteEdit,
                        pathParameters: {'noteId': note.id},
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () => SharePlus.instance.share(
                        ShareParams(text: '${note.title}\n\n${note.body}'),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
