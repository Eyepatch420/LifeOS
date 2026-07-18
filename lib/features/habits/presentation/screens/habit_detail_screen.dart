import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/habits/domain/entities/habit.dart';
import 'package:lifeos/features/habits/domain/entities/habit_schedule.dart';
import 'package:lifeos/features/habits/domain/entities/habit_streak.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Looks up [habitId] via a live stream, same "stale deep link falls back
/// to EmptyState" pattern as `ReminderDetailScreen`. Also serves as the
/// edit experience (toggled via the app bar's edit icon) rather than a
/// separate screen, mirroring `ReminderDetailScreen` exactly.
class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({required this.habitId, super.key});

  final String habitId;

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  String? _titleError;

  late TextEditingController _titleController;
  late bool _isDaily;
  late Set<int> _selectedWeekdays;

  void _startEditing(Habit habit) {
    _titleController = TextEditingController(text: habit.title);
    _isDaily = habit.schedule.isDaily;
    _selectedWeekdays = {...habit.schedule.weekdays};
    setState(() {
      _isEditing = true;
      _titleError = null;
    });
  }

  void _cancelEditing() {
    _titleController.dispose();
    setState(() => _isEditing = false);
  }

  Future<void> _save(Habit habit) async {
    final title = _titleController.text.trim();
    setState(() => _titleError = title.isEmpty ? 'Title is required' : null);
    if (_titleError != null) return;

    setState(() => _isSaving = true);
    final schedule = _isDaily
        ? const HabitSchedule.daily()
        : HabitSchedule.weekly(
            _selectedWeekdays.isEmpty ? {1} : _selectedWeekdays,
          );

    await ref
        .read(habitsRepositoryProvider)
        .update(
          id: habit.id,
          title: title,
          schedule: schedule,
          icon: habit.icon,
        );
    if (!mounted) return;
    _titleController.dispose();
    setState(() {
      _isEditing = false;
      _isSaving = false;
    });
  }

  Future<void> _confirmDelete(Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete habit?'),
        content: const Text(
          'This habit and its streak history will be archived. '
          "This can't be undone from here.",
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

    await ref.read(habitsRepositoryProvider).archive(habit.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(habitsRepositoryProvider);

    return StreamBuilder<List<Habit>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final habits = snapshot.data;
        final habit = habits?.where((h) => h.id == widget.habitId).firstOrNull;

        return PushedScreenLayout(
          header: PushedScreenHeader(
            title: _isEditing ? 'Edit Habit' : (habit?.title ?? 'Habit'),
          ),
          content: habit == null
              ? (habits == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.track_changes_outlined,
                        message: 'This habit no longer exists',
                      ))
              : (_isEditing ? _buildEditForm() : _buildReadOnly(habit)),
          ctaButton: habit == null
              ? null
              : (_isEditing ? _buildEditCta(habit) : _buildReadOnlyCta(habit)),
        );
      },
    );
  }

  Widget _buildReadOnly(Habit habit) {
    return StreamBuilder<Set<DateTime>>(
      stream: ref.read(habitsRepositoryProvider).watchCompletionDates(habit.id),
      builder: (context, snapshot) {
        final completions = snapshot.data ?? const {};
        final now = DateTime.now();
        final streak = calculateHabitStreak(
          schedule: habit.schedule,
          completedDates: completions,
          now: now,
        );
        final isCompletedToday = completions.contains(dateOnly(now));

        return FadeSlideIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      habit.title,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Edit habit',
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _startEditing(habit),
                    ),
                  ),
                ],
              ),
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
                    habit.schedule.isDaily
                        ? 'Daily'
                        : (habit.schedule.weekdays.toList()..sort())
                              .map((d) => _weekdayLabels[d - 1])
                              .join(', '),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${streak.current} day streak',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Best: ${streak.best}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (isCompletedToday) ...[
                const SizedBox(height: AppSpacing.sm),
                Chip(
                  label: const Text('Completed today'),
                  backgroundColor: context.colorScheme.primaryContainer,
                ),
              ],
            ],
          ),
        );
      },
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
              Wrap(
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
                      }),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyCta(Habit habit) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<Set<DateTime>>(
            stream: ref
                .read(habitsRepositoryProvider)
                .watchCompletionDates(habit.id),
            builder: (context, snapshot) {
              final completions = snapshot.data ?? const {};
              final isCompletedToday = completions.contains(
                dateOnly(DateTime.now()),
              );
              return PrimaryButton(
                label: isCompletedToday ? 'Undo Completion' : 'Mark Done',
                onPressed: () => ref
                    .read(habitsRepositoryProvider)
                    .setCompletedForDate(
                      habit.id,
                      DateTime.now(),
                      completed: !isCompletedToday,
                    ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Semantics(
          button: true,
          label: 'Delete habit',
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(habit),
          ),
        ),
      ],
    );
  }

  Widget _buildEditCta(Habit habit) {
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
              onPressed: _isSaving ? null : () => _save(habit),
            ),
          ),
        ),
      ],
    );
  }
}
