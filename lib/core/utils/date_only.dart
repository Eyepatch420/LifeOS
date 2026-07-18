/// Truncates [date] to its local calendar day (midnight), stripping any
/// time component — the single normalization point for every calendar-date
/// comparison across features (Planner, Habits, ...), so nothing compares a
/// raw `DateTime` (with its hour/minute) against a "day" by accident. Lives
/// in `core/` (not a feature) so every feature can import it without
/// violating the Golden Rule — see `test/contracts/import_boundary_test.dart`.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Whether [a] and [b] fall on the same local calendar day, ignoring time.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
