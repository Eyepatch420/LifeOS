import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _defaultIcon = 'track_changes';

/// The real Habits creation flow — replaces the Module-3 mock
/// `NewHabitScreen` (`features/health/`, `habitRequestsProvider`, in-memory
/// only). Same validation-preserves-input pattern as `NewReminderScreen`.
class NewHabitScreen extends ConsumerStatefulWidget {
  const NewHabitScreen({super.key});

  @override
  ConsumerState<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends ConsumerState<NewHabitScreen> {
  final _titleController = TextEditingController();
  bool _isDaily = true;
  final Set<int> _selectedWeekdays = {};
  String? _titleError;
  String? _scheduleError;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    setState(() {
      _titleError = title.isEmpty ? 'Title is required' : null;
      _scheduleError = (!_isDaily && _selectedWeekdays.isEmpty)
          ? 'Choose at least one day'
          : null;
    });
    if (_titleError != null || _scheduleError != null) return;

    setState(() => _isSaving = true);
    final schedule = _isDaily
        ? const HabitSchedule.daily()
        : HabitSchedule.weekly(_selectedWeekdays);

    await ref
        .read(habitsRepositoryProvider)
        .create(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          schedule: schedule,
          icon: _defaultIcon,
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
            Semantics(
              textField: true,
              label: 'Habit title',
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorText: _titleError,
                ),
                onChanged: (_) {
                  if (_titleError != null) {
                    setState(() => _titleError = null);
                  }
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Schedule', style: context.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: const Text('Daily'),
                  selected: _isDaily,
                  onSelected: (_) => setState(() => _isDaily = true),
                ),
                ChoiceChip(
                  label: const Text('Weekly'),
                  selected: !_isDaily,
                  onSelected: (_) => setState(() => _isDaily = false),
                ),
              ],
            ),
            if (!_isDaily) ...[
              const SizedBox(height: AppSpacing.md),
              Semantics(
                label: 'Days of the week',
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (var i = 0; i < _weekdayLabels.length; i++)
                      ChoiceChip(
                        label: Text(_weekdayLabels[i]),
                        selected: _selectedWeekdays.contains(i + 1),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _selectedWeekdays.add(i + 1);
                          } else {
                            _selectedWeekdays.remove(i + 1);
                          }
                          if (_selectedWeekdays.isNotEmpty) {
                            _scheduleError = null;
                          }
                        }),
                      ),
                  ],
                ),
              ),
              if (_scheduleError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _scheduleError!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ],
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
