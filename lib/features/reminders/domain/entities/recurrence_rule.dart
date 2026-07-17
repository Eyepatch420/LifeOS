/// The full recurrence taxonomy a [Reminder] can carry, designed up front
/// so the domain model never needs a second schema migration to add a rule
/// the first-pass UI doesn't yet expose (`NewReminderScreen` only offers
/// None/Daily today — see `docs/architecture_principles.md`'s standing rule
/// on designing for the eventual full shape).
enum RecurrenceRule {
  none,
  daily,
  weekdays,
  weekly,
  monthly,
  yearly,
  custom;

  /// The stable string persisted in `Reminders.recurrence` — stored as
  /// text, not an enum index, so a future reordering of this enum can never
  /// silently corrupt existing rows.
  String get storageKey => name;

  static RecurrenceRule fromStorageKey(String key) {
    return RecurrenceRule.values.firstWhere(
      (rule) => rule.storageKey == key,
      orElse: () => RecurrenceRule.none,
    );
  }
}
