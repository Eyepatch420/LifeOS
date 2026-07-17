import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/agenda/agenda_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_agenda_contributor.dart';
import 'package:lifeos/features/reminders/presentation/providers/reminders_dashboard_provider.dart';

/// The single composition-layer seam allowed to import every Type A
/// feature's [AgendaContributor] — `core/agenda/` and `features/home/`
/// never do. Add one line here when a feature gains a contributor;
/// nothing inside `core/agenda/` changes (mirrors
/// `search_contributor_registrations.dart` exactly).
///
/// Habits deliberately never contributes here, since its `scheduleDays` is
/// day-granularity, not time-of-day, and isn't a natural timeline entry.
List<AgendaContributor> agendaContributors(Ref ref) {
  return [RemindersAgendaContributor(ref.watch(remindersRepositoryProvider))];
}
