import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/features/habits/presentation/providers/habits_notification_contributor.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_notification_contributor.dart';
import 'package:lifeos/features/notes/presentation/providers/notes_notification_contributor.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_notification_contributor.dart';

/// The single composition-layer seam allowed to import every Type A
/// feature's [NotificationContributor] — `features/notifications/` never
/// does. Add one line here when a feature gains a contributor; nothing
/// inside `features/notifications/`/`core/notifications/` changes (mirrors
/// `search_contributor_registrations.dart`/`agenda_contributor_registrations.dart`
/// exactly).
List<NotificationContributor> notificationContributors(Ref ref) {
  return [
    const NotesNotificationContributor(),
    const ListsNotificationContributor(),
    const RemindersNotificationContributor(),
    const HabitsNotificationContributor(),
  ];
}
