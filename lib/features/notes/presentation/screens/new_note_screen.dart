import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/notes/domain/models/create_note_request.dart';
import 'package:lifeos/features/notes/presentation/providers/note_providers.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

class NewNoteScreen extends ConsumerStatefulWidget {
  const NewNoteScreen({super.key});

  @override
  ConsumerState<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends ConsumerState<NewNoteScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(noteRequestsProvider.notifier)
        .addNote(
          CreateNoteRequest(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
            createdAt: DateTime.now(),
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Note'),
      content: FadeSlideIn(
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
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
      ctaButton: PrimaryButton(
        label: 'Save Note',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
