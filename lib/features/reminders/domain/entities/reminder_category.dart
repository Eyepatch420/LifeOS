/// The category a [Reminder] belongs to — a first-class, persisted property
/// (`Reminders.category`), not a UI-only label. Mirrors [RecurrenceRule]'s
/// `storageKey`/`fromStorageKey` pattern: stored as text, not an enum
/// index, so a future reordering of this enum can never silently corrupt
/// existing rows.
enum ReminderCategory {
  medicine,
  meeting,
  work,
  study,
  shopping,
  bills,
  exercise,
  walk,
  reading,
  travel,
  personal,
  family,
  appointment,
  home,
  finance,
  documents,
  other;

  String get storageKey => name;

  static ReminderCategory fromStorageKey(String key) {
    return ReminderCategory.values.firstWhere(
      (category) => category.storageKey == key,
      orElse: () => ReminderCategory.other,
    );
  }
}
