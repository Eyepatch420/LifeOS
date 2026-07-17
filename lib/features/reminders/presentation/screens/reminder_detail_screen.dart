import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
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
class ReminderDetailScreen extends ConsumerWidget {
  const ReminderDetailScreen({required this.reminderId, super.key});

  final String reminderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(remindersRepositoryProvider);

    return StreamBuilder<List<Reminder>>(
      stream: repository.watchAll(),
      builder: (context, snapshot) {
        final reminders = snapshot.data;
        final reminder = reminders
            ?.where((r) => r.id == reminderId)
            .firstOrNull;

        return PushedScreenLayout(
          header: PushedScreenHeader(title: reminder?.title ?? 'Reminder'),
          content: reminder == null
              ? (reminders == null
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.notifications_active_outlined,
                        message: 'This reminder no longer exists',
                      ))
              : FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Due ${reminder.dueAt}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (reminder.isUrgent) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Chip(
                          label: const Text('Urgent'),
                          backgroundColor: context.colorScheme.errorContainer,
                        ),
                      ],
                    ],
                  ),
                ),
          ctaButton: reminder == null
              ? null
              : Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: reminder.isCompleted
                            ? 'Mark Not Done'
                            : 'Mark Done',
                        onPressed: () => repository.setCompleted(
                          reminder.id,
                          !reminder.isCompleted,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await repository.delete(reminder.id);
                        if (context.mounted) context.pop();
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
