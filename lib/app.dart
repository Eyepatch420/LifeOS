import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/router/app_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/notifications/notification_engine_provider.dart';
import 'package:lifeos/core/services/notification_tap_dispatcher.dart';
import 'package:lifeos/theme/app_theme.dart';
import 'package:lifeos/theme/theme_providers.dart';

class LifeOsApp extends ConsumerStatefulWidget {
  const LifeOsApp({super.key});

  @override
  ConsumerState<LifeOsApp> createState() => _LifeOsAppState();
}

class _LifeOsAppState extends ConsumerState<LifeOsApp> {
  StreamSubscription<String>? _tapSubscription;

  @override
  void initState() {
    super.initState();
    // One listener handles all three delivery cases (cold start,
    // background, foreground) uniformly — see
    // `notification_tap_dispatcher.dart`'s doc comment for how each is
    // funneled into this same stream.
    _tapSubscription = notificationTapDispatcher.taps.listen(_handleTap);
  }

  @override
  void dispose() {
    _tapSubscription?.cancel();
    super.dispose();
  }

  /// Routes a tapped notification's payload. Only `focus:<sessionId>` is
  /// understood today — unrecognized payloads are ignored rather than
  /// throwing, since a stale/foreign payload should never crash navigation.
  ///
  /// Uses `pushNamed` (not `goNamed`/`go`) so Focus lands on top of
  /// whatever's already on the root navigator's stack instead of replacing
  /// it — Home (or wherever the user was) stays underneath, so Back from
  /// Focus returns there instead of popping an artificially rebuilt stack.
  /// This matches how every other Home-launched screen
  /// (`TimelineDetailScreen`, `NoteDetailScreen`, ...) is already pushed.
  void _handleTap(String payload) {
    if (!payload.startsWith('focus:')) return;
    final router = ref.read(appRouterProvider);
    router.pushNamed(RouteNames.focus);
  }

  @override
  Widget build(BuildContext context) {
    // Touching this once, here, starts the single app-lifetime
    // NotificationEngine's EventBus subscription (see
    // notification_engine_provider.dart's `keepAlive()` doc comment) — no
    // widget ever needs its value, only its side effect of existing.
    ref.watch(notificationEngineProvider);
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final workspace = ref.watch(activeWorkspaceThemeProvider);

    return MaterialApp.router(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.build(Brightness.light, workspace),
      darkTheme: AppTheme.build(Brightness.dark, workspace),
      routerConfig: router,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return AnimatedTheme(
          data: Theme.of(context),
          duration: AppDurations.medium,
          child: child,
        );
      },
    );
  }
}
