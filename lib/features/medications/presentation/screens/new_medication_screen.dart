import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// The Medication creation flow — name, optional dosage/instructions, and a
/// schedule (one or more times-of-day, optionally restricted to selected
/// weekdays). Mirrors `NewHabitScreen`'s validation-preserves-input pattern.
class NewMedicationScreen extends ConsumerStatefulWidget {
  const NewMedicationScreen({super.key});

  @override
  ConsumerState<NewMedicationScreen> createState() =>
      _NewMedicationScreenState();
}

class _NewMedicationScreenState extends ConsumerState<NewMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<MedicationTime> _times = [
    const MedicationTime(hour: 9, minute: 0),
  ];
  bool _isDaily = true;
  final Set<int> _selectedWeekdays = {};
  String? _nameError;
  String? _scheduleError;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null || !mounted) return;
    setState(() {
      _times.add(MedicationTime(hour: time.hour, minute: time.minute));
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = name.isEmpty ? 'Name is required' : null;
      _scheduleError = _times.isEmpty
          ? 'Add at least one time'
          : (!_isDaily && _selectedWeekdays.isEmpty)
          ? 'Choose at least one day'
          : null;
    });
    if (_nameError != null || _scheduleError != null) return;

    setState(() => _isSaving = true);
    final dosage = _dosageController.text.trim();
    final instructions = _instructionsController.text.trim();
    final schedule = MedicationSchedule(
      times: List.of(_times),
      days: _isDaily ? null : _selectedWeekdays,
    );

    await ref
        .read(medicationsRepositoryProvider)
        .create(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
          dosageText: dosage.isEmpty ? null : dosage,
          instructions: instructions.isEmpty ? null : instructions,
          schedule: schedule,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Medication'),
      content: SingleChildScrollView(
        child: FadeSlideIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                textField: true,
                label: 'Medication name',
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: _nameError,
                  ),
                  onChanged: (_) {
                    if (_nameError != null) setState(() => _nameError = null);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage (optional)',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _instructionsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Instructions (optional)',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Times', style: context.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < _times.length; i++)
                    InputChip(
                      label: Text(_times[i].storageKey),
                      onDeleted: _times.length == 1
                          ? null
                          : () => setState(() => _times.removeAt(i)),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('Add time'),
                    onPressed: _addTime,
                  ),
                ],
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
                    label: const Text('Selected days'),
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
              ],
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
          ),
        ),
      ),
      ctaButton: PrimaryButton(
        label: 'Save Medication',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
