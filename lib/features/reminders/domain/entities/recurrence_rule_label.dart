import 'package:lifeos/features/reminders/domain/entities/recurrence_rule.dart';

/// Human-readable label for a [RecurrenceRule] — shared by the New/Edit
/// form's picker and `ReminderDetailScreen`'s display so neither ever shows
/// a raw enum name (`RecurrenceRule.weekdays` etc). [RecurrenceRule.custom]
/// is intentionally excluded from [selectableRecurrenceRules] (see its doc
/// comment) but still needs a label here in case an existing row already
/// has it persisted.
String recurrenceRuleLabel(RecurrenceRule rule) {
  return switch (rule) {
    RecurrenceRule.none => 'Never',
    RecurrenceRule.daily => 'Daily',
    RecurrenceRule.weekdays => 'Weekdays',
    RecurrenceRule.weekly => 'Weekly',
    RecurrenceRule.monthly => 'Monthly',
    RecurrenceRule.yearly => 'Yearly',
    RecurrenceRule.custom => 'Custom',
  };
}

/// The "Repeats ..." sentence shown on `ReminderDetailScreen` — `null` for
/// [RecurrenceRule.none] since a non-repeating reminder shows no repeat
/// label at all.
String? recurrenceRepeatsLabel(RecurrenceRule rule) {
  return switch (rule) {
    RecurrenceRule.none => null,
    RecurrenceRule.daily => 'Repeats daily',
    RecurrenceRule.weekdays => 'Repeats on weekdays',
    RecurrenceRule.weekly => 'Repeats weekly',
    RecurrenceRule.monthly => 'Repeats monthly',
    RecurrenceRule.yearly => 'Repeats yearly',
    RecurrenceRule.custom => 'Repeats (custom)',
  };
}

/// The rules exposed by the New/Edit form's picker. [RecurrenceRule.custom]
/// is deliberately excluded: `Reminders.customRule` has no defined rule
/// language anywhere in the codebase (see
/// `recurrence_calculator.dart`'s doc comment and
/// `reminders_table.dart`'s `customRule` column comment — "reserved for a
/// future rule-language... unused by any UI in this pass"), so offering it
/// as a selectable option would let a user pick a repeat behavior that
/// silently falls back to one-time completion (see
/// `RemindersRepository.setCompleted`'s custom-recurrence fallback) —
/// broken by omission, not by design. Revisit once a rule language exists.
const selectableRecurrenceRules = [
  RecurrenceRule.none,
  RecurrenceRule.daily,
  RecurrenceRule.weekdays,
  RecurrenceRule.weekly,
  RecurrenceRule.monthly,
  RecurrenceRule.yearly,
];
