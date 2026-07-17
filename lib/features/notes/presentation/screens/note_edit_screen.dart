import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/notes/domain/entities/note.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  const NoteEditScreen({required this.noteId, super.key});

  final String noteId;

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _initializeFrom(Note note) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = note.title;
    _bodyController.text = note.body;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(notesRepositoryProvider)
        .update(
          id: widget.noteId,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(notesRepositoryProvider);

    return StreamBuilder<List<Note>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final notes = snapshot.data;
        final note = notes?.where((n) => n.id == widget.noteId).firstOrNull;

        if (note != null) _initializeFrom(note);

        return PushedScreenLayout(
          header: const PushedScreenHeader(title: 'Edit Note'),
          content: note == null
              ? (notes == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.note_alt_outlined,
                        message: 'This note no longer exists',
                      ))
              : FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Expanded(
                        child: TextField(
                          controller: _bodyController,
                          decoration: const InputDecoration(
                            labelText: 'Note (markdown supported)',
                          ),
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                    ],
                  ),
                ),
          ctaButton: note == null
              ? null
              : PrimaryButton(
                  label: 'Save Changes',
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
        );
      },
    );
  }
}
