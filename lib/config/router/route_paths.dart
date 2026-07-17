/// Static route path/name constants — single source of truth so no feature
/// hardcodes a raw path string.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String userSetup = '/user-setup';

  static const String home = '/home';
  static const String reminders = '/reminders';
  static const String health = '/health';
  static const String finance = '/finance';
  static const String documents = '/documents';

  // Pushed on top of Home via the root navigator (see app_router.dart's
  // `parentNavigatorKey` routes) — relative segments, nested under `/home`.
  static const String newNote = 'new-note';
  static const String newReminder = 'new-reminder';
  static const String newExpense = 'new-expense';
  static const String newHabit = 'new-habit';
  static const String search = 'search';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String timelineDetail = 'timeline/:stepId';
  static const String notes = 'notes';
  static const String noteDetail = 'notes/:noteId';
  static const String noteEdit = 'notes/:noteId/edit';
  static const String lists = 'lists';
  static const String listDetail = 'lists/:listId';
  static const String reminderDetail = 'reminders/:reminderId';
}

abstract final class RouteNames {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String userSetup = 'userSetup';
  static const String home = 'home';
  static const String reminders = 'reminders';
  static const String health = 'health';
  static const String finance = 'finance';
  static const String documents = 'documents';

  static const String newNote = 'newNote';
  static const String newReminder = 'newReminder';
  static const String newExpense = 'newExpense';
  static const String newHabit = 'newHabit';
  static const String search = 'search';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String timelineDetail = 'timelineDetail';
  static const String notes = 'notes';
  static const String noteDetail = 'noteDetail';
  static const String noteEdit = 'noteEdit';
  static const String lists = 'lists';
  static const String listDetail = 'listDetail';
  static const String reminderDetail = 'reminderDetail';
}
