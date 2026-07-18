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
  static const String newExpense = 'new-expense';
  static const String search = 'search';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String timelineDetail = 'timeline/:stepId';
  static const String notes = 'notes';
  static const String noteDetail = 'notes/:noteId';
  static const String noteEdit = 'notes/:noteId/edit';
  static const String lists = 'lists';
  static const String listDetail = 'lists/:listId';

  // Nested under the Reminders branch's own `/reminders` route (not Home's)
  // — the Reminders workspace owns its full CRUD route surface. Static
  // children (`all`, `new`) are declared before the dynamic `:reminderId`
  // child in app_router.dart's `routes:` list so go_router's route matching
  // (which tries routes in declaration order) prefers the static match for
  // `/reminders/all` and `/reminders/new` over treating "all"/"new" as a
  // `:reminderId` value — see app_router.dart.
  // `planner` is declared (and, in app_router.dart, registered) before the
  // dynamic `:reminderId` child below for the same reason `all`/`new` are —
  // go_router tries routes in declaration order, so `/reminders/planner`
  // must match this static child first instead of being captured as
  // `:reminderId` = "planner".
  static const String remindersAll = 'all';
  static const String newReminder = 'new';
  static const String planner = 'planner';
  static const String reminderDetail = ':reminderId';

  // Habits workspace — nested under the Reminders branch's own `/reminders`
  // route (not a top-level bottom-nav branch), the same shell Planner uses,
  // since Habits is a `PlanningWorkspaceScaffold` section, not its own
  // shell. `habits`/`newHabit` are declared as siblings of `planner` before
  // the dynamic `:habitId` child for the same static-before-dynamic reason
  // as above. `newHabit` replaces the old Module-3 mock-backed
  // `/home/new-habit` route (deleted in Phase 6) — same route *name*
  // (`RouteNames.newHabit`), new path/destination, so `newHabit` isn't
  // reused twice under two different meanings.
  static const String habits = 'habits';
  static const String newHabit = 'habits/new';
  static const String habitDetail = 'habits/:habitId';
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
  static const String remindersAll = 'remindersAll';
  static const String planner = 'planner';
  static const String habits = 'habits';
  static const String habitDetail = 'habitDetail';
}
