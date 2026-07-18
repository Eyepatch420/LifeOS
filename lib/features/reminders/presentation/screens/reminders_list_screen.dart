import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';
import 'package:lifeos/features/reminders/domain/entities/reminder.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Full Reminders list — the canonical full reminder management screen,
/// reachable via the dashboard's "View all" (see `RoutePaths.remindersAll`,
/// nested under the Reminders branch's own `/reminders` route since Phase
/// 4). Mirrors `NotesListScreen`'s shape: reads
/// `RemindersRepository.watchAll()` directly (a live stream, not a one-shot
/// list), swipe-to-delete with undo, and a completion toggle in place of
/// Notes' pin toggle.
class RemindersListScreen extends ConsumerWidget {
  const RemindersListScreen({super.key});

  Future<void> _deleteWithUndo(
    BuildContext context,
    WidgetRef ref,
    Reminder reminder,
  ) async {
    final repository = ref.read(remindersRepositoryProvider);
    await repository.delete(reminder.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${reminder.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => repository.restore(reminder.id),
        ),
      ),
    );
  }

  /// The single semantic completion operation (see
  /// `RemindersRepository.setCompleted`'s doc comment) — for a recurring
  /// reminder this advances it to its next occurrence rather than leaving
  /// it completed, so a snackbar surfaces that distinction the same way
  /// `ReminderDetailScreen` does; a plain reminder just gets a lighter
  /// "Completed"/"Marked as pending" acknowledgement.
  Future<void> _toggleCompleted(
    BuildContext context,
    WidgetRef ref,
    Reminder reminder,
  ) async {
    final repository = ref.read(remindersRepositoryProvider);
    final wasCompleted = reminder.isCompleted;
    await repository.setCompleted(reminder.id, !wasCompleted);
    if (!context.mounted) return;

    if (wasCompleted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Marked as pending')));
      return;
    }

    if (reminder.recurrence == RecurrenceRule.none) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reminder completed')));
      return;
    }

    final refreshed = await repository.getById(reminder.id);
    if (!context.mounted || refreshed == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Completed. Next reminder: '
          '${DateFormat('EEE, d MMM • h:mm a').format(refreshed.dueAt)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(remindersRepositoryProvider);
    return PushedScreenLayout(
      header: Row(
        children: [
          const Expanded(child: PushedScreenHeader(title: 'Reminders')),
          Semantics(
            button: true,
            label: 'Add reminder',
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.pushNamed(RouteNames.newReminder),
            ),
          ),
        ],
      ),
      content: StreamBuilder<List<Reminder>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          final reminders = snapshot.data;
          if (reminders == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (reminders.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_active_outlined,
              message: 'No reminders yet',
              ctaLabel: 'Add Reminder',
              onCtaTap: () => context.pushNamed(RouteNames.newReminder),
            );
          }
          final sorted = [...reminders]
            ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
          return StaggeredEntrance(
            children: [
              for (final reminder in sorted)
                _ReminderListTile(
                  reminder: reminder,
                  onToggleCompleted: () =>
                      _toggleCompleted(context, ref, reminder),
                  onDismissed: () => _deleteWithUndo(context, ref, reminder),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReminderListTile extends StatelessWidget {
  const _ReminderListTile({
    required this.reminder,
    required this.onToggleCompleted,
    required this.onDismissed,
  });

  final Reminder reminder;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      resizeDuration: AppMotionPresets.cardExit.duration,
      movementDuration: AppMotionPresets.cardExit.duration,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          Icons.delete_outline,
          color: context.colorScheme.onErrorContainer,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: 0,
        ),
        leading: Icon(
          reminder.isUrgent
              ? Icons.priority_high_rounded
              : Icons.notifications_active_outlined,
          color: reminder.isUrgent
              ? context.colorScheme.error
              : context.colorScheme.primary,
        ),
        title: Text(
          reminder.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: reminder.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: Text(
                DateFormat('EEE, d MMM • h:mm a').format(reminder.dueAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (reminder.recurrence != RecurrenceRule.none) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.repeat,
                size: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
        trailing: Semantics(
          button: true,
          label: reminder.isCompleted ? 'Mark as pending' : 'Mark as completed',
          child: IconButton(
            icon: Icon(
              reminder.isCompleted
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: reminder.isCompleted ? context.colorScheme.primary : null,
            ),
            onPressed: onToggleCompleted,
          ),
        ),
        onTap: () => context.pushNamed(
          RouteNames.reminderDetail,
          pathParameters: {'reminderId': reminder.id},
        ),
      ),
    );
  }
}
