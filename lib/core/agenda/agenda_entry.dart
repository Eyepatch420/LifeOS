import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_entry.freezed.dart';

/// One item on the cross-feature Agenda — the shared aggregation Home's
/// Timeline/Up Next sections render, and any future module (Health,
/// Medicine, Reading, Bills, Calendar, Workouts, ...) can contribute to by
/// implementing [AgendaContributor]. Lives under `core/agenda/`, not
/// `features/home/`, because Home only ever renders this — it never owns
/// it (see docs/architecture_principles.md).
///
/// [sourceModule]/[sourceId] let [AgendaRegistry] route a `dismiss(id)` call
/// back to the contributor that owns the entry, without the registry (or
/// Home) ever importing that feature's repository directly.
///
/// [isAllDay] was added in Phase 7 once Calendar Events became a second
/// Agenda contributor: an all-day event has no meaningful clock [time], so
/// this flag lets [AgendaRegistry.watchAll]'s sort put all-day entries
/// first for their day rather than the registry (or Home) fabricating a
/// misleading midnight sort position for one — defaults to `false` so
/// every existing contributor (Reminders) is unaffected.
@freezed
abstract class AgendaEntry with _$AgendaEntry {
  const factory AgendaEntry({
    required String id,
    required String sourceModule,
    required String sourceId,
    required IconData icon,
    required String title,
    required DateTime time,
    required Color dotColor,
    required bool isUrgent,
    @Default(false) bool isAllDay,
  }) = _AgendaEntry;
}
