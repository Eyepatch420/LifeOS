/// A habit's schedule: either every day, or a fixed set of weekdays. This is
/// deliberately narrower than [RecurrenceRule] (Reminders' taxonomy) — a
/// habit is either daily or pinned to specific weekdays, never
/// monthly/yearly/custom, matching the actual UI/MVP scope this phase asks
/// for (see docs/architecture_principles.md's standing rule against
/// speculative complexity).
///
/// Persisted via `Habits.targetFrequency`/`Habits.scheduleDays` (see
/// `habits_table.dart`): `targetFrequency` is `'Daily'` or `'Weekly'`,
/// `scheduleDays` is a comma-separated list of weekday indices (1=Mon..
/// 7=Sun, `DateTime.weekday`'s own numbering) — empty for daily.
class HabitSchedule {
  const HabitSchedule.daily() : weekdays = const {};

  const HabitSchedule.weekly(this.weekdays)
    : assert(weekdays.length > 0, 'A weekly schedule needs at least one day');

  /// Empty for a daily schedule; 1..7 (Mon..Sun, [DateTime.weekday]'s
  /// numbering) for a weekly one.
  final Set<int> weekdays;

  bool get isDaily => weekdays.isEmpty;

  /// Whether this schedule expects an occurrence on [date].
  bool occursOn(DateTime date) => isDaily || weekdays.contains(date.weekday);

  String get storageFrequency => isDaily ? 'Daily' : 'Weekly';

  String get storageScheduleDays => (weekdays.toList()..sort()).join(',');

  static HabitSchedule fromStorage({
    required String targetFrequency,
    required String scheduleDays,
  }) {
    if (targetFrequency != 'Weekly' || scheduleDays.isEmpty) {
      return const HabitSchedule.daily();
    }
    final days = scheduleDays.split(',').map(int.parse).toSet();
    return days.isEmpty
        ? const HabitSchedule.daily()
        : HabitSchedule.weekly(days);
  }

  @override
  bool operator ==(Object other) =>
      other is HabitSchedule &&
      isDaily == other.isDaily &&
      weekdays.length == other.weekdays.length &&
      weekdays.containsAll(other.weekdays);

  @override
  int get hashCode => Object.hash(isDaily, Object.hashAllUnordered(weekdays));
}
