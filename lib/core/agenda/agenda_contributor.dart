import 'package:lifeos/core/agenda/agenda_entry.dart';

/// A Type A feature's contribution to the shared cross-feature Agenda. The
/// Agenda registry never imports a feature's repository/entity types —
/// instead each feature implements this and registers an instance at the
/// composition layer (`config/di/agenda_contributor_registrations.dart`), so
/// adding a new agenda-contributing feature never requires a change inside
/// `core/agenda/` or `features/home/` (mirrors [SearchContributor] exactly —
/// see `features/search/domain/search_contributor.dart`).
abstract interface class AgendaContributor {
  /// A live stream of this feature's current agenda entries. Streamed (not
  /// a one-shot list) so [AgendaRegistry]'s aggregated index stays current
  /// as the feature's underlying data changes.
  Stream<List<AgendaEntry>> contributions();

  /// Resolves [id] against this contributor's own entries and applies
  /// whatever "dismiss" means for that feature (e.g. Reminders marks the
  /// reminder completed). No-ops if [id] doesn't belong to this
  /// contributor — [AgendaRegistry.dismiss] calls every contributor and
  /// lets each decide.
  Future<void> dismiss(String id);
}
