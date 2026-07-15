# Theme System

## Workspace palettes

| Workspace | Primary |
|---|---|
| Home | Blue |
| Reminders | Orange |
| Health | Green |
| Finance | Teal |
| Documents | Slate |

Each is a `WorkspaceTheme` (Freezed): `id`, `primary`, `secondary`, `heroGradient`, `fabColor`, `chipSelectedColor`, `chartPalette`. Defined as five const instances in `theme/workspace_theme_data.dart`.

## AppColorsExtension

`ThemeExtension<AppColorsExtension>` carries values beyond `ColorScheme`: `heroGradient`, `fabColor`, `chipSelectedColor`, `chartPalette`. Implements a real `lerp()` so workspace switches interpolate smoothly instead of snapping.

`AppTheme.build(Brightness, WorkspaceTheme)` builds one `ThemeData` via `ColorScheme.fromSeed(seedColor: workspace.primary, brightness: ...)` + the extension. Both light and dark variants exist per workspace (seed-generated `ColorScheme`; hand-authored dark variants for `heroGradient`/`chartPalette` since seed generation doesn't cover those).

## Reactive wiring

`currentWorkspaceProvider` (driven by bottom nav taps) → `activeWorkspaceThemeProvider` (derived lookup) → root `MaterialApp.router`, wrapped in `AnimatedTheme` so the color change animates rather than snaps. Tab content stays alive via `StatefulShellRoute.indexedStack`.

## Time-of-day tint

`time_of_day_theme.dart` defines four `TimeOfDayTint` variants applied only to the Home hero section (not the global `ColorScheme`):

| Bucket | Tint |
|---|---|
| Morning | Blue-leaning |
| Afternoon | Sky |
| Evening | Purple |
| Night | Navy |

Computed from `DateTime.now().hour` via a pure function in `core/extensions/datetime_extensions.dart`, exposed as `timeOfDayTintProvider`.

`TimeOfDayTint` also carries a `bucket: TimeOfDayBucket` field (added in Module 2) alongside `gradient`/`greeting` — this is the stable identity `GradientHeroBackground` keys its `MorphSwitcher` tint cross-fade on, rather than keying on the `greeting` string (which could change with a future locale/copy edit without that being a meaningful animation trigger).

## Dark mode + hero SVG

The hero background SVG (light blue/teal wave) doesn't get a separate dark-mode asset. Instead a black gradient scrim (alpha 0.55 near text → 0.25 near banner) is composited on top only when `Brightness.dark`, alongside the time-of-day tint scrim. Hero text/icons are pinned to white/light regardless of theme mode.

## Onboarding accent system (distinct from workspace theming)

`OnboardingAccent` (`features/onboarding/domain/models/onboarding_accent.dart`) is a deliberately **separate** mechanism from `WorkspaceTheme`/`AppColorsExtension`, even though it mirrors the same `lerp()`-based interpolation style:

| Onboarding page | Pillar | Accent |
|---|---|---|
| 1 | Planning | Blue |
| 2 | Security | Slate |
| 3 | Wellness | Green |

- **Scope**: `OnboardingAccent` only ever colors widgets inside `OnboardingScreen` (the button, the active progress dot, a subtle background gradient tint). It never touches `ThemeData`, `ColorScheme`, or `AppColorsExtension`.
- **Why separate**: onboarding's visual identity may diverge from workspace branding later (e.g. a marketing-driven onboarding redesign shouldn't force a workspace palette change, and vice versa). Keeping them independent avoids that coupling.
- **Mechanism**: `OnboardingAccentTween extends Tween<OnboardingAccent>` drives a single `TweenAnimationBuilder` at the `OnboardingScreen` root, keyed by the current page's accent as `end` (Flutter's `TweenAnimationBuilder` automatically re-animates from the currently-displayed value whenever `end` changes across rebuilds — no manual "previous value" tracking needed). This guarantees the accent transition never rebuilds anything outside `OnboardingScreen`'s own subtree, consistent with the "never rebuild the whole app to change theme" rule below.

## Live preview during User Setup

The setup screen's accent-color and appearance (theme-mode) selectors write straight through to `currentWorkspaceProvider`/`themeModeProvider` immediately on tap — in addition to the local `userSetupFormProvider` draft used for persistence — so the user sees the real app theme change before tapping Finish Setup. `UserProfileNotifier.completeSetup()` then performs a defensive final sync of the same two providers, so the live theme is guaranteed correct even for a caller that invokes `completeSetup()` without going through that live-preview UI path (a test, or a future "edit profile" reuse of the same orchestration).

## Never rebuild the whole app to change theme

This is a hard invariant, not just a performance nicety: `ThemeData` → `AnimatedTheme` → `AppColorsExtension.lerp()` scopes every workspace/dark-mode theme change so only widgets that actually read `Theme.of(context)`/`context.appColors` repaint — nothing else. Any new theme-adjacent wiring (the onboarding accent tween, the setup screen's live preview) must preserve this property. Verify with the Flutter Inspector's rebuild-count tracker before considering theme-adjacent work done.
