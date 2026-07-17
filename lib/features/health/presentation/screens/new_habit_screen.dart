import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/health/domain/models/create_habit_request.dart';
import 'package:lifeos/features/health/presentation/providers/habit_providers.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

const _frequencies = ['Daily', 'Weekdays', 'Weekly'];

class NewHabitScreen extends ConsumerStatefulWidget {
  const NewHabitScreen({super.key});

  @override
  ConsumerState<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends ConsumerState<NewHabitScreen> {
  final _titleController = TextEditingController();
  String _targetFrequency = _frequencies.first;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(habitRequestsProvider.notifier)
        .addHabit(
          CreateHabitRequest(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            targetFrequency: _targetFrequency,
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Habit'),
      content: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final frequency in _frequencies)
                  ChoiceChip(
                    label: Text(frequency),
                    selected: _targetFrequency == frequency,
                    onSelected: (_) =>
                        setState(() => _targetFrequency = frequency),
                  ),
              ],
            ),
          ],
        ),
      ),
      ctaButton: PrimaryButton(
        label: 'Save Habit',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
