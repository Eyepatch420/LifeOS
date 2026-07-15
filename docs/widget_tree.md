# Widget Inventory

Lightweight status index — see `component_inventory.md` for the detailed per-widget reference (purpose/dependencies/animations/consumers).

| Widget | Location | Status | Consumed by |
|---|---|---|---|
| `PrimaryButton` | `shared/widgets/buttons/` | implemented (extended: `color` override, hover, disabled state) | onboarding, user_setup |
| `CircularActionButton` | `shared/widgets/buttons/` | implemented | home (quick actions) |
| `StatCard` | `shared/widgets/cards/` | implemented | home (overview stats) |
| `SectionCard` | `shared/widgets/cards/` | implemented | home (Up Next, Habit Streaks, Recent Notes, My Lists) |
| `SectionHeader` | `shared/widgets/cards/` | implemented | home, quick actions |
| `FloatingPageLayout` | `shared/widgets/layouts/` | implemented | app shell / home |
| `HeroScaffold` | `shared/widgets/layouts/` | implemented | home |
| `FloatingBottomNav` | `shared/widgets/nav/` | implemented | app shell |
| `LottieIllustration` | `shared/widgets/media/` | implemented | onboarding |
| `GradientHeroBackground` | `shared/widgets/media/` | implemented (extended: `assetPath` param, `MorphSwitcher` tint cross-fade) | home |
| `ProgressDots` | `shared/widgets/indicators/` | implemented (extended: `color` override) | onboarding |
| `AnimatedStreakRing` | `shared/widgets/indicators/` | implemented (routed through `AppMotionPresets.section`) | home (my lists) |
| `PlaceholderScaffold` | `shared/widgets/scaffolds/` | implemented | reminders, health, finance, documents |
| `EmptyState` | `shared/widgets/feedback/` | implemented | all 7 Home section widgets |
| `SectionLoadingPlaceholder` | `shared/widgets/feedback/` | implemented | `home_section_registry.dart`'s `AsyncValue` loading branch |
| `AvatarPickerGrid` | `features/user_setup/presentation/widgets/` | implemented | user_setup |
| `ThemeModeSelector` | `features/user_setup/presentation/widgets/` | implemented | user_setup |
| `AccentColorSelector` | `features/user_setup/presentation/widgets/` | implemented (upgraded: icon + gradient + label preview cards, was plain color circles) | user_setup |
| `SetupToggleTile` | `features/user_setup/presentation/widgets/` | implemented | user_setup |
| `FadeSlideIn` | `core/animations/shared_motion.dart` | implemented | home cards (via `StaggeredEntrance`) |
| `StaggeredEntrance` | `core/animations/shared_motion.dart` | implemented | home cards, timeline |
| `MorphSwitcher` | `core/animations/shared_motion.dart` | implemented | available; onboarding uses a bespoke `OnboardingIllustrationMorph` for finer-grained control |
| `PressableScale` | `core/animations/shared_motion.dart` | implemented (extended: Reduce Motion aware) | `PrimaryButton`, `CircularActionButton` |
| `OnboardingIllustrationMorph` | `features/onboarding/presentation/widgets/` | implemented (rewritten: full pixel-based exit/entry, was fractional `SlideTransition`) | onboarding |
| `OnboardingAccent` / `OnboardingAccentTween` | `features/onboarding/domain/models/` | implemented | onboarding (feature-scoped per widget placement rule — not reused elsewhere yet) |
| `AppMotionPresets` | `core/animations/presets.dart` | implemented | onboarding's accent tween/illustration morph, home hero entrance, `AnimatedStreakRing`, timeline per-step stagger |
| `HomeSectionMeta` | `features/home/domain/models/home_section_config.dart` | implemented | `homeSectionsProvider`, `home_section_registry.dart` |
| `AppSpacing` | `core/constants/app_spacing.dart` | implemented | every Home widget + `SectionCard`/`StatCard`/`CircularActionButton` |
