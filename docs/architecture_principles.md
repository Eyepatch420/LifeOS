# Architecture Principles

Companion to `docs/architecture.md`. These rules govern how every feature module beyond Home is built, starting with Module 4 (Home Module Completion — see `docs/home_module_dependency_graph.md` for the phased roadmap). They exist because LifeOS is not Home-centric: Home is one of five bottom-nav modules and is a dashboard only. It owns almost nothing.

## The core rule

```
Feature UI → Riverpod → Repository → Feature Contract (Summary DTO) → Dashboard Provider (feature-owned) → Home Dashboard
```

**Home never owns feature data. It consumes feature-owned dashboard summary providers only — never repositories, entities, DAOs, or screens.**

## Feature classification

Every feature is exactly one of three types.

**Type A — Standalone Feature.** Owns everything: entity, table, DAO, repository, providers, list/detail/edit screens, delete/undo, share, search contribution, notification contribution. Examples: `notes`, `lists`, `reminders`, `habits`, `expenses`, `mood`. Lives under `features/<name>/`. Home consumes only its dashboard summary provider.

**Type B — Shared/Global Feature.** Consumed by multiple modules now or later; never lives under `features/home/`. Examples: `search`, `notifications`, `focus`, `profile`, `settings` (plus theme/workspace, already under `lib/theme/`). Health/Finance/Documents/Settings will all consume these later. Home merely launches or displays them.

**Type C — Dashboard-only.** Exists only because Home exists; stays in `features/home/`. Examples: greeting/hero, overview cards, motivational banner, section registry, summary mappers. The rendering of shared aggregations (agenda/timeline) is Type C; the aggregation logic itself is shared (Type B–adjacent, lives under `core/` or its own feature).

## Architecture constraints (the guardrails)

1. **Home imports only dashboard summary providers**, never feature repositories or entities. Home doesn't know `Note`, markdown, pin, undo, or share exist — only `RecentNotesSummary`.
2. **Every Type A feature exposes exactly five things** (its contract): **Entity · Repository · Dashboard Provider · Search Contributor · Notification Contributor.** Nothing else is imported cross-feature.
3. **Cross-feature communication happens ONLY through**: dashboard summary providers, Search contributors, Agenda contributors, Planner contributors, Notification events, and shared services (`core/services/`).
4. **Settings never stores anything** — it is UI only, editing existing providers (theme, focus, notifications, home sections, quick actions).
5. **Repositories never create notifications.** They emit domain events (`ReminderCreated`, `ReminderOverdue`, `HabitCompleted`, `ExpenseDue`, …); the NotificationEngine consumes events. Analytics/achievements/widgets/AI summaries later consume the same event stream.
6. **Every Type A feature must be completely removable without breaking compilation of any unrelated feature.** Deleting `features/notes` should only break notes' own registration, routes, and provider wiring at the composition layer (`config/di/`, `app_router.dart`, the registries) — never Home, Search, Settings, or any other feature's source. A cascading failure elsewhere is a coupling bug to fix, not an acceptable exception. An import-boundary test (introduced alongside the Notes feature — see `docs/home_module_dependency_graph.md` Phase 2A) enforces this automatically by scanning `lib/features/*/` import graphs.

## Notes as the canonical Type A implementation

The Notes feature (Phase 2B) is deliberately built in isolation before any other Type A feature, and every later feature (Reminders, Habits, Expenses, Mood, Lists, and future modules) copies its folder layout, entity/repository/DTO naming, and how the five-part contract is satisfied — verbatim, not reinvented per feature. Favor reusable patterns over feature-specific optimizations: if a pattern can't reasonably be copied to every future Type A feature, reconsider the design before implementing it, not after.

## Toward a DashboardRegistry (forward-looking, not required yet)

Home's registry currently evolves to hold contribution-based `DashboardSection`s (Phase 2D) but still names each feature's dashboard provider explicitly (`notesDashboardProvider`, `listsDashboardProvider`, …). The longer-term direction — once 3+ features exist to prove the pattern against — is a `DashboardContributor` interface mirroring `SearchContributor`/`AgendaContributor`, so a feature registers its card/tile/statistic and Home's registry becomes pure `sort → render` with zero per-feature provider names hardcoded anywhere. Not a Phase 2 requirement; noted here so it isn't lost.

## LifeOS Golden Rule

> No feature may import another feature's repository, DAO, entity, or screen.

Cross-feature communication must happen only through:
- Dashboard Summary Providers
- Search Contributors
- Agenda Contributors
- Planner Contributors
- Notification Events
- Shared Services

## Planner Contributors (added Module 4 Phase 6)

Once a second real Type A feature (Habits) needed to appear in the Planner day-timeline alongside Reminders, `PlannerContributor` (`core/planner/planner_contributor.dart`) was introduced as a fourth contributor-style seam, mirroring `SearchContributor`/`NotificationContributor`/`AgendaContributor`'s shape exactly: an interface exposing a live `Stream<List<PlannerItem>>` plus a feature-specific `complete()` operation, registered at `config/di/planner_contributor_registrations.dart` (the only place allowed to import every feature's contributor). `PlannerItem` itself lives in `core/planner/` (not a feature) for the same reason `AgendaEntry`/`SearchableEntity` do — a feature-owned type can't be imported by a second feature without violating the Golden Rule above. `PlannerScreen` and its providers only ever see `List<PlannerItem>`; adding a third source (e.g. Events) is a new contributor + one registration line, never a `PlannerScreen` change.

## Other standing rules (unchanged from Module 1–3)

- Extend, never replace existing providers/architecture.
- Shared motion system only (`AppDurations`/`AppCurves`/`AppMotionPresets`) — no raw `Duration(...)`/`Curves.*` literals.
- No hardcoded colors — always through `AppColorsExtension`/theme.
- `SafeArea(top: true, bottom: true)` on every pushed screen, via `PushedScreenLayout`.
- Tests ship alongside each feature, not in a later batch pass.
