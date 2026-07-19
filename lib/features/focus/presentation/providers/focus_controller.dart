import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';

/// Once-a-second, UI-only tick — **not** a timer source of truth (see
/// `FocusSession.elapsedAt`'s doc comment). `autoDispose` so it only runs
/// while something (the active Focus screen) is actually watching it;
/// nothing else in the app pays for it.
///
/// Deliberately its own tiny provider rather than living inside
/// [FocusController] — a widget that only needs the live countdown display
/// (e.g. the timer text) can `ref.watch(focusTickerProvider)` directly
/// without subscribing to [focusControllerProvider] itself, so a tick never
/// rebuilds anything above/beside that widget (the screen shell, Lottie
/// stage, pause/resume buttons, Home, bottom nav, ...). See this feature's
/// module doc / the Phase 8 final report's "Performance/rebuild boundary"
/// section for the measured scope.
final focusTickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final clock = ref.watch(clockManagerProvider);
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => clock.now(),
  );
});

/// Session identity/status only — never carries a live elapsed/remaining
/// value, so a status-unchanged tick never produces a new [FocusController]
/// state. Consumers combine this with [focusTickerProvider] (or a single
/// `clock.now()` read) themselves to derive elapsed/remaining/progress via
/// [FocusSession.elapsedAt]/[FocusSession.remainingAt]/[FocusSession.progressAt] —
/// those are pure functions of `(session, now)`, so there's nothing to
/// "recompute and store" here that a rebuild-triggering write would help
/// with.
class FocusController extends AsyncNotifier<FocusSession?> {
  @override
  Future<FocusSession?> build() async {
    // `ref.watch` must run synchronously, before the first `await`, in
    // `build()` — reading the repository up front (not after the
    // reconcile below) keeps this a normal dependency subscription
    // instead of an unsafe post-await watch.
    final repository = ref.watch(focusRepositoryProvider);
    // Reconcile once per controller (re)build — covers app resume and
    // process/provider recreation (a fresh ProviderContainer re-runs
    // build()) without a background timer callback having to have fired.
    await repository.reconcileActiveSession();
    return repository.watchActiveSession().first;
  }

  Future<void> start({
    required String id,
    required int plannedMinutes,
    FocusSessionKind kind = FocusSessionKind.focus,
  }) async {
    state = const AsyncLoading<FocusSession?>();
    state = await AsyncValue.guard(
      () => ref
          .read(focusRepositoryProvider)
          .startSession(id: id, plannedMinutes: plannedMinutes, kind: kind),
    );
  }

  Future<void> pause() async {
    final session = state.value;
    if (session == null) return;
    await ref.read(focusRepositoryProvider).pauseSession(session.id);
    state = await AsyncValue.guard(
      () => ref.read(focusRepositoryProvider).watchActiveSession().first,
    );
  }

  Future<void> resume() async {
    final session = state.value;
    if (session == null) return;
    await ref.read(focusRepositoryProvider).resumeSession(session.id);
    state = await AsyncValue.guard(
      () => ref.read(focusRepositoryProvider).watchActiveSession().first,
    );
  }

  Future<void> complete() async {
    final session = state.value;
    if (session == null) return;
    await ref.read(focusRepositoryProvider).completeSession(session.id);
    state = const AsyncData<FocusSession?>(null);
  }

  Future<void> cancel() async {
    final session = state.value;
    if (session == null) return;
    await ref.read(focusRepositoryProvider).cancelSession(session.id);
    state = const AsyncData<FocusSession?>(null);
  }

  /// Reconciles against the current clock — call on app resume (see
  /// `FocusScreen`'s `AppLifecycleListener`) so a session that finished
  /// naturally while backgrounded is reflected immediately instead of
  /// waiting for the next unrelated rebuild.
  Future<void> reconcile() async {
    await ref.read(focusRepositoryProvider).reconcileActiveSession();
    state = await AsyncValue.guard(
      () => ref.read(focusRepositoryProvider).watchActiveSession().first,
    );
  }
}

final focusControllerProvider =
    AsyncNotifierProvider<FocusController, FocusSession?>(FocusController.new);
