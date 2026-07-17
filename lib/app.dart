import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/router/app_router.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/notifications/notification_engine_provider.dart';
import 'package:lifeos/theme/app_theme.dart';
import 'package:lifeos/theme/theme_providers.dart';

class LifeOsApp extends ConsumerWidget {
  const LifeOsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
