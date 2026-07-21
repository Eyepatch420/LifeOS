import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';

/// The in-app notification feed — rows [NotificationEngine] already
/// persists via [NotificationsDao] for every [ScheduleNotification] intent,
/// independent of whether the OS-level notification has fired yet. Reused
/// here rather than re-querying per feature, matching how `searchContributors`
/// composes across features without `features/notifications` importing any
/// of them.
final notificationsFeedProvider = StreamProvider<List<NotificationRecord>>((
  ref,
) {
  return ref.watch(databaseProvider).notificationsDao.watchAll();
});
