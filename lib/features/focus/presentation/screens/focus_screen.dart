import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/duration_format.dart';
import 'package:lifeos/features/focus/domain/contracts/focus_dashboard_summary.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/domain/entities/focus_visual_stage.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_controller.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_custom_duration_sheet.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_dnd_toggle.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_duration_wheel.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_timer_display.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_visual_stage_presenter.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Focus's dashboard/session screen — pushed via the root navigator (see
/// `app_router.dart`'s `RoutePaths.focus`) so it hides `FloatingBottomNav`
/// and Back returns to Home, matching every other Home-launched pushed
/// screen (`TimelineDetailScreen`, `NotesListScreen`, ...).
///
/// Renders one of two states purely from [focusControllerProvider]'s
/// session: idle/overview (no active session — duration wheel, Start, Today
/// stats, history) or active (running/paused — timer + controls). There is
/// no third "just completed" state here anymore — that moment now lives on
/// its own [RouteNames.focusCompletion] screen (see this class's `build()`
/// doc comment on the active-to-null transition below), reached via
/// `pushReplacementNamed` so Back from it can never land on a finished
/// active-session screen.
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  Duration _selectedDuration = const Duration(minutes: 25);
  AppLifecycleListener? _lifecycleListener;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    // On resume (app backgrounded then foregrounded), reconcile against
    // the current clock immediately rather than waiting for some other
    // unrelated rebuild — covers "session naturally completed while the
    // app was backgrounded" without depending on a background timer
    // callback having fired. Foreground natural completion (the user
    // watching the timer reach zero without backgrounding) is handled by
    // `_FocusEnvironment`'s ticker-driven reconcile instead — see its doc
    // comment.
    _lifecycleListener = AppLifecycleListener(
      onResume: () => ref.read(focusControllerProvider.notifier).reconcile(),
    );
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    // Guards a double-tap (or a tap that lands while a prior start is still
    // in flight) from creating two sessions — `FocusRepository.startSession`
    // already enforces "only one active session" server-side, but that
    // would surface as a thrown `FocusSessionAlreadyActiveException` rather
    // than silently doing nothing, so it's worth preventing at the source.
    if (_starting) return;
    _starting = true;
    try {
      // Matches the app-wide id convention (see
      // `notification_engine_provider.dart`'s `idFactory`) — no new
      // id-generation dependency needed.
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      await ref
          .read(focusControllerProvider.notifier)
          .start(id: id, plannedMinutes: _selectedDuration.inMinutes);
    } finally {
      _starting = false;
    }
  }

  Future<void> _complete(FocusSession session) async {
    await ref.read(focusControllerProvider.notifier).complete();
    if (mounted) {
      context.pushReplacementNamed(
        RouteNames.focusCompletion,
        queryParameters: {'sessionId': session.id},
      );
    }
  }

  Future<void> _cancel() async {
    await ref.read(focusControllerProvider.notifier).cancel();
  }

  Future<void> _openCustomDuration() async {
    final result = await showFocusCustomDurationSheet(
      context,
      initial: _selectedDuration,
    );
    if (result != null && mounted) {
      setState(() => _selectedDuration = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(focusControllerProvider);

    // Natural completion (the ticker-driven reconcile in `_FocusEnvironment`
    // completing the session in the background) transitions this provider's
    // state directly from an active session to `null` without ever going
    // through `_complete()` above — so the completion celebration for that
    // path is triggered here instead, via `ref.listen` reacting to the
    // active-session-id -> null edge. `_complete()`'s own explicit
    // navigation (the "End Focus" button) covers the manual path; this
    // covers the natural/backgrounded one. Both funnel through the same
    // `focusCompletion` route.
    ref.listen<AsyncValue<FocusSession?>>(focusControllerProvider, (
      previous,
      next,
    ) {
      final previousSession = previous?.value;
      final nextSession = next.value;
      if (previousSession != null &&
          previousSession.status == FocusSessionStatus.running &&
          nextSession == null) {
        context.pushReplacementNamed(
          RouteNames.focusCompletion,
          queryParameters: {'sessionId': previousSession.id},
        );
      }
    });

    return sessionAsync.when(
      loading: () => const PushedScreenLayout(
        header: PushedScreenHeader(title: 'Focus'),
        content: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => PushedScreenLayout(
        header: const PushedScreenHeader(title: 'Focus'),
        content: EmptyState(
          icon: Icons.error_outline,
          message: 'Something went wrong loading Focus: $error',
        ),
      ),
      data: (session) {
        if (session != null) {
          // Full-screen immersive environment, not `PushedScreenLayout`'s
          // padded shell — see `FocusVisualStagePresenter`'s doc comment
          // for why this needs to be full-bleed.
          return _ActiveFocusView(
            session: session,
            onPauseResume: () {
              final notifier = ref.read(focusControllerProvider.notifier);
              if (session.status == FocusSessionStatus.paused) {
                notifier.resume();
              } else {
                notifier.pause();
              }
            },
            onEnd: () => _complete(session),
            onCancel: _cancel,
          );
        }
        return PushedScreenLayout(
          header: const PushedScreenHeader(title: 'Focus'),
          content: _FocusOverview(
            selectedDuration: _selectedDuration,
            onDurationSelected: (duration) =>
                setState(() => _selectedDuration = duration),
            onCustomDurationTap: _openCustomDuration,
            onStart: _start,
          ),
        );
      },
    );
  }
}

/// The Focus entry point: a duration wheel (preset or custom) to start a new
/// session, plus a lightweight review of recent activity below it. Replaces
/// the old pill-based duration picker + flat history list with a wheel
/// selector and tappable history rows that navigate to
/// [RouteNames.focusSessionDetail].
class _FocusOverview extends ConsumerWidget {
  const _FocusOverview({
    required this.selectedDuration,
    required this.onDurationSelected,
    required this.onCustomDurationTap,
    required this.onStart,
  });

  final Duration selectedDuration;
  final ValueChanged<Duration> onDurationSelected;
  final VoidCallback onCustomDurationTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(focusDashboardProvider);
    final isCustom = !kFocusDurationPresetsMinutes.contains(
      selectedDuration.inMinutes,
    );

    return FadeSlideIn(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ready to focus?',
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Choose how long you want to stay in the moment.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (isCustom)
              Center(
                child: Column(
                  children: [
                    Text(
                      selectedDuration.toShortLabel,
                      style: context.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'CUSTOM',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              )
            else
              FocusDurationWheel(
                selectedMinutes: selectedDuration.inMinutes,
                onChanged: (minutes) =>
                    onDurationSelected(Duration(minutes: minutes)),
              ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Semantics(
                button: true,
                label: 'Custom duration',
                child: TextButton(
                  onPressed: onCustomDurationTap,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Custom duration'),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              button: true,
              label: 'Start Focus, ${selectedDuration.toShortLabel}',
              child: PrimaryButton(label: 'Start Focus', onPressed: onStart),
            ),
            const SizedBox(height: AppSpacing.md),
            const FocusDndToggle(),
            const SizedBox(height: AppSpacing.xl),
            dashboardAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (summary) => _TodaySummary(summary: summary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Recent sessions',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            dashboardAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (summary) => summary.recentSessions.isEmpty
                  ? const EmptyState(
                      icon: Icons.self_improvement_outlined,
                      message: 'No focus sessions yet',
                    )
                  : Column(
                      children: [
                        for (final s in summary.recentSessions)
                          _HistoryTile(session: s),
                      ],
                    ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _TodaySummary extends StatelessWidget {
  const _TodaySummary({required this.summary});

  final FocusDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final completedToday = summary.recentSessions
        .where((s) => _isToday(s.startedAt))
        .length;
    final label = summary.todayFocusedDuration.toShortLabel;

    return Semantics(
      label: "Today's focus: $completedToday sessions, $label focused",
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, color: context.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$completedToday session${completedToday == 1 ? '' : 's'} • '
                  '$label focused',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session});

  final FocusSessionSummary session;

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (session.status) {
      FocusSessionStatus.completed => 'Completed',
      FocusSessionStatus.cancelled => 'Cancelled',
      FocusSessionStatus.running => 'Ended early',
      FocusSessionStatus.paused => 'Ended early',
    };
    final subdued = session.status == FocusSessionStatus.cancelled;
    final icon = switch (session.status) {
      FocusSessionStatus.completed => Icons.check_circle_outline,
      FocusSessionStatus.cancelled => Icons.cancel_outlined,
      FocusSessionStatus.running ||
      FocusSessionStatus.paused => Icons.flag_outlined,
    };
    final timeLabel = DateFormat('h:mm a').format(session.startedAt);

    return Semantics(
      button: true,
      label:
          '${session.plannedMinutes} minute session, $statusLabel, '
          'started $timeLabel',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.pushNamed(
          RouteNames.focusSessionDetail,
          pathParameters: {'sessionId': session.id},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Icon(
                icon,
                color: subdued
                    ? context.colorScheme.onSurfaceVariant
                    : context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${session.plannedMinutes} min',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: subdued
                            ? context.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    Text(
                      '$statusLabel • $timeLabel',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Per-stage contextual copy shown under the timer — purely decorative
/// (not localization-critical status text like "Focusing…"/"Paused", which
/// stays fixed regardless of stage so existing behavior/tests are
/// unaffected).
const _stageMessages = {
  FocusVisualStage.growing: 'Stay in the moment.',
  FocusVisualStage.ripening: "You're doing great!",
  FocusVisualStage.settling: 'Almost there. Finish strong!',
};

/// Per-stage accent for the End Focus button — green while growing, warm
/// orange/red while ripening, purple/indigo while settling, matching each
/// stage's environment art.
const _stageAccent = {
  FocusVisualStage.growing: Color(0xFF3F9142),
  FocusVisualStage.ripening: Color(0xFFD9542F),
  FocusVisualStage.settling: Color(0xFF6C5CE7),
};

/// Full-screen immersive Focus session view: [FocusVisualStagePresenter]
/// fills the entire screen behind a persistent UI column (back button,
/// duration badge, timer, controls) that never moves or resizes as the
/// stage/environment crossfades underneath it — see this class's and
/// [FocusVisualStagePresenter]'s doc comments for the layering rationale.
///
/// Deliberately bypasses `PushedScreenLayout` (unlike the idle/completed
/// states, still rendered through it by `FocusScreen`): that layout's
/// horizontal padding + non-full-bleed `SafeArea` column is exactly what
/// prevented the environment from ever reading as immersive rather than a
/// card. This view manages its own `Scaffold`/`SafeArea` instead, letting
/// the environment paint behind the status bar while keeping interactive
/// controls inside a safe area.
class _ActiveFocusView extends StatelessWidget {
  const _ActiveFocusView({
    required this.session,
    required this.onPauseResume,
    required this.onEnd,
    required this.onCancel,
  });

  final FocusSession session;
  final VoidCallback onPauseResume;
  final VoidCallback onEnd;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isPaused = session.status == FocusSessionStatus.paused;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The only per-second-reactive part of this screen — isolates
          // the ticker-driven stage/environment rebuild to this subtree
          // (background + foreground Lottie + stage message), matching
          // `FocusTimerDisplay`'s isolation of the countdown text. The
          // header, timer digits, and buttons below are each their own
          // independently-scoped widgets and never rebuild just because a
          // second passed.
          Positioned.fill(
            child: _FocusEnvironment(session: session, isPaused: isPaused),
          ),
          SafeArea(
            child: FadeSlideIn(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Semantics(
                          button: true,
                          label: 'Back',
                          child: IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Focus',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _DurationBadge(plannedMinutes: session.plannedMinutes),
                      ],
                    ),
                    const Spacer(),
                    Center(child: FocusTimerDisplay(session: session)),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text(
                        isPaused ? 'Paused' : 'Focusing…',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(child: _StageMessage(session: session)),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            button: true,
                            label: isPaused ? 'Resume' : 'Pause',
                            child: OutlinedButton.icon(
                              onPressed: onPauseResume,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70),
                              ),
                              icon: Icon(
                                isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                              ),
                              label: Text(isPaused ? 'Resume' : 'Pause'),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _EndFocusButton(
                            session: session,
                            onEnd: onEnd,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Semantics(
                        button: true,
                        label: 'Cancel session',
                        child: TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: const Text('Cancel session'),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Watches [focusTickerProvider] to keep the background/foreground
/// environment advancing Grow -> Thrive -> Reflect every second — the one
/// per-second-reactive piece of the active Focus screen, alongside
/// [FocusTimerDisplay] and [_StageMessage]. [session] itself only changes
/// on pause/resume/status transitions, so without watching the ticker here
/// the environment would freeze at whatever stage it was in when the
/// session started (or last paused/resumed) instead of advancing with
/// elapsed time.
///
/// Also the trigger point for the natural-completion fix: [FocusController]
/// only ever reconciled a naturally-elapsed session on `build()`/app-resume
/// (see its doc comment), never on an ongoing per-second tick while the
/// screen stayed foregrounded — so a session could sit at `00:00` /
/// "Focusing…" indefinitely if the user just watched it finish instead of
/// backgrounding/reopening the app. This widget already re-runs every
/// second via [focusTickerProvider], so it's the natural place to notice
/// `remaining <= 0` and call [FocusController.reconcile] — which is itself
/// idempotent (`FocusRepository.completeSession` no-ops once already
/// completed/cancelled; see its doc comment), so calling it repeatedly
/// while remaining stays at zero is safe, not just tolerated. The resulting
/// active-session -> null transition is what `FocusScreen`'s `ref.listen`
/// uses to navigate to the completion celebration.
class _FocusEnvironment extends ConsumerWidget {
  const _FocusEnvironment({required this.session, required this.isPaused});

  final FocusSession session;
  final bool isPaused;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(focusTickerProvider);
    final now = tick.value ?? DateTime.now();
    final progress = session.progressAt(now);
    final stage = FocusVisualStage.forProgress(progress);
    // Maps the settling stage's own [0,1] progress window (66%-100% of
    // session progress) onto the Day-to-night Lottie's full timeline — see
    // `FocusVisualStagePresenter`'s doc comment on `dayToNightProgress`.
    final dayToNightProgress = ((progress - 2 / 3) / (1 / 3)).clamp(0.0, 1.0);

    if (session.hasNaturallyCompletedAt(now)) {
      // Scheduled after this frame (not called synchronously inside
      // build()): mutating provider state during build is unsafe in
      // Riverpod — `reconcile()` triggers a `FocusController` state write
      // that other widgets are subscribed to.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ref.read(focusControllerProvider.notifier).reconcile();
        }
      });
    }

    return FocusVisualStagePresenter(
      stage: stage,
      isPaused: isPaused,
      dayToNightProgress: dayToNightProgress,
    );
  }
}

/// The contextual "Stay in the moment." / "You're doing great!" / "Almost
/// there. Finish strong!" line — kept as its own ticker-watching widget
/// (like [FocusTimerDisplay]) rather than computed in [_ActiveFocusView],
/// for the same reason as [_FocusEnvironment]: the stage it reflects
/// changes with elapsed time, not just with [session] status.
class _StageMessage extends ConsumerWidget {
  const _StageMessage({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(focusTickerProvider);
    final now = tick.value ?? DateTime.now();
    final stage = FocusVisualStage.forProgress(session.progressAt(now));

    return Text(
      _stageMessages[stage]!,
      style: context.textTheme.bodyMedium?.copyWith(color: Colors.white70),
    );
  }
}

/// The End Focus button — its background accent tracks the current stage
/// (green/orange/purple), so like [_FocusEnvironment] and [_StageMessage]
/// it watches [focusTickerProvider] directly rather than deriving stage
/// once in [_ActiveFocusView]'s `build()`, which only reruns on
/// pause/resume/status changes rather than every second.
class _EndFocusButton extends ConsumerWidget {
  const _EndFocusButton({required this.session, required this.onEnd});

  final FocusSession session;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(focusTickerProvider);
    final now = tick.value ?? DateTime.now();
    final stage = FocusVisualStage.forProgress(session.progressAt(now));

    return Semantics(
      button: true,
      label: 'End Focus',
      child: FilledButton.icon(
        onPressed: onEnd,
        style: FilledButton.styleFrom(
          backgroundColor: _stageAccent[stage],
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.stop_rounded),
        label: const Text('End Focus'),
      ),
    );
  }
}

/// "25 min" pill shown top-right of the active Focus header — the planned
/// duration for this session, matching the reference design's duration
/// badge.
class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.plannedMinutes});

  final int plannedMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Text(
        Duration(minutes: plannedMinutes).toShortLabel,
        style: context.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
