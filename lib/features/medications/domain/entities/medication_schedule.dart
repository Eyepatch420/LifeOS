import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_schedule.freezed.dart';

/// A single time-of-day a medication is due, e.g. 09:00. Deliberately not
/// `TimeOfDay` (a Flutter/material type) — this is a pure domain value with
/// no widget dependency, unit-testable without `flutter_test`.
@freezed
abstract class MedicationTime with _$MedicationTime {
  const factory MedicationTime({required int hour, required int minute}) =
      _MedicationTime;

  /// Parses `"HH:mm"`, the encoding `Medications.scheduleTimes` stores.
  factory MedicationTime.parse(String hhmm) {
    final parts = hhmm.split(':');
    return MedicationTime(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

extension MedicationTimeStorage on MedicationTime {
  /// `"HH:mm"`, zero-padded — the single canonical slot identity component
  /// (paired with a medication id) notification scheduling keys off, so it
  /// must round-trip exactly through [MedicationTime.parse].
  String get storageKey =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// A medication's dosing schedule: a non-empty set of times-of-day, and an
/// optional weekday restriction (`null` = every day). This is the feature's
/// own pure value type — not `RecurrenceRule` (wrong shape: Reminder
/// recurrence is a single-instant-advance model, this is a set of daily
/// slots), mirroring `HabitSchedule`'s role for Habits.
@freezed
abstract class MedicationSchedule with _$MedicationSchedule {
  const factory MedicationSchedule({
    required List<MedicationTime> times,

    /// ISO weekday numbers (1=Mon..7=Sun). `null`/empty means every day.
    Set<int>? days,
  }) = _MedicationSchedule;

  factory MedicationSchedule.fromStorage({
    required String scheduleTimes,
    String? scheduleDays,
  }) {
    final times = scheduleTimes
        .split(',')
        .map((s) => MedicationTime.parse(s.trim()))
        .toList();
    final days = (scheduleDays == null || scheduleDays.isEmpty)
        ? null
        : scheduleDays.split(',').map(int.parse).toSet();
    return MedicationSchedule(times: times, days: days);
  }
}

extension MedicationScheduleStorage on MedicationSchedule {
  String get storageTimes => times.map((t) => t.storageKey).join(',');

  String? get storageDays => (days == null || days!.isEmpty)
      ? null
      : (days!.toList()..sort()).join(',');

  bool get isDaily => days == null || days!.isEmpty;

  bool occursOn(int isoWeekday) => isDaily || days!.contains(isoWeekday);

  /// The stable id for one schedule slot — `"$medicationId:$hhmm"` — the
  /// composite key notification scheduling hashes (via
  /// `LocalNotificationScheduler._stableIntId`) so distinct medications and
  /// distinct times-of-day never collide, mirroring the existing
  /// `'ongoing:$id'` namespacing precedent.
  static String slotId(String medicationId, MedicationTime time) =>
      '$medicationId:${time.storageKey}';
}
