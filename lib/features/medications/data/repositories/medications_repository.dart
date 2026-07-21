import 'package:drift/drift.dart' show Value;
import 'package:lifeos/core/database/app_database.dart' as db;
import 'package:lifeos/core/database/daos/medications_dao.dart';
import 'package:lifeos/core/events/event_bus.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/utils/date_only.dart';
import 'package:lifeos/features/medications/domain/entities/medication.dart';
import 'package:lifeos/features/medications/domain/entities/medication_occurrence.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule.dart';
import 'package:lifeos/features/medications/domain/entities/medication_schedule_calculator.dart';
import 'package:lifeos/features/medications/domain/events/medication_events.dart';

/// The single owner of Medications persistence — every mutation/query goes
/// through here, wrapping [MedicationsDao] and mapping Drift rows to the
/// feature's own [Medication]/[MedicationOccurrence] entities. No other
/// feature imports this class or [MedicationsDao] directly (Golden Rule,
/// mirrors `HabitsRepository`/`FocusRepository`).
///
/// Emits [MedicationScheduleChanged] onto the shared [EventBus] for every
/// create/update/archive/delete and for startup reconciliation — never
/// calls `NotificationScheduler` directly (Architecture Constraint 5);
/// `MedicationNotificationContributor` is the only consumer that turns
/// these into real scheduling calls. The event always carries both
/// [MedicationScheduleChanged.oldSlotIds] (what to cancel) and
/// [MedicationScheduleChanged.newSlots] (what to (re)schedule) so the
/// contributor mapping stays a pure function — this repository does all
/// the "what changed" diffing, since it's the only layer that has both the
/// prior and new persisted schedule.
///
/// All "now" values come from [ClockManager], not `DateTime.now()`
/// directly, so tests can drive the timeline with a fake clock.
class MedicationsRepository {
  MedicationsRepository(this._dao, this._eventBus, this._clock);

  final MedicationsDao _dao;
  final EventBus _eventBus;
  final ClockManager _clock;

  Stream<List<Medication>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  Stream<List<Medication>> watchActive() {
    return _dao.watchActive().map((rows) => rows.map(_toEntity).toList());
  }

  Future<Medication?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  Future<void> create({
    required String id,
    required String name,
    String? dosageText,
    String? instructions,
    required MedicationSchedule schedule,
  }) async {
    await _dao.upsert(
      db.MedicationsCompanion.insert(
        id: id,
        name: name,
        dosageText: Value(dosageText),
        instructions: Value(instructions),
        scheduleTimes: schedule.storageTimes,
        scheduleDays: Value(schedule.storageDays),
        createdAt: _clock.now(),
      ),
    );
    _emitScheduleChanged(
      medicationId: id,
      name: name,
      oldSchedule: null,
      newSchedule: schedule,
    );
  }

  Future<void> update({
    required String id,
    required String name,
    String? dosageText,
    String? instructions,
    required MedicationSchedule schedule,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    final oldSchedule = MedicationSchedule.fromStorage(
      scheduleTimes: existing.scheduleTimes,
      scheduleDays: existing.scheduleDays,
    );
    await _dao.upsert(
      db.MedicationsCompanion(
        id: Value(id),
        name: Value(name),
        dosageText: Value(dosageText),
        instructions: Value(instructions),
        scheduleTimes: Value(schedule.storageTimes),
        scheduleDays: Value(schedule.storageDays),
        createdAt: Value(existing.createdAt),
        archivedAt: Value(existing.archivedAt),
      ),
    );
    _emitScheduleChanged(
      medicationId: id,
      name: name,
      oldSchedule: oldSchedule,
      newSchedule: schedule,
    );
  }

  Future<void> archive(String id) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.archive(id, _clock.now());
    final oldSchedule = MedicationSchedule.fromStorage(
      scheduleTimes: existing.scheduleTimes,
      scheduleDays: existing.scheduleDays,
    );
    _emitScheduleChanged(
      medicationId: id,
      name: existing.name,
      oldSchedule: oldSchedule,
      newSchedule: null,
    );
  }

  Future<void> delete(String id) async {
    final existing = await _dao.getById(id);
    if (existing == null) return;
    await _dao.deleteById(id);
    final oldSchedule = MedicationSchedule.fromStorage(
      scheduleTimes: existing.scheduleTimes,
      scheduleDays: existing.scheduleDays,
    );
    _emitScheduleChanged(
      medicationId: id,
      name: existing.name,
      oldSchedule: oldSchedule,
      newSchedule: null,
    );
  }

  /// Re-asserts every active medication's current schedule onto the
  /// notification pipeline. Called once at app startup (see `app.dart`'s
  /// `initState`) — safe to call any number of times: replaying the same
  /// slots is a no-op cancel-diff (`oldSlotIds` is empty) followed by an
  /// overwrite-in-place `scheduleAt` for each slot, so a normal restart
  /// never accumulates duplicate OS notifications. Mirrors
  /// `FocusRepository.reconcileNotificationsOnStartup()`'s "replay the
  /// event the normal path already emits" pattern.
  Future<void> reconcileNotificationsOnStartup() async {
    final active = await _dao.watchActive().first;
    for (final row in active) {
      final schedule = MedicationSchedule.fromStorage(
        scheduleTimes: row.scheduleTimes,
        scheduleDays: row.scheduleDays,
      );
      _emitScheduleChanged(
        medicationId: row.id,
        name: row.name,
        oldSchedule: null,
        newSchedule: schedule,
      );
    }
  }

  /// Marks a dose taken/skipped — writes a real occurrence row keyed by
  /// `(medicationId, scheduledFor)`. An untouched future/today occurrence
  /// has no row until acted on (see [watchTodayOccurrences]).
  Future<void> recordOccurrence({
    required String id,
    required String medicationId,
    required DateTime scheduledFor,
    required bool taken,
  }) async {
    final now = _clock.now();
    await _dao.upsertOccurrence(
      db.MedicationOccurrencesCompanion.insert(
        id: id,
        medicationId: medicationId,
        scheduledFor: scheduledFor,
        status: taken ? 'taken' : 'skipped',
        takenAt: Value(taken ? now : null),
      ),
    );
    _eventBus.emit(
      MedicationOccurrenceRecorded(
        medicationId: medicationId,
        occurrenceId: id,
      ),
    );
  }

  /// Today's occurrences across every active medication — each slot's real
  /// persisted row if one exists (taken/skipped), otherwise a synthesized
  /// in-memory placeholder (scheduled, or missed if its time has already
  /// passed). Never persists the synthesized rows itself — see
  /// `MedicationOccurrences`' doc comment on why "missed" stays derived.
  ///
  /// Re-queries [_dao.watchActive] itself — only safe to call from outside
  /// an existing `watchActive()`/`watchAll()` stream callback. A second
  /// independent query issued from inside a stream's own emission handler
  /// deadlocks the underlying Drift connection (observed hanging
  /// `flutter_test`'s `pumpAndSettle` — same class of bug documented on
  /// `FocusRepository.reconcileNotificationsOnStartup`'s "single query, not
  /// two" doc comment). [medicationsDashboardProvider] must use
  /// [todayOccurrencesFor] instead, passing the `active` list its own
  /// stream callback already received.
  Future<List<MedicationOccurrence>> watchTodayOccurrences() async {
    final active = await _dao.watchActive().first;
    return todayOccurrencesFor(active.map(_toEntity).toList());
  }

  /// The pure computation half of [watchTodayOccurrences], taking an
  /// already-fetched active-medications list instead of querying one —
  /// safe to call from inside a stream callback that already has `active`.
  Future<List<MedicationOccurrence>> todayOccurrencesFor(
    List<Medication> active,
  ) async {
    final now = _clock.now();
    final today = dateOnly(now);
    final tomorrow = today.add(const Duration(days: 1));
    final persisted = await _dao.occurrencesBetween(today, tomorrow);
    final persistedByKey = {
      for (final row in persisted)
        '${row.medicationId}:${row.scheduledFor}': row,
    };

    final result = <MedicationOccurrence>[];
    for (final medication in active) {
      final schedule = medication.schedule;
      if (!schedule.occursOn(today.weekday)) continue;
      for (final time in schedule.times) {
        final scheduledFor = DateTime(
          today.year,
          today.month,
          today.day,
          time.hour,
          time.minute,
        );
        final key = '${medication.id}:$scheduledFor';
        final persistedRow = persistedByKey[key];
        if (persistedRow != null) {
          result.add(
            MedicationOccurrence(
              id: persistedRow.id,
              medicationId: medication.id,
              scheduledFor: scheduledFor,
              status: persistedRow.status == 'taken'
                  ? MedicationOccurrenceStatus.taken
                  : MedicationOccurrenceStatus.skipped,
              takenAt: persistedRow.takenAt,
            ),
          );
        } else {
          result.add(
            MedicationOccurrence(
              medicationId: medication.id,
              scheduledFor: scheduledFor,
              status: scheduledFor.isBefore(now)
                  ? MedicationOccurrenceStatus.missed
                  : MedicationOccurrenceStatus.scheduled,
            ),
          );
        }
      }
    }
    result.sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));
    return result;
  }

  void _emitScheduleChanged({
    required String medicationId,
    required String name,
    required MedicationSchedule? oldSchedule,
    required MedicationSchedule? newSchedule,
  }) {
    final oldSlotIds = oldSchedule?.slotIdsFor(medicationId) ?? const [];
    final newSlots = newSchedule == null
        ? const <MedicationScheduleSlotChange>[]
        : [
            for (final slot in nextOccurrences(newSchedule, _clock.now()))
              MedicationScheduleSlotChange(
                slotId: MedicationScheduleStorage.slotId(
                  medicationId,
                  slot.time,
                ),
                nextOccurrence: slot.nextOccurrence,
                title: name,
                body: 'Time to take $name',
              ),
          ];
    _eventBus.emit(
      MedicationScheduleChanged(
        medicationId: medicationId,
        oldSlotIds: oldSlotIds,
        newSlots: newSlots,
      ),
    );
  }

  Medication _toEntity(db.Medication row) => Medication(
    id: row.id,
    name: row.name,
    dosageText: row.dosageText,
    instructions: row.instructions,
    schedule: MedicationSchedule.fromStorage(
      scheduleTimes: row.scheduleTimes,
      scheduleDays: row.scheduleDays,
    ),
    createdAt: row.createdAt,
    archivedAt: row.archivedAt,
  );
}
