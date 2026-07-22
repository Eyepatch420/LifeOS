import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_activity_entry.freezed.dart';

/// A single local day's activity aggregate — one row per day (see
/// `DailyActivity` table doc comment), not an append-only event log.
/// [dayKey] is the local-day key (`yyyy-MM-dd`) this record represents.
@freezed
abstract class DailyActivityEntry with _$DailyActivityEntry {
  const factory DailyActivityEntry({
    required String dayKey,
    required int steps,
    int? distanceMeters,
    int? activeMinutes,
    required DateTime updatedAt,
  }) = _DailyActivityEntry;
}
