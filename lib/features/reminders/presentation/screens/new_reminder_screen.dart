import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule_label.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder_category_label.dart';
import 'package:lifeos/features/reminders/domain/models/create_reminder_request.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Human-readable relative date label for date pickers/form summaries —
/// "Today"/"Tomorrow" for the next two days, otherwise a short weekday +
/// date. Not the same helper as the dashboard's `reminderDueLabel` (which
/// combines date+time into one line and has its own "Yesterday" case for
/// overdue items) — this one is a pure date label for a form control.
String _dateLabel(DateTime date, DateTime now) {
  final todayKey = DateTime(now.year, now.month, now.day);
  final dateKey = DateTime(date.year, date.month, date.day);
  final dayDiff = dateKey.difference(todayKey).inDays;
  if (dayDiff == 0) return 'Today';
  if (dayDiff == 1) return 'Tomorrow';
  return DateFormat('EEE, d MMM').format(date);
}

/// The form's starting `dueAt`. With no [initialDate] (every caller except
/// Planner), unchanged: now + 1 hour. With [initialDate] supplied, keeps
/// that same "an hour from now" time-of-day default but anchored onto the
/// given date instead of today — a sensible default time regardless of
/// which day was pre-selected, while leaving the date itself exactly what
/// the caller asked for. The user can still change either afterward; this
/// only sets the initial form state.
DateTime _initialDueAt(DateTime? initialDate) {
  final defaultTime = DateTime.now().add(const Duration(hours: 1));
  if (initialDate == null) return defaultTime;
  return DateTime(
    initialDate.year,
    initialDate.month,
    initialDate.day,
    defaultTime.hour,
    defaultTime.minute,
  );
}

class NewReminderScreen extends ConsumerStatefulWidget {
  const NewReminderScreen({super.key, this.initialDate});

  /// Optional pre-selected due date — e.g. Planner passing its currently
  /// selected day so "Add Reminder" from a future date doesn't silently
  /// create a reminder for today. Only the date component is taken (see
  /// `_NewReminderScreenState.initState`); the default time-of-day
  /// behavior is unchanged, and the user can still change either
  /// afterward. Every other caller (Dashboard Quick Add, Home Quick Add,
  /// the list screen's `+`) omits this and keeps the original
  /// now-plus-an-hour default.
  final DateTime? initialDate;

  @override
  ConsumerState<NewReminderScreen> createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends ConsumerState<NewReminderScreen> {
  final _titleController = TextEditingController();
  late DateTime _dueAt = _initialDueAt(widget.initialDate);
  bool _isUrgent = false;
  RecurrenceRule _recurrence = RecurrenceRule.none;
  ReminderCategory _category = ReminderCategory.other;
  bool _isSaving = false;
  String? _titleError;
  String? _saveError;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        _dueAt.hour,
        _dueAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _dueAt = DateTime(
        _dueAt.year,
        _dueAt.month,
        _dueAt.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final now = DateTime.now();

    setState(() {
      _titleError = title.isEmpty ? 'Title is required' : null;
      _saveError = null;
    });
    if (_titleError != null) return;

    // Creating a reminder in the past is rejected outright rather than
    // silently shifted — see NewReminderScreen's Phase 4 doc note on
    // past-due creation. Editing an already-overdue reminder (via
    // ReminderDetailScreen) is a separate, allowed path: that form seeds
    // its date/time pickers from the existing (possibly past) `dueAt`
    // rather than validating against `now`, so a user can move a
    // genuinely overdue reminder forward without this screen's rule
    // blocking the very meaning of "overdue".
    if (_dueAt.isBefore(now)) {
      setState(() => _saveError = 'Due date/time must be in the future');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(reminderRequestsProvider.notifier)
          .addReminder(
            CreateReminderRequest(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: title,
              dueAt: _dueAt,
              isUrgent: _isUrgent,
              recurrence: _recurrence,
              category: _category,
            ),
          );
      if (mounted) context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = "Couldn't save this reminder. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Reminder'),
      content: SingleChildScrollView(
        child: FadeSlideIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                textField: true,
                label: 'Reminder title',
                child: TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.done,
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
              Semantics(
                button: true,
                label: 'Due date, ${_dateLabel(_dueAt, now)}',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(_dateLabel(_dueAt, now)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDate,
                ),
              ),
              Semantics(
                button: true,
                label: 'Due time, ${DateFormat('h:mm a').format(_dueAt)}',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Time'),
                  subtitle: Text(DateFormat('h:mm a').format(_dueAt)),
                  trailing: const Icon(Icons.access_time_outlined),
                  onTap: _pickTime,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Urgent'),
                value: _isUrgent,
                onChanged: (value) => setState(() => _isUrgent = value),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Repeat', style: context.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: 'Repeat frequency',
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final rule in selectableRecurrenceRules)
                      ChoiceChip(
                        label: Text(recurrenceRuleLabel(rule)),
                        selected: _recurrence == rule,
                        onSelected: (_) => setState(() => _recurrence = rule),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Category', style: context.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: 'Reminder category',
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final category in ReminderCategory.values)
                      ChoiceChip(
                        avatar: Icon(reminderCategoryIcon(category), size: 18),
                        label: Text(reminderCategoryLabel(category)),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                  ],
                ),
              ),
              if (_saveError != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _saveError!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ctaButton: Semantics(
        button: true,
        label: 'Create reminder',
        child: PrimaryButton(
          label: 'Save Reminder',
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _save,
        ),
      ),
    );
  }
}
