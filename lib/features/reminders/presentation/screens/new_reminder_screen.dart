import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/models/create_reminder_request.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

class NewReminderScreen extends ConsumerStatefulWidget {
  const NewReminderScreen({super.key});

  @override
  ConsumerState<NewReminderScreen> createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends ConsumerState<NewReminderScreen> {
  final _titleController = TextEditingController();
  DateTime _dueAt = DateTime.now().add(const Duration(hours: 1));
  bool _isUrgent = false;
  bool _isSaving = false;
  // Only None/Daily are exposed here — `RecurrenceRule` supports the full
  // taxonomy (weekdays/weekly/monthly/yearly/custom) so the schema never
  // needs another migration once a richer picker is built later.
  bool _repeatsDaily = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDueAt() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (time == null) return;
    setState(() {
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(reminderRequestsProvider.notifier)
        .addReminder(
          CreateReminderRequest(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            dueAt: _dueAt,
            isUrgent: _isUrgent,
            recurrence: _repeatsDaily
                ? RecurrenceRule.daily
                : RecurrenceRule.none,
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'New Reminder'),
      content: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Due'),
              subtitle: Text(_dueAt.toString()),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDueAt,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Urgent'),
              value: _isUrgent,
              onChanged: (value) => setState(() => _isUrgent = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Repeat daily'),
              value: _repeatsDaily,
              onChanged: (value) => setState(() => _repeatsDaily = value),
            ),
          ],
        ),
      ),
      ctaButton: PrimaryButton(
        label: 'Save Reminder',
        isLoading: _isSaving,
        onPressed: _save,
      ),
    );
  }
}
