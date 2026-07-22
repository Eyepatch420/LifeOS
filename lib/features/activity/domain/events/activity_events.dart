import 'package:lifeos/core/events/domain_event.dart';

/// Emitted by [ActivityRepository] whenever a day's activity aggregate is
/// created or updated (upsert-by-day, so there's no separate
/// "logged"/"updated" distinction the way append-only features have).
class ActivityUpdated extends DomainEvent {
  const ActivityUpdated({required String dayKey})
    : super(sourceModule: 'activity', sourceId: dayKey);
}
