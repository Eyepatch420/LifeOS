# Folder Structure

```
lib/
├── main.dart               # Entry point: GetIt setup, SharedPreferences hydration, ProviderScope, runApp
├── app.dart                # MaterialApp.router root, wires theme + router providers
│
├── core/
│   ├── constants/           # App-wide constants, pref keys, secure storage keys
│   ├── database/            # Drift wiring (scaffolded, no tables yet)
│   ├── error/                # Failure types, Result<T> wrapper
│   ├── extensions/           # context/datetime extensions (time-of-day greeting)
│   ├── animations/            # The motion system: durations, curves, stagger, page transitions, shared motion widgets
│   └── utils/                 # Logger
│
├── config/
│   ├── di/                   # GetIt service locator
│   └── router/               # GoRouter route tree + paths
│
├── theme/                    # WorkspaceTheme, AppColorsExtension, time-of-day theme, providers
│
├── shared/
│   ├── widgets/              # Design-system primitives, reusable across all features (cards/buttons/layouts/nav/media/indicators/scaffolds)
│   └── responsive/           # Breakpoints + responsive builder helper
│
├── services/                 # Thin wrappers over SharedPreferences / secure storage / local_auth
├── security/                  # BiometricGate widget
│
└── features/
    ├── splash/               # Presentation-only (no domain/data — no data of its own)
    ├── onboarding/            # 3 real Lottie pages, single-layout crossfade
    ├── user_setup/            # UserProfile domain model + repository + form UI
    ├── home/                  # Dashboard UI, static mock data
    ├── navigation/            # Custom floating bottom nav + app shell
    ├── reminders/ health/ finance/ documents/   # Placeholder stubs for Module 1

assets/
├── svg/{home,health,finance,documents,reminders,common,avatars,illustrations}/
├── lottie/
└── rive/                     # Empty, reserved for future splash upgrade
```

`l10n/` is intentionally not scaffolded — no localization requirement yet (revisit when needed).
`routing/` folds into `config/router/` — one home for routing concerns.
