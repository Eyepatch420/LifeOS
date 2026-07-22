import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/features/sleep/domain/entities/sleep_quality.dart';

part 'sleep_entry.freezed.dart';

/// A single manually-logged sleep record. [bedtime]/[wakeTime] are the
/// authoritative fields — duration is always derived
/// (`wakeTime.difference(bedtime)`), never stored, so an edited bedtime/wake
/// time can't leave a stale duration behind.
@freezed
abstract class SleepEntry with _$SleepEntry {
  const factory SleepEntry({
    required String id,
    required DateTime bedtime,
    required DateTime wakeTime,
    SleepQuality? quality,
    String? note,
    required DateTime createdAt,
  }) = _SleepEntry;

  const SleepEntry._();

  Duration get duration => wakeTime.difference(bedtime);

  /// The local calendar date this record belongs to — the *wake* date, not
  /// the bedtime date, so an 11pm Monday → 7am Tuesday sleep contributes to
  /// Tuesday's summary (matches how most sleep-tracking apps and users
  /// intuitively think of "last night's sleep").
  DateTime get sleepDay =>
      DateTime(wakeTime.year, wakeTime.month, wakeTime.day);
}
