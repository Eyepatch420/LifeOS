import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule_label.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Looks up [reminderId] via a live stream rather than a one-shot read, so
/// completing/deleting elsewhere while this screen is open reflects
/// immediately — same "stale deep link falls back to EmptyState" pattern
/// `NoteDetailScreen`/`TimelineDetailScreen` established.
///
/// Also serves as the edit experience (toggled via the app bar's edit
/// icon) rather than a separate `EditReminderScreen` — the fields being
/// edited are exactly the fields being displayed, so a second screen would
/// only duplicate this one's layout.
class ReminderDetailScreen extends ConsumerStatefulWidget {
  const ReminderDetailScreen({required this.reminderId, super.key});

  final String reminderId;

  @override
  ConsumerState<ReminderDetailScreen> createState() =>
      _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends ConsumerState<ReminderDetailScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  String? _titleError;
  String? _saveError;

  late TextEditingController _titleController;
  late DateTime _dueAt;
  late bool _isUrgent;
  late RecurrenceRule _recurrence;

  void _startEditing(Reminder reminder) {
    _titleController = TextEditingController(text: reminder.title);
    _dueAt = reminder.dueAt;
    _isUrgent = reminder.isUrgent;
    _recurrence = reminder.recurrence;
    setState(() {
      _isEditing = true;
      _titleError = null;
      _saveError = null;
    });
  }

  void _cancelEditing() {
    _titleController.dispose();
    setState(() => _isEditing = false);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      // Editing an overdue reminder must allow moving it forward without
      // being blocked by "firstDate" excluding its own current (past)
      // date — see NewReminderScreen's doc note on past-due creation vs.
      // editing an existing overdue reminder being a distinct allowed path.
      firstDate: _dueAt.isBefore(DateTime.now())
          ? DateTime(_dueAt.year, _dueAt.month, _dueAt.day)
          : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    setState(() {
      _titleError = title.isEmpty ? 'Title is required' : null;
      _saveError = null;
    });
    if (_titleError != null) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(remindersRepositoryProvider)
          .update(
            id: widget.reminderId,
            title: title,
            dueAt: _dueAt,
            isUrgent: _isUrgent,
            recurrence: _recurrence,
          );
      if (!mounted) return;
      _titleController.dispose();
      setState(() {
        _isEditing = false;
        _isSaving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = "Couldn't save changes. Please try again.";
      });
    }
  }

  Future<void> _complete(Reminder reminder) async {
    final repository = ref.read(remindersRepositoryProvider);
    await repository.setCompleted(reminder.id, true);
    if (!context.mounted) return;

    // The single-row recurring model means "completing" a recurring
    // reminder advances it to its next occurrence rather than marking it
    // permanently done — surface that distinction so the user isn't
    // confused when the row doesn't visually end up "completed" (see
    // RemindersRepository.setCompleted's doc comment).
    final refreshed = await repository.getById(reminder.id);
    if (!mounted) return;
    final message = (refreshed != null && !refreshed.isCompleted)
        ? 'Completed. Next reminder: '
              '${DateFormat('EEE, d MMM • h:mm a').format(refreshed.dueAt)}'
        : 'Reminder completed';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmDelete(Reminder reminder) async {
    final isRecurring = reminder.recurrence != RecurrenceRule.none;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete reminder?'),
        content: Text(
          isRecurring
              ? 'This will delete this recurring reminder and all of its '
                    'future occurrences. This can\'t be undone.'
              : 'This reminder will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(remindersRepositoryProvider).delete(reminder.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(remindersRepositoryProvider);

    return StreamBuilder<List<Reminder>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final reminders = snapshot.data;
        final reminder = reminders
            ?.where((r) => r.id == widget.reminderId)
            .firstOrNull;

        return PushedScreenLayout(
          header: _buildHeader(reminder),
          content: reminder == null
              ? (reminders == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.notifications_active_outlined,
                        message: 'This reminder no longer exists',
                      ))
              : (_isEditing ? _buildEditForm() : _buildReadOnly(reminder)),
          ctaButton: reminder == null
              ? null
              : (_isEditing ? _buildEditCta() : _buildReadOnlyCta(reminder)),
        );
      },
    );
  }

  PushedScreenHeader _buildHeader(Reminder? reminder) {
    return PushedScreenHeader(
      title: _isEditing ? 'Edit Reminder' : (reminder?.title ?? 'Reminder'),
    );
  }

  Widget _buildReadOnly(Reminder reminder) {
    final repeatsLabel = recurrenceRepeatsLabel(reminder.recurrence);
    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reminder.title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Edit reminder',
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _startEditing(reminder),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Due ${DateFormat('EEEE, d MMMM yyyy • h:mm a').format(reminder.dueAt)}',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          if (repeatsLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  Icons.repeat,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  repeatsLabel,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          if (reminder.isUrgent) ...[
            const SizedBox(height: AppSpacing.sm),
            Chip(
              label: const Text('Urgent'),
              backgroundColor: context.colorScheme.errorContainer,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              textField: true,
              label: 'Reminder title',
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
            Semantics(
              button: true,
              label: 'Due date',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('EEE, d MMM yyyy').format(_dueAt)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
            ),
            Semantics(
              button: true,
              label: 'Due time',
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
    );
  }

  Widget _buildReadOnlyCta(Reminder reminder) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            label: reminder.isCompleted ? 'Mark Not Done' : 'Mark Done',
            onPressed: () => reminder.isCompleted
                ? ref
                      .read(remindersRepositoryProvider)
                      .setCompleted(reminder.id, false)
                : _complete(reminder),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Semantics(
          button: true,
          label: 'Delete reminder',
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(reminder),
          ),
        ),
      ],
    );
  }

  Widget _buildEditCta() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving ? null : _cancelEditing,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: Semantics(
            button: true,
            label: 'Save changes',
            child: PrimaryButton(
              label: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _save,
            ),
          ),
        ),
      ],
    );
  }
}
