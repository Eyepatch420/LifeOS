import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// The real Calendar event creation flow — same validation-preserves-input
/// pattern as `NewReminderScreen`/`NewHabitScreen`. [initialDate] (passed
/// via `state.extra` from the Calendar dashboard's "Add Event" action,
/// mirroring `NewReminderScreen.initialDate`) seeds the date field with
/// whatever day was selected, so adding an event from a specific day
/// doesn't default to today.
class NewEventScreen extends ConsumerStatefulWidget {
  const NewEventScreen({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  ConsumerState<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends ConsumerState<NewEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _date;
  bool _isAllDay = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? _endTime;
  String? _titleError;
  String? _timeError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _date = dateOnly(widget.initialDate ?? DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = dateOnly(picked));
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        _timeError = null;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
        _timeError = null;
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final startAt = _isAllDay ? _date : _combine(_date, _startTime);
    final endAt = _endTime == null || _isAllDay
        ? (_isAllDay && _endTime != null ? _date : null)
        : _combine(_date, _endTime!);

    setState(() {
      _titleError = title.isEmpty ? 'Title is required' : null;
      _timeError = (!_isAllDay && endAt != null && !endAt.isAfter(startAt))
          ? 'End time must be after start time'
          : null;
    });
    if (_titleError != null || _timeError != null) return;

    setState(() => _isSaving = true);
    final description = _descriptionController.text.trim();

    await ref
        .read(eventsRepositoryProvider)
        .create(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          startAt: startAt,
          endAt: endAt,
          isAllDay: _isAllDay,
          description: description.isEmpty ? null : description,
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Event'),
      content: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              textField: true,
              label: 'Event title',
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
            const SizedBox(height: AppSpacing.md),
            Semantics(
              textField: true,
              label: 'Event description',
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              button: true,
              label: 'Event date',
              child: InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(DateFormat('EEEE, d MMMM yyyy').format(_date)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('All day'),
              value: _isAllDay,
              onChanged: (value) => setState(() => _isAllDay = value),
            ),
            if (!_isAllDay) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: 'Start time',
                      child: InkWell(
                        onTap: _pickStartTime,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start time',
                          ),
                          child: Text(_startTime.format(context)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: 'End time',
                      child: InkWell(
                        onTap: _pickEndTime,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End time (optional)',
                          ),
                          child: Text(_endTime?.format(context) ?? '—'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_timeError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _timeError!,
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
        label: 'Save Event',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
