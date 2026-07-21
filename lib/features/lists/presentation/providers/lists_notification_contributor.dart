import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Lists' contribution to the notification pipeline — proves the fifth
/// contract piece is wired for Lists. Mirrors `NotesNotificationContributor`
/// exactly; Lists has nothing schedulable either, so this returns an empty
/// list for every event.
class ListsNotificationContributor implements NotificationContributor {
  const ListsNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'lists';

  @override
  List<NotificationIntent> map(DomainEvent event) => const [];
}
