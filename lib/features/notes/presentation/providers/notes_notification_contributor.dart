import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/notifications/domain/notification_contributor.dart';

/// Notes' contribution to the notification pipeline — proves the fifth
/// contract piece is wired for Notes. Notes has no due-dated concept (a
/// note is never "due"), so it legitimately has nothing to schedule; this
/// returns an empty list for every event rather than being omitted, so the
/// five-part contract stays complete and explicit.
class NotesNotificationContributor implements NotificationContributor {
  const NotesNotificationContributor();

  @override
  bool handles(DomainEvent event) => event.sourceModule == 'notes';

  @override
  List<NotificationIntent> map(DomainEvent event) => const [];
}
