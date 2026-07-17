import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/agenda_contributor_registrations.dart';
import 'package:lifeos/core/agenda/agenda_entry.dart';
import 'package:lifeos/core/agenda/agenda_registry.dart';

/// The live, combined agenda across every registered [AgendaContributor]
/// (see `config/di/agenda_contributor_registrations.dart` for the
/// registration list — the one place allowed to import every feature's
/// contributor). This — never a feature repository — is what Home's
/// `UpNextNotifier`/`TimelineNotifier` watch.
final agendaRegistryProvider = Provider<AgendaRegistry>((ref) {
  return AgendaRegistry(agendaContributors(ref));
});

final agendaEntriesProvider = StreamProvider<List<AgendaEntry>>(
  (ref) => ref.watch(agendaRegistryProvider).watchAll(),
);
