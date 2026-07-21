import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/router/app_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/notifications/notification_engine_provider.dart';
import 'package:lifeos/core/services/notification_tap_dispatcher.dart';
import 'package:lifeos/features/focus/data/focus_dnd_coordinator_provider.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';
import 'package:lifeos/features/medications/presentation/providers/medications_dashboard_provider.dart';
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
    // Must exist *before* the reconciliation calls below emit anything —
    // `EventBus` is a broadcast stream that drops events with no listener,
    // and `NotificationEngine`'s subscription is what actually turns a
    // reconciliation event into a re-shown notification. Normally started
    // from `build()` (see the `ref.watch` there), but that runs one frame
    // after `initState`, which is too late for a startup-only emit.
    ref.read(notificationEngineProvider);
    // If the app was killed/crashed mid-Focus-session with DND active,
    // this is what actually turns it back off — see
    // FocusDndCoordinator.reconcileOnStartup's doc comment. Independent of
    // FocusController's own reconciliation (that's about session state,
    // this is about a stuck system side effect).
    ref.read(focusDndCoordinatorProvider).reconcileOnStartup();
    // Restores the ongoing Focus notification for a session that's still
    // running after a kill+reopen — see
    // FocusRepository.reconcileNotificationsOnStartup's doc comment. Reads
    // (not watches) the repository: this is a one-shot startup action, not
    // a subscription, and FocusController still owns reconciling the
    // in-app session state itself whenever it (re)builds.
    //
    // Fire-and-forget from initState with no BuildContext/widget to await
    // it, so a teardown that outraces this Future (the underlying DB/stream
    // closing, in practice only observed in fast widget-test teardown) must
    // not surface as an unhandled async error — this is a best-effort
    // startup side effect, same posture as FocusDndCoordinator's own
    // reconciliation.
    unawaited(
      ref
          .read(focusRepositoryProvider)
          .reconcileNotificationsOnStartup()
          .catchError((_) {}),
    );
    // Re-asserts every active medication's schedule onto the notification
    // pipeline so a normal restart/reopen never lets persisted schedules
    // and OS-owned notification state silently diverge — see
    // MedicationsRepository.reconcileNotificationsOnStartup's doc comment.
    // Idempotent by construction (same posture as Focus's call above), so
    // this never blindly recreates notifications, it just re-confirms them.
    unawaited(
      ref
          .read(medicationsRepositoryProvider)
          .reconcileNotificationsOnStartup()
          .catchError((_) {}),
    );
  }

  @override
  void dispose() {
    _tapSubscription?.cancel();
    super.dispose();
  }

  /// Routes a tapped notification's payload by its `<kind>:<id>` prefix.
  /// Unrecognized payloads are ignored rather than throwing, since a
  /// stale/foreign payload should never crash navigation.
  ///
  /// `focus:` always routes to the Focus Overview (never directly to
  /// `focusSessionDetail`): a background-completion notification fires from
  /// an OS-scheduled alarm with no live app process to check "did this
  /// session actually complete yet, or is it a stale/cancelled alarm" —
  /// only `FocusController.build()`'s own `reconcileActiveSession()` call
  /// (which runs as soon as Focus mounts) is the authoritative check.
  /// Landing on Focus lets that reconciliation happen naturally: an
  /// already-completed session shows as history the user can tap into,
  /// exactly like the `Otherwise route to Focus Overview` fallback this
  /// feature's spec calls for.
  ///
  /// `reminder:` routes straight to that reminder's detail screen — unlike
  /// Focus, there's no reconciliation step a Reminder destination needs to
  /// run first.
  ///
  /// `medication:` routes straight to that medication's detail screen for
  /// the same reason `reminder:` does — a fired dose notification is
  /// simply a fact (the schedule said this time was due), not something
  /// that needs runtime reconciliation before it's safe to display.
  ///
  /// Both use `pushNamed` (not `goNamed`/`go`) so the destination lands on
  /// top of whatever's already on the root navigator's stack instead of
  /// replacing it — Home (or wherever the user was) stays underneath, so
  /// Back returns there instead of popping an artificially rebuilt stack.
  /// This matches how every other Home-launched screen
  /// (`TimelineDetailScreen`, `NoteDetailScreen`, ...) is already pushed.
  void _handleTap(String payload) {
    final router = ref.read(appRouterProvider);
    final separator = payload.indexOf(':');
    if (separator == -1) return;
    final kind = payload.substring(0, separator);
    final id = payload.substring(separator + 1);
    switch (kind) {
      case 'focus':
        router.pushNamed(RouteNames.focus);
      case 'reminder':
        router.pushNamed(
          RouteNames.reminderDetail,
          pathParameters: {'reminderId': id},
        );
      case 'medication':
        router.pushNamed(
          RouteNames.medicationDetail,
          pathParameters: {'medicationId': id},
        );
    }
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
