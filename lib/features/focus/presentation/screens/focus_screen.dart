import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/focus/domain/contracts/focus_dashboard_summary.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/domain/entities/focus_visual_stage.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_controller.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_dashboard_provider.dart';
import 'package:lifeos/features/focus/presentation/widgets/focus_duration_picker.dart';
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
/// Renders one of three states purely from [focusControllerProvider]'s
/// session (null/running/paused, `completed`/`cancelled` sessions never
/// stay the active session — see `FocusController`): idle (no active
/// session — duration picker + Start), active (running/paused — timer +
/// controls), or a brief completed acknowledgement immediately after
/// [FocusController.complete] before returning to idle.
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  int _selectedMinutes = kFocusDurationPresetsMinutes[1];
  FocusSession? _justCompleted;
  AppLifecycleListener? _lifecycleListener;

  @override
  void initState() {
    super.initState();
    // On resume (app backgrounded then foregrounded), reconcile against
    // the current clock immediately rather than waiting for some other
    // unrelated rebuild — covers "session naturally completed while the
    // app was backgrounded" without depending on a background timer
    // callback having fired.
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
    // Matches the app-wide id convention (see
    // `notification_engine_provider.dart`'s `idFactory`) — no new
    // id-generation dependency needed.
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    await ref
        .read(focusControllerProvider.notifier)
        .start(id: id, plannedMinutes: _selectedMinutes);
  }

  Future<void> _complete(FocusSession session) async {
    await ref.read(focusControllerProvider.notifier).complete();
    setState(() => _justCompleted = session);
  }

  Future<void> _cancel() async {
    await ref.read(focusControllerProvider.notifier).cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(focusControllerProvider);

    return PushedScreenLayout(
      header: const PushedScreenHeader(title: 'Focus'),
      content: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => EmptyState(
          icon: Icons.error_outline,
          message: 'Something went wrong loading Focus: $error',
        ),
        data: (session) {
          if (session != null) {
            // A fresh Start after acknowledging completion should show the
            // new active session, not the stale completed one.
            if (_justCompleted != null) _justCompleted = null;
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
          if (_justCompleted != null) {
            return _CompletedFocusView(
              session: _justCompleted!,
              onStartAnother: () => setState(() => _justCompleted = null),
            );
          }
          return _IdleFocusView(
            selectedMinutes: _selectedMinutes,
            onDurationSelected: (minutes) =>
                setState(() => _selectedMinutes = minutes),
            onStart: _start,
          );
        },
      ),
    );
  }
}

class _IdleFocusView extends ConsumerWidget {
  const _IdleFocusView({
    required this.selectedMinutes,
    required this.onDurationSelected,
    required this.onStart,
  });

  final int selectedMinutes;
  final ValueChanged<int> onDurationSelected;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(focusDashboardProvider);

    return FadeSlideIn(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dashboardAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (summary) =>
                  _TodayTotalCard(duration: summary.todayFocusedDuration),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Duration',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FocusDurationPicker(
              selectedMinutes: selectedMinutes,
              onSelected: onDurationSelected,
            ),
            const SizedBox(height: AppSpacing.xl),
            Semantics(
              button: true,
              label: 'Start Focus, $selectedMinutes minutes',
              child: PrimaryButton(label: 'Start Focus', onPressed: onStart),
            ),
            const SizedBox(height: AppSpacing.xl),
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
          ],
        ),
      ),
    );
  }
}

class _TodayTotalCard extends StatelessWidget {
  const _TodayTotalCard({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final label = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    return Semantics(
      label: "Today's focus: $label",
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
                  label,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Today's focus",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.session});

  final FocusSessionSummary session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: context.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${session.elapsedMinutes} of ${session.plannedMinutes} min',
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

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
    // Progress-derived stage — frozen at whatever it was when paused,
    // since `elapsedAt` itself stops advancing while paused (see
    // `FocusSession.elapsedAt`), never recomputed from wall-clock time
    // directly.
    final now = DateTime.now();
    final stage = FocusVisualStage.forProgress(session.progressAt(now));

    return FadeSlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FocusVisualStagePresenter(stage: stage, isPaused: isPaused),
          const SizedBox(height: AppSpacing.xl),
          Center(child: FocusTimerDisplay(session: session)),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              isPaused ? 'Paused' : 'Focusing…',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label: isPaused ? 'Resume' : 'Pause',
                  child: OutlinedButton(
                    onPressed: onPauseResume,
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'End Focus',
                  child: PrimaryButton(label: 'End Focus', onPressed: onEnd),
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
                child: const Text('Cancel session'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedFocusView extends StatelessWidget {
  const _CompletedFocusView({
    required this.session,
    required this.onStartAnother,
  });

  final FocusSession session;
  final VoidCallback onStartAnother;

  @override
  Widget build(BuildContext context) {
    final actualMinutes = session
        .elapsedAt(session.endedAt ?? DateTime.now())
        .inMinutes;

    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nice work!',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You focused for $actualMinutes minutes',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Start another session',
                onPressed: onStartAnother,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
