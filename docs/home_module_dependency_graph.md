# Home Module — Push Navigation Feature Dependency Graph

Companion to `docs/architecture.md`/`docs/routes.md`. Covers only the features added by the Home push-navigation completion pass (see `implemented_features.md`'s "Module 3: Home Push Navigation" section) — not the 7 dashboard sections themselves, which are already fully specified in `architecture.md`.

## Purpose

Written before any code in this pass so the phase breakdown's parallelism is a deliberate read of dependencies, not something discovered ad hoc mid-implementation. Every feature below is classified `blocking` (must land before dependents can start), `shared` (infrastructure multiple features consume but doesn't itself gate any one feature's start), or `independent` (buildable in isolation once its blocking dependency lands).

## Graph

```
Root Navigator Plumbing  [BLOCKING]
│   (_rootNavigatorKey + parentNavigatorKey on nested /home routes,
│    app_router.dart + route_paths.dart)
│
├── PushedScreenLayout  [SHARED]
│   │   (Scaffold → SafeArea → Header → Expanded(content) → Bottom CTA)
│   │
│   ├── Search Stub → Search (real)        [INDEPENDENT]
│   │   ├── SearchableEntity (model)
│   │   ├── search_providers.dart (searchQueryProvider, searchableEntitiesProvider, searchResultsProvider)
│   │   ├── Hero('search-morph') — shared tag with HomeHeroSection's search icon
│   │   ├── reads: kRecentNotes, kMyLists, kUpNext (existing mock consts)
│   │   └── navigates: goNamed(5 tab routes) / pop()
│   │
│   ├── NotificationsPlaceholderScreen  [INDEPENDENT]
│   │   └── no providers, no navigation out
│   │
│   ├── ProfilePlaceholderScreen  [INDEPENDENT]
│   │   └── no providers, no navigation out
│   │
│   ├── New Note Screen  [INDEPENDENT]
│   │   ├── CreateNoteRequest (model)
│   │   ├── note_providers.dart (NoteRequestsNotifier)
│   │   └── uses: PrimaryButton
│   │
│   ├── New Reminder Screen  [INDEPENDENT]
│   │   ├── CreateReminderRequest (model)
│   │   ├── reminder_providers.dart (ReminderRequestsNotifier)
│   │   └── uses: PrimaryButton
│   │
│   ├── New Expense Screen  [INDEPENDENT]
│   │   ├── CreateExpenseRequest (model)
│   │   ├── expense_providers.dart (ExpenseRequestsNotifier)
│   │   └── uses: PrimaryButton
│   │
│   ├── New Habit Screen  [INDEPENDENT]
│   │   ├── CreateHabitRequest (model)
│   │   ├── habit_providers.dart (HabitRequestsNotifier)
│   │   └── uses: PrimaryButton
│   │
│   └── Timeline Detail Screen  [INDEPENDENT — but see Timeline Dismiss below]
│       ├── reads: timelineProvider (existing)
│       ├── calls: TimelineNotifier.dismiss(id)  [needs Timeline id + dismiss() first]
│       └── uses: PrimaryButton, EmptyState (existing)
│
├── Quick Actions Wiring  [DEPENDS ON: all 4 New-*-Screens above]
│   └── home_section_registry.dart: onActionTap map (const {} → 4 real entries)
│
├── Hero Icon Wiring  [DEPENDS ON: Search/Notifications/Profile routes existing]
│   └── home_screen.dart: HomeHeroSection(onSearchTap, onNotificationsTap, onAvatarTap)
│
├── Timeline / Up Next id + dismiss()  [BLOCKING for: Timeline Detail Screen, Dismissible wiring]
│   ├── dashboard_card_data.dart: add `id` to UpNextItem, TimelineStep
│   ├── mock_dashboard_data.dart: add id values to kUpNext, kTimeline
│   └── home_providers.dart: UpNextNotifier.dismiss(), TimelineNotifier.dismiss()
│
├── UpNextCard Dismissible wiring  [DEPENDS ON: Timeline/Up Next id+dismiss()]
├── TimelineStepperCard long-press wiring  [DEPENDS ON: Timeline/Up Next id+dismiss()]
│
└── HomeSectionMeta metadata extension (enabled/collapsed/priority)  [INDEPENDENT]
    └── home_section_registry.dart — pure data-shape addition, no rendering changes,
        no dependency on anything else in this graph or vice versa.
```

## Classification summary

| Feature | Class | Blocks | Blocked by |
|---|---|---|---|
| Root navigator plumbing | blocking | everything below | — |
| `PushedScreenLayout` | shared | every new screen | root navigator plumbing (needs routes to push to, to be testable) |
| Search (stub → real) | independent | Hero icon wiring (search) | root nav, `PushedScreenLayout` |
| Notifications/Profile stubs | independent | Hero icon wiring (notifications/avatar) | root nav, `PushedScreenLayout` |
| New Note/Reminder/Expense/Habit screens | independent (of each other) | Quick Actions wiring | root nav, `PushedScreenLayout` |
| Quick Actions wiring | — | — | all 4 New-*-Screens |
| Hero icon wiring | — | — | Search + Notifications + Profile routes |
| Timeline/Up Next id + `dismiss()` | blocking | Timeline Detail Screen, Dismissible/long-press wiring | root nav (route only, not the data change itself) |
| Timeline Detail Screen | independent | — | Timeline/Up Next id+dismiss(), root nav, `PushedScreenLayout` |
| `UpNextCard`/`TimelineStepperCard` dismiss wiring | — | — | Timeline/Up Next id+dismiss() |
| `HomeSectionMeta` metadata extension | independent | (future Settings screen, out of this pass's scope) | nothing in this graph |

## What this makes legible

- The 4 Quick Action screens, Search, and the 2 placeholder stubs can all be built in parallel by different people/sessions once root navigator plumbing + `PushedScreenLayout` exist — they share no providers or files with each other.
- `HomeSectionMeta`'s extension has zero coupling to anything else here and could be done at any point, including entirely outside this pass's phase order, without risk.
- Timeline/Up Next's `id`+`dismiss()` data-layer change is the one non-navigation blocking dependency in this pass — it must land before either the Dismissible/long-press UI wiring or the Timeline Detail Screen, which is why the plan places it in its own phase (Phase 4) rather than folding it into Phase 1's navigation-plumbing phase.

## Maintenance

Update this graph if a future phase adds a feature that crosses these boundaries (e.g. if Search's `SearchableEntity` index later gets populated by a real Reminders/Health/Finance/Documents repository, add an edge from that module to `search_providers.dart` at that time).
