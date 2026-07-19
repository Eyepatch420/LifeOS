import 'dart:async';

import 'package:lifeos/core/agenda/agenda_contributor.dart';
import 'package:lifeos/core/agenda/agenda_entry.dart';

/// Combines every registered [AgendaContributor] into one live, time-sorted
/// index. Contributors are registered at the composition layer
/// (`config/di/agenda_contributor_registrations.dart`), not imported here —
/// this class never references a feature's types, so adding a new
/// agenda-contributing feature is a registration-only change (mirrors
/// [SearchRegistry] exactly — see `features/search/domain/search_registry.dart`).
class AgendaRegistry {
  AgendaRegistry(this._contributors);

  final List<AgendaContributor> _contributors;

  /// The merged, live, time-sorted agenda across every registered
  /// contributor. Combines each contributor's stream into one list that
  /// updates whenever any single contributor's data changes.
  Stream<List<AgendaEntry>> watchAll() {
    if (_contributors.isEmpty) return Stream.value(const []);

    final latest = List<List<AgendaEntry>>.filled(
      _contributors.length,
      const [],
    );
    final controller = StreamController<List<AgendaEntry>>.broadcast();
    final subscriptions = <StreamSubscription<List<AgendaEntry>>>[];
    var receivedCount = 0;
    final received = List<bool>.filled(_contributors.length, false);

    void emit() {
      // All-day entries sort ahead of every timed entry on the same
      // calendar day — an all-day event has no meaningful clock time (see
      // `AgendaEntry.isAllDay`'s doc comment), so comparing raw `time`
      // values alone would place it arbitrarily (typically midnight,
      // reading as misleadingly "first" or "overdue"). Ties within the
      // same [isAllDay] group still sort by `time`.
      final merged = [for (final entries in latest) ...entries]
        ..sort((a, b) {
          if (a.isAllDay != b.isAllDay) {
            return a.isAllDay ? -1 : 1;
          }
          return a.time.compareTo(b.time);
        });
      controller.add(merged);
    }

    controller.onListen = () {
      for (var i = 0; i < _contributors.length; i++) {
        final index = i;
        subscriptions.add(
          _contributors[index].contributions().listen((entries) {
            latest[index] = entries;
            if (!received[index]) {
              received[index] = true;
              receivedCount++;
            }
            if (receivedCount == _contributors.length) emit();
          }),
        );
      }
    };
    controller.onCancel = () async {
      for (final sub in subscriptions) {
        await sub.cancel();
      }
      await controller.close();
    };

    return controller.stream;
  }

  /// Calls `dismiss(id)` on every registered contributor — each contributor
  /// no-ops if [id] doesn't belong to it, so the registry never needs to
  /// know which one owns a given entry.
  Future<void> dismiss(String id) async {
    for (final contributor in _contributors) {
      await contributor.dismiss(id);
    }
  }
}
