import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/mood/domain/entities/mood_level.dart';
import 'package:lifeos/features/mood/presentation/providers/mood_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// The Mood logging flow — a level picker plus an optional note. Mirrors
/// `NewHabitScreen`'s validation-preserves-input pattern.
class LogMoodScreen extends ConsumerStatefulWidget {
  const LogMoodScreen({super.key});

  @override
  ConsumerState<LogMoodScreen> createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends ConsumerState<LogMoodScreen> {
  final _noteController = TextEditingController();
  MoodLevel? _selectedLevel;
  String? _levelError;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final level = _selectedLevel;
    if (level == null) {
      setState(() => _levelError = 'Choose how you\'re feeling');
      return;
    }

    setState(() => _isSaving = true);
    final note = _noteController.text.trim();
    await ref
        .read(moodRepositoryProvider)
        .log(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          level: level,
          note: note.isEmpty ? null : note,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Log Mood'),
      content: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('How are you feeling?', style: context.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              label: 'Mood level',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final level in MoodLevel.values)
                    ChoiceChip(
                      label: Text('${level.emoji} ${level.label}'),
                      selected: _selectedLevel == level,
                      onSelected: (_) => setState(() {
                        _selectedLevel = level;
                        _levelError = null;
                      }),
                    ),
                ],
              ),
            ),
            if (_levelError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _levelError!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              textField: true,
              label: 'Note',
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'What\'s on your mind?',
                ),
              ),
            ),
          ],
        ),
      ),
      ctaButton: PrimaryButton(
        label: 'Save',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
