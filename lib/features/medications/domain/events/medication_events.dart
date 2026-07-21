import 'package:lifeos/core/events/domain_event.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';

/// One resolved notification slot to (re)schedule — carries everything
/// [MedicationNotificationContributor] needs to build a `ScheduleNotification`
/// without an async repository re-read (same rationale as
/// `HabitCreated.title`'s doc comment).
class MedicationScheduleSlotChange {
  const MedicationScheduleSlotChange({
    required this.slotId,
    required this.nextOccurrence,
    required this.title,
    required this.body,
  });

  final String slotId;
  final DateTime nextOccurrence;
  final String title;
  final String body;
}

/// The single event covering every way a medication's OS-notification
/// footprint can change: creation, a schedule edit (times/weekdays),
/// archival, deletion, and startup reconciliation. [MedicationsRepository]
/// computes [oldSlotIds] (every notification id that existed before this
/// change — empty for a brand-new medication or a reconciliation replay)
/// and [newSlots] (every notification id/instant that should exist after),
/// so `MedicationNotificationContributor.map` stays a pure function: cancel
/// every id in [oldSlotIds] not present in [newSlots], then (re)schedule
/// every [newSlots] entry. Archival/deletion pass an empty [newSlots] —
/// nothing new to schedule, only cancellation. A reconciliation replay
/// passes an empty [oldSlotIds] (nothing to diff away) with the full
/// current [newSlots] — safe to repeat since `scheduleAt` on an existing id
/// overwrites in place.
class MedicationScheduleChanged extends DomainEvent {
  const MedicationScheduleChanged({
    required String medicationId,
    required this.oldSlotIds,
    required this.newSlots,
  }) : super(sourceModule: 'medications', sourceId: medicationId);

  final List<String> oldSlotIds;
  final List<MedicationScheduleSlotChange> newSlots;
}

/// Emitted when a dose occurrence is marked taken or skipped — carries no
/// notification-scheduling implication (adherence actions don't change
/// future schedule slots), used by dashboard/search consumers only.
class MedicationOccurrenceRecorded extends DomainEvent {
  const MedicationOccurrenceRecorded({
    required String medicationId,
    required this.occurrenceId,
  }) : super(sourceModule: 'medications', sourceId: medicationId);

  final String occurrenceId;
}

extension MedicationScheduleSlotIds on MedicationSchedule {
  List<String> slotIdsFor(String medicationId) => [
    for (final time in times)
      MedicationScheduleStorage.slotId(medicationId, time),
  ];
}
