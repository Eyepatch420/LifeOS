# Implemented Features (Module 1)

- [x] Pubspec dependencies added, assets reorganized (`assets/svg/`, `assets/lottie/`, `assets/rive/`), docs initialized
- [x] Folder tree scaffolded
- [x] Strict lint rules applied (`analysis_options.yaml`)
- [x] Core scaffolding (error types, constants, services, empty `AppDatabase`/`AppMetadata` table)
- [x] GetIt service locator wired (`config/di/service_locator.dart`, `config/di/core_providers.dart`)
- [x] Domain models (`UserProfile`, `OnboardingPage`, `DashboardCardData` family, `WorkspaceTheme`, `UserSetupFormState`) — Freezed codegen verified
- [x] Theme engine (`WorkspaceTheme`, `AppColorsExtension` with real `lerp()`, time-of-day tint, `AnimatedTheme`-driven workspace switching)
- [x] Routing shell (`GoRouter` + `StatefulShellRoute.indexedStack`, redirect logic, `FadeThroughTransition` page transitions)
- [x] `UserProfileRepository` (SharedPreferences + secure storage split) + `UserProfileNotifier.completeSetup()` orchestration — unit tested
- [x] Splash screen (code-driven fade/scale/gradient animation, no Rive yet)
- [x] Onboarding (single-layout illustration morph + independent text crossfade + `ProgressDots`, 3 real Lottie assets, Skip/Next/Get Started)
- [x] User Setup screen (name, avatar picker, accent selector, theme mode selector, reminder/biometric toggles, capability-checked biometric enable)
- [x] `FloatingBottomNav` (custom Stack/BackdropFilter/AnimatedAlign pill) + `AppShell` wiring tab taps to nav index + workspace theme
- [x] Home hero section (SVG background, time-of-day tint scrim, dark-mode scrim, greeting/date/search/notification/avatar row)
- [x] Remaining Home dashboard sections (motivational banner, overview stats, quick actions, up next, habit streaks, timeline, recent notes, my lists) with staggered entrance animation, mobile/tablet responsive reflow
- [x] Placeholder scaffolds for Reminders/Health/Finance/Documents tabs
- [x] Biometric gate (`BiometricGate` widget wrapper, in-memory per-session auth state, capability check before enabling)
- [x] Verified via `flutter analyze` (clean), `flutter test` (19 tests passing), `flutter build macos` (succeeds), and a live macOS run with no runtime exceptions
- [ ] Deeper cross-cutting accessibility/performance audit (DevTools profiling) — see future_work.md
- [ ] Animation timing polish pass against docs/animation_spec.md — core motion system is in place and used throughout; further hand-tuning is a fast-follow, not a blocker

## Onboarding & Setup Refinement Pass

- [x] `core/animations/presets.dart` — named motion presets by interaction category (Page Enter, Card Enter/Exit, FAB, Button, Hero, Bottom Nav, Section, Timeline, Dialog, Bottom Sheet, Onboarding Illustration)
- [x] `OnboardingAccent` model + `OnboardingAccentTween` — per-page accent (Planning=Blue, Security=Slate, Wellness=Green), animated via a single `TweenAnimationBuilder` scoped to `OnboardingScreen`'s own subtree, independent from workspace/dark-mode theming
- [x] `OnboardingIllustrationMorph` rewritten — outgoing illustration now fully exits (pixel-based `Transform.translate` by the full available width, not a fractional `SlideTransition`), incoming starts fully off-screen at 85% scale; both animate simultaneously for a genuine hand-off feel. Reduce Motion falls back to a plain crossfade.
- [x] Onboarding title/subtitle transition — explicit fade + slide-up `transitionBuilder`, independent of the illustration's timing, with a Reduce Motion fallback
- [x] `PrimaryButton` — added `color` override, desktop hover (scale + shadow lift via `MouseRegion`), an explicit animated disabled state (`AnimatedOpacity`, not just Material's default dimming), Reduce Motion fallback on the hover scale
- [x] `ProgressDots` — added `color` override so onboarding's per-page accent drives the active dot
- [x] `PressableScale` — now Reduce-Motion aware (skips the press scale, keeps the tap working)
- [x] `AccentColorSelector` upgraded from plain color circles to preview cards (icon + gradient swatch + label) per workspace
- [x] Setup screen accent/theme-mode selectors now live-preview against the real app theme (`currentWorkspaceProvider`/`themeModeProvider`) immediately on tap, not just after Finish Setup
- [x] `UserProfileNotifier.completeSetup()` — added a defensive final sync of `currentWorkspaceProvider`/`themeModeProvider` so the live theme is correct even for callers that bypass the setup screen's live-preview UI
- [x] Finish Setup button enablement hardened — explicit `ValueListenableBuilder` on the name controller, replacing the previous implicit reliance on an unrelated provider rebuild
- [x] Fixed the `/user-setup` → `/home` transition — the Home branch's `GoRoute` now uses an explicit `pageBuilder`/`FadeThroughTransition` (a bare `StatefulShellRoute` has no `pageBuilder` of its own, so this hop previously fell back to the platform default transition)
- [x] Home Dashboard prop-drilling audited — confirmed every section widget already receives its data slice via constructor params rather than reading `dashboardMockDataProvider` directly; no code change needed, boundary is already correct for future per-section providers
- [x] Verified via `flutter analyze` (clean), `flutter test` (38 tests passing), `dart format .` + `dart fix --apply` (clean), `build_runner` (clean), `flutter build macos` (succeeds), and a live macOS run with no runtime exceptions

## Module 2: Home Workspace

- [x] `AppSpacing` design tokens (`core/constants/app_spacing.dart`) — retrofitted into every Home widget + `SectionCard`/`StatCard`/`CircularActionButton`, replacing scattered raw `EdgeInsets`/size literals
- [x] `EmptyState` + `SectionLoadingPlaceholder` shared widgets (`shared/widgets/feedback/`) — every Home section now renders a graceful empty state instead of silently showing "header + nothing"
- [x] Fixed a real crash: `OverviewStatsRow`'s `crossAxisCount` could reach 0 on an empty stat list at tablet width (`SliverGridDelegateWithFixedCrossAxisCount` rejects 0) — now short-circuits to `EmptyState` plus a defensive `.clamp(1, 4)`
- [x] Overview Cards renamed to Tasks/Habits/Focus/Mood (from the Module 1 placeholder set); Quick Actions renamed to New Note/Reminder/Expense/Habit/Document, with `QuickAction.id` added and `QuickActionsRow` wired to a real (if currently empty-bodied) `onActionTap` callback map + `onViewAll`
- [x] Provider architecture split into 7 per-section `AsyncNotifier<List<T>>`s (was one synchronous `Provider<DashboardMockData>`) — loading/empty/error all fall out of `AsyncValue` for free; a real backend later is a `build()`-body-only change
- [x] `HomeSectionMeta` + `homeSectionsProvider` — the customizable-workspace seam: every section has independent `order`/`visible` state via one provider, with `displayName`/`icon`/`supportsCustomization` ready for a future Settings screen to render its toggle checklist directly from this registry, no duplicated metadata, no `HomeScreen` refactor needed later
- [x] `HomeHeroSection` fully normalized to props-only (was the one `ConsumerWidget` exception reading `clockTickProvider`/`userProfileNotifierProvider` directly) — `HomeScreen` now resolves and passes greeting/date/name/tint/message down, matching every other section widget
- [x] `GradientHeroBackground` — added an `assetPath` param (defaults to the existing SVG, zero call-site breakage) and a `MorphSwitcher`-based tint cross-fade between time-of-day buckets (was an instant snap); confirmed the SVG/`BoxFit.cover`/responsive-height/`RepaintBoundary` composition was already correct and left unchanged
- [x] Fixed `TimelineStepperCard`'s inert stagger bug — `StaggeredEntrance` previously wrapped the whole step `Row` as one child (stagger never actually staggered); now each step fades in individually via `Stagger.delayForIndex`
- [x] `MotivationalBanner` rewritten to be data-driven (`message` prop, was hardcoded) with optional `onTap` XOR `onDismiss`
- [x] `HomeScreen` consolidated onto `ResponsiveBuilder` (replacing two duplicated inline `LayoutBuilder` blocks) and now builds its body by mapping over `homeSectionsProvider`'s sorted/filtered list, looking up each visible section's builder from `home_section_registry.dart`
- [x] Animation retrofit: `AnimatedStreakRing` and the timeline stagger now route through `AppMotionPresets`; hero content gets a `FadeSlideIn` entrance it previously lacked entirely
- [x] Accessibility: added a missing `Semantics(button: true)` wrap on `MotivationalBanner`'s tappable state
- [x] Verified via `flutter analyze` (clean), `flutter test` (81 tests passing, 43 new), `dart format .` + `dart fix --dry-run` (clean), `build_runner` (clean), `flutter build macos` (succeeds), and a live macOS run with no runtime exceptions — including a `HomeScreen` test that overrides `homeSectionsProvider` to hide a section and reorder another, proving the customization mechanism works end-to-end with zero section-specific code in `HomeScreen`

## Known deviations from the original prompt

- **State management**: upgraded from the originally planned `flutter_riverpod ^2.6.1`/`riverpod_annotation ^2.6.1` to `^3.0.0`/`^4.0.0` — the 2.x codegen line transitively pulled an `analyzer_plugin` version incompatible with this Flutter SDK's bundled analyzer, which broke `build_runner` entirely. Confirmed with the user before upgrading.
- **Freezed**: bumped to `^3.0.0` for the same reason (dependency chain compatibility with the Riverpod 3.x/build 3.x line).
- **riverpod_lint/custom_lint**: not enabled — see `future_work.md`.
- **Avatar picker**: uses a small set of built-in Material-icon avatars rather than custom illustrated avatar art, since no avatar assets were supplied.
