import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/calendar/domain/entities/event.dart';
import 'package:lifeos/features/calendar/presentation/providers/calendar_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Looks up [eventId] via a live stream, same "stale deep link falls back
/// to EmptyState" pattern as `ReminderDetailScreen`/`HabitDetailScreen`.
/// Also serves as the edit experience (toggled via the app bar's edit
/// icon), mirroring `HabitDetailScreen` exactly. Events have no completion
/// action — see `Event`'s doc comment and `PlannerItem.canComplete`.
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  String? _titleError;
  String? _timeError;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _date;
  late bool _isAllDay;
  late TimeOfDay _startTime;
  TimeOfDay? _endTime;

  void _startEditing(Event event) {
    _titleController = TextEditingController(text: event.title);
    _descriptionController = TextEditingController(
      text: event.description ?? '',
    );
    _date = dateOnly(event.startAt);
    _isAllDay = event.isAllDay;
    _startTime = TimeOfDay.fromDateTime(event.startAt);
    _endTime = event.endAt == null
        ? null
        : TimeOfDay.fromDateTime(event.endAt!);
    setState(() {
      _isEditing = true;
      _titleError = null;
      _timeError = null;
    });
  }

  void _cancelEditing() {
    _titleController.dispose();
    _descriptionController.dispose();
    setState(() => _isEditing = false);
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _save(Event event) async {
    final title = _titleController.text.trim();
    final startAt = _isAllDay ? _date : _combine(_date, _startTime);
    final endAt = _isAllDay
        ? (_endTime != null ? _date : null)
        : (_endTime == null ? null : _combine(_date, _endTime!));

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
        .update(
          id: event.id,
          title: title,
          startAt: startAt,
          endAt: endAt,
          isAllDay: _isAllDay,
          description: description.isEmpty ? null : description,
        );
    if (!mounted) return;
    _titleController.dispose();
    _descriptionController.dispose();
    setState(() {
      _isEditing = false;
      _isSaving = false;
    });
  }

  Future<void> _confirmDelete(Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text("This can't be undone from here."),
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

    await ref.read(eventsRepositoryProvider).delete(event.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(eventsRepositoryProvider);

    return StreamBuilder<List<Event>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final events = snapshot.data;
        final event = events?.where((e) => e.id == widget.eventId).firstOrNull;

        return PushedScreenLayout(
          header: PushedScreenHeader(
            title: _isEditing ? 'Edit Event' : (event?.title ?? 'Event'),
          ),
          content: event == null
              ? (events == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.event_busy_outlined,
                        message: 'This event no longer exists',
                      ))
              : (_isEditing ? _buildEditForm() : _buildReadOnly(event)),
          ctaButton: event == null
              ? null
              : (_isEditing ? _buildEditCta(event) : _buildReadOnlyCta(event)),
        );
      },
    );
  }

  Widget _buildReadOnly(Event event) {
    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Edit event',
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _startEditing(event),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _timeLabel(event),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(event.description!, style: context.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  String _timeLabel(Event event) {
    if (event.isAllDay) {
      return 'All day, ${DateFormat('EEE, d MMM').format(event.startAt)}';
    }
    final start = DateFormat('EEE, d MMM • h:mm a').format(event.startAt);
    final end = event.endAt;
    if (end == null) return start;
    return '$start – ${DateFormat('h:mm a').format(end)}';
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: FadeSlideIn(
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
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              button: true,
              label: 'Event date',
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = dateOnly(picked));
                },
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
                        onTap: () async {
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
                        },
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
                        onTap: () async {
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
                        },
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
    );
  }

  Widget _buildReadOnlyCta(Event event) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _confirmDelete(event),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditCta(Event event) {
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
              onPressed: _isSaving ? null : () => _save(event),
            ),
          ),
        ),
      ],
    );
  }
}
