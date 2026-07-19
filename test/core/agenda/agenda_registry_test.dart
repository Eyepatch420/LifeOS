import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/agenda/agenda_contributor.dart';
import 'package:lifeos/core/agenda/agenda_entry.dart';
import 'package:lifeos/core/agenda/agenda_registry.dart';

AgendaEntry _entry(
  String id,
  DateTime time, {
  String sourceModule = 'test',
  bool isAllDay = false,
}) {
  return AgendaEntry(
    id: id,
    sourceModule: sourceModule,
    sourceId: id,
    icon: Icons.circle,
    title: id,
    time: time,
    dotColor: Colors.blue,
    isUrgent: false,
    isAllDay: isAllDay,
  );
}

class _FakeContributor implements AgendaContributor {
  _FakeContributor(this._entries);

  List<AgendaEntry> _entries;
  final List<String> dismissed = [];
  final _controller = StreamController<List<AgendaEntry>>.broadcast();

  @override
  Stream<List<AgendaEntry>> contributions() {
    return Stream.multi((listener) {
      listener.add(_entries);
      final sub = _controller.stream.listen(listener.add);
      listener.onCancel = sub.cancel;
    });
  }

  void update(List<AgendaEntry> entries) {
    _entries = entries;
    _controller.add(entries);
  }

  @override
  Future<void> dismiss(String id) async {
    if (_entries.any((e) => e.id == id)) dismissed.add(id);
  }
}

void main() {
  test('empty contributor list yields an empty agenda', () async {
    final registry = AgendaRegistry([]);
    final result = await registry.watchAll().first;
    expect(result, isEmpty);
  });

  test(
    'combines and time-sorts entries across multiple contributors',
    () async {
      final morning = _FakeContributor([_entry('a', DateTime(2026, 1, 1, 9))]);
      final evening = _FakeContributor([_entry('b', DateTime(2026, 1, 1, 18))]);
      final registry = AgendaRegistry([evening, morning]);

      final result = await registry.watchAll().first;

      expect(result.map((e) => e.id), ['a', 'b']);
    },
  );

  test('re-emits the merged list when one contributor updates', () async {
    final a = _FakeContributor([_entry('a', DateTime(2026, 1, 1, 9))]);
    final b = _FakeContributor([_entry('b', DateTime(2026, 1, 1, 18))]);
    final registry = AgendaRegistry([a, b]);

    final results = <List<AgendaEntry>>[];
    final sub = registry.watchAll().listen(results.add);
    await pumpEventQueue();

    a.update([
      _entry('a', DateTime(2026, 1, 1, 9)),
      _entry('a2', DateTime(2026, 1, 1, 8)),
    ]);
    await pumpEventQueue();

    expect(results.last.map((e) => e.id), ['a2', 'a', 'b']);
    await sub.cancel();
  });

  test('all-day entries sort ahead of timed entries on the same day, '
      'regardless of raw time value', () async {
    // The all-day entry's `time` is midnight (earliest possible), so a
    // naive time-only sort would already put it first here — use a
    // LATER raw `time` to prove the sort genuinely checks `isAllDay`
    // first, not just falling out of `time.compareTo` by coincidence.
    final allDay = _entry('allday', DateTime(2026, 1, 1, 23), isAllDay: true);
    final timed = _entry('timed', DateTime(2026, 1, 1, 9));
    final registry = AgendaRegistry([
      _FakeContributor([timed]),
      _FakeContributor([allDay]),
    ]);

    final result = await registry.watchAll().first;

    expect(result.map((e) => e.id), ['allday', 'timed']);
  });

  test(
    'dismiss calls every contributor, each no-oping if it does not own the id',
    () async {
      final a = _FakeContributor([_entry('a', DateTime(2026, 1, 1, 9))]);
      final b = _FakeContributor([_entry('b', DateTime(2026, 1, 1, 18))]);
      final registry = AgendaRegistry([a, b]);

      await registry.dismiss('b');

      expect(a.dismissed, isEmpty);
      expect(b.dismissed, ['b']);
    },
  );
}
