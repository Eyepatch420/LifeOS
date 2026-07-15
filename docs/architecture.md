# Architecture

## Layers

LifeOS follows Clean Architecture, feature-first, with MVVM in the presentation layer and the Repository pattern in the data layer.

- **Presentation** (`features/<feature>/presentation/`): screens, widgets, and Riverpod providers/notifiers (the "ViewModel" in MVVM). No direct storage access — only through repositories.
- **Domain** (`features/<feature>/domain/`): Freezed models and repository *interfaces*. Pure Dart, no Flutter/plugin imports. Use cases are only introduced when a flow has genuine multi-step orchestration (see `UserProfileNotifier.completeSetup()`); trivial reads/writes go straight through the repository.
- **Data** (`features/<feature>/data/`): repository *implementations*, wrapping the services in `lib/services/` (SharedPreferences, secure storage) or `core/database/` (Drift, once real tables exist).

## State management vs. dependency injection

- **GetIt** (`config/di/service_locator.dart`) owns raw singletons with no reactive state of their own: `SharedPreferences`, `FlutterSecureStorage`, `AppDatabase`, `LocalAuthentication`.
- **Riverpod** owns everything with app state derived from those singletons: repositories, notifiers, derived UI providers. Riverpod providers pull from GetIt — never the reverse.
- This keeps Riverpod providers overridable in tests while GetIt stays a dumb resolver with no scoping complexity.

## Why Drift is deferred in Module 1

Module 1's only persisted data (`UserProfile`) is entirely scalar with no relations — SharedPreferences is the right fit. `core/database/app_database.dart` is scaffolded now (proving the connection/codegen pipeline) so Module 2 (Reminders, Notes, Expenses — which have real relational shape) doesn't pay a first-time setup cost on top of its actual feature work.

## Theme engine

See `theme.md`.

## Routing

See `routes.md`.

## `completeSetup()`'s defensive theme sync (refinement pass)

`UserProfileNotifier.completeSetup()` remains the single orchestration point for finishing setup (validate → check biometric capability → persist profile → mark onboarding complete), but it was extended with a defensive final sync of `currentWorkspaceProvider`/`themeModeProvider` to the values just persisted. This doesn't duplicate the setup screen's live-preview wiring (which already pushes the same values as the user interacts) — it guarantees correctness for any caller that invokes `completeSetup()` without going through that specific UI path (unit tests, or a future "edit profile" flow reusing the same method). This is still a single method, not a new UseCase class, consistent with the project's existing "skip UseCase ceremony for orchestration that fits one method" pattern.

## Widget placement rule (refinement pass)

Never create a widget because one screen needs it — only place a widget in `shared/` if it could reasonably be reused by a future module; otherwise it lives inside the owning feature folder with a short comment noting why. Applied during this pass: `OnboardingAccent`/`OnboardingAccentTween` live in `features/onboarding/domain/models/` (onboarding-specific, nothing else consumes them yet), while `PrimaryButton`'s and `ProgressDots`' new `color` params extend already-shared widgets (correctly shared, since future modules will want colored buttons/dots too).

## Module 2: Home Workspace architecture

The Home Dashboard from Module 1 was hardened into a **customizable workspace** — the blueprint every future module's own dashboard/list screen should copy. Three structural pieces:

### Per-section `AsyncNotifier`s, not a single bundle provider

Module 1's single `dashboardMockDataProvider` (`Provider<DashboardMockData>`) is gone. Each of the 7 sections (Overview, Quick Actions, Up Next, Habit Streaks, Timeline, Recent Notes, My Lists) now has its own `AsyncNotifier<List<T>>` in `home_providers.dart` (e.g. `OverviewStatsNotifier`/`overviewStatsProvider`). `build()` currently just resolves a mock const, but because it's already `AsyncValue`-shaped, "loading" (`AsyncLoading`), "empty" (`AsyncData([])`), and "error" (`AsyncError`) all fall out of Riverpod's existing machinery for free — swapping in a real repository call later (Module 3+) is purely a `build()` body change, no call-site changes anywhere. `_unwrapList()` in `home_section_registry.dart` is the one place that turns an `AsyncValue` into a widget (loading placeholder / error-as-empty / populated), so section widgets themselves never see `AsyncValue` at all — they still just take `List<T>`.

### `HomeSectionMeta` + `homeSectionsProvider` — the customization seam

`HomeSectionMeta` (`features/home/domain/models/home_section_config.dart`) is a plain, non-Freezed immutable class holding `id`, `order`, `visible`, `displayName`, `icon`, `supportsCustomization`, `analyticsName` for one dashboard section. `homeSectionsProvider` (a `NotifierProvider<HomeSectionsNotifier, List<HomeSectionMeta>>`) holds the list of all 7, defaulting to `kDefaultHomeSections`. `HomeScreen` sorts this list by `order`, filters to `visible`, and renders. **No settings UI writes to this yet** — but a future one is a one-line `homeSectionsProvider.notifier.reorder([...])`/`.setVisible(id, false)` call, and it can render its own toggle checklist directly from `displayName`/`icon`/`supportsCustomization` with zero duplicated metadata. This is proven end-to-end by `test/features/home/presentation/screens/home_screen_test.dart`, which overrides `homeSectionsProvider` to hide a section and to reorder one, and confirms `HomeScreen` reflects both with no code path specific to any section.

Builder closures (the actual widget-construction logic per section, which needs a live `WidgetRef` to watch each `AsyncNotifier`) are deliberately **not** stored on `HomeSectionMeta` — they live in a separate `buildHomeSectionBuilders(WidgetRef ref)` map in `home_section_registry.dart`, built fresh each `HomeScreen.build()`. This split exists because a `Notifier`'s `ref` (a `Ref`) and a widget's `ref` (a `WidgetRef`) are different, non-interchangeable types in Riverpod — keeping `homeSectionsProvider`'s state as plain data (no closures) means it stays trivial to test and, later, to persist.

### `HomeHeroSection` fully normalized to props-only

Module 1 left `HomeHeroSection` as the one exception reading providers directly (`clockTickProvider`, `userProfileNotifierProvider`). Module 2 removed that exception: it's now a plain `StatelessWidget` taking `greeting`/`dateLabel`/`userName`/`tint`/`motivationalMessage` (+ optional tap callbacks) as props. `HomeScreen` reads the clock/profile/motivational-message providers and passes the resolved values down — every Home widget, hero included, now follows the identical "props in, no provider reads" pattern.

### Paired sections stay paired under reordering

The Up Next/Habit Streaks tablet side-by-side pair and the Recent Notes/My Lists pair are each registered as **one** `HomeSectionMeta`/builder entry (`upNextAndHabits`, `notesAndLists`), not two independent ones — so their `ResponsiveBuilder` phone/tablet layout survives reordering as a unit. Un-pairing them (making all 4 independently reorderable) is deferred until a real settings UI and design calls for it.
