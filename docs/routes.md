# Route Map

```
/splash                    (initial location)
/onboarding
/user-setup

/                          StatefulShellRoute.indexedStack
  ├─ /home                 branch 0
  ├─ /reminders            branch 1 — real (Reminders/Planner/Habits workspace, see below)
  ├─ /health               branch 2 (placeholder)
  ├─ /finance              branch 3 (placeholder)
  └─ /documents            branch 4 (placeholder)
```

## Reminders branch (`/reminders`) — Reminders/Planner/Habits workspace

Branch 1 hosts three fully functional `PlanningWorkspaceScaffold` sections
(Reminders, Planner, Habits — Calendar remains a non-navigating
workspace-nav placeholder). All child routes below are
`parentNavigatorKey: _rootNavigatorKey` (root-navigator pushes) except the
branch root itself:

```
/reminders                    RemindersDashboardScreen (branch root)
  /reminders/all               RemindersListScreen
  /reminders/new                NewReminderScreen (optional initialDate via state.extra)
  /reminders/planner            PlannerScreen
  /reminders/habits              HabitsDashboardScreen
  /reminders/habits/new          NewHabitScreen
  /reminders/habits/:habitId     HabitDetailScreen
  /reminders/:reminderId         ReminderDetailScreen
```

Static children (`all`, `new`, `planner`, `habits`, `habits/new`) are
declared before the dynamic `:reminderId` child in `app_router.dart`'s
`routes:` list — go_router tries routes in declaration order, so e.g.
`/reminders/habits` matches the static route first instead of being
captured as `:reminderId` = `"habits"`. Within the Habits sub-tree,
`habits/new` is likewise declared before `habits/:habitId` for the same
reason.

## Redirect logic

- Reads a synchronous `onboardingCompleteProvider` (hydrated from `SharedPreferences` before `runApp`).
- Onboarding incomplete + location not `/onboarding`/`/user-setup`/`/splash` → redirect to `/onboarding`.
- Onboarding complete + location is `/onboarding`/`/user-setup` → redirect to `/home`.
- Splash does **not** self-redirect via router logic — it runs its animation on a timer and calls `context.goNamed(...)` explicitly.
- Biometric gating is handled by `BiometricGate` wrapping the shell builder, not by router redirects.

## Page transitions

Top-level routes use `CustomTransitionPage` wrapping `FadeThroughTransition` (see `core/animations/page_transitions.dart`), not GoRouter's default platform transition.

`StatefulShellRoute` itself has no `pageBuilder` — only the individual `GoRoute`s nested inside each `StatefulShellBranch` do. The Home branch's `GoRoute` is given an explicit `pageBuilder` using `buildFadeThroughPage` so the `/user-setup` → `/home` hop (and any other navigation landing on `/home`) gets the same fade-through treatment as the rest of the app, rather than falling back to the platform default transition. The other 4 placeholder branches still use plain `builder` (no premium transition needed for stub screens).

## Future module placeholders

`/health`, `/finance`, `/documents` currently render a shared `PlaceholderScaffold(title, workspaceId)`. Each will be replaced by real feature routes in later modules — the route paths and shell structure are expected to remain stable.

## Home push routes (Module 4 Phase 2)

Nested under `/home`, all `parentNavigatorKey: _rootNavigatorKey` (root-navigator pushes, hides `FloatingBottomNav`), all built on `PushedScreenLayout`:

```
/home/notes                  NotesListScreen
/home/notes/:noteId          NoteDetailScreen
/home/notes/:noteId/edit     NoteEditScreen
/home/lists                  ListsScreen
/home/lists/:listId          ListDetailScreen
```

Route order in `app_router.dart` declares `noteEdit` before `noteDetail` — go_router disambiguates by segment count (`notes/:id/edit` has 3 segments vs. `notes/:id`'s 2), so this isn't order-sensitive, but kept in that order for readability.
