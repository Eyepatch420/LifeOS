import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/notifications/presentation/providers/notifications_feed_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// The in-app notification feed — every [NotificationRecord]
/// `NotificationEngine` has persisted (see `notifications_feed_provider.dart`),
/// newest first. Only shows `sourceModule`s that actually map to a detail
/// destination; a tap on an entry from a module with no detail route yet is
/// a no-op rather than a broken navigation, keeping semantics honest instead
/// of inventing destinations that don't exist.
class NotificationsPlaceholderScreen extends ConsumerWidget {
  const NotificationsPlaceholderScreen({super.key});

  static (IconData, String, Map<String, String>)? _destination(
    NotificationRecord record,
  ) {
    return switch (record.sourceModule) {
      'reminders' => (
        Icons.notifications_outlined,
        RouteNames.reminderDetail,
        {'reminderId': record.sourceId},
      ),
      'focus' => (Icons.timer_outlined, RouteNames.focus, const {}),
      'calendar' => (
        Icons.event_outlined,
        RouteNames.eventDetail,
        {'eventId': record.sourceId},
      ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(notificationsFeedProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Notifications'),
      content: feed.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stackTrace) => Center(
          child: EmptyState(
            icon: Icons.error_outline,
            message: 'Couldn\'t load notifications',
          ),
        ),
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: EmptyState(
                icon: Icons.notifications_outlined,
                message: 'No notifications yet',
              ),
            );
          }
          return ListView.separated(
            itemCount: records.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final record = records[index];
              final destination = _destination(record);
              return FadeSlideIn(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    destination?.$1 ?? Icons.notifications_outlined,
                    color: context.colorScheme.primary,
                  ),
                  title: Text(record.title),
                  subtitle: Text(record.body),
                  onTap: destination == null
                      ? null
                      : () => context.pushNamed(
                          destination.$2,
                          pathParameters: destination.$3,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
