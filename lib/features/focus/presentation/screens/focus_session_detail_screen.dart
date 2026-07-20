import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/duration_format.dart';
import 'package:lifeos/features/focus/domain/entities/focus_session.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_session_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';
import 'package:lottie/lottie.dart';

/// The permanent record for one Focus session — reached by tapping a row in
/// the Overview's history list. Loads the authoritative session by id from
/// persistence (see `focus_session_provider.dart`'s doc comment) rather than
/// receiving a session object through navigation, so it keeps working after
/// process recreation or a deep link/notification tap.
///
/// Loading/error/not-found states still route through the padded
/// [PushedScreenLayout] shell (nothing to show a full-bleed background
/// behind yet); the real completed/non-completed content bypasses it for
/// [_SpaceBackdrop] the same way the active Focus screen bypasses it for
/// its full-screen environment — see that screen's doc comment.
class FocusSessionDetailScreen extends ConsumerWidget {
  const FocusSessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(focusSessionByIdProvider(sessionId));

    return sessionAsync.when(
      loading: () => const PushedScreenLayout(
        header: PushedScreenHeader(title: 'Session Details'),
        content: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => PushedScreenLayout(
        header: const PushedScreenHeader(title: 'Session Details'),
        content: EmptyState(
          icon: Icons.error_outline,
          message: 'Something went wrong loading this session: $error',
        ),
      ),
      data: (session) => session == null
          ? const PushedScreenLayout(
              header: PushedScreenHeader(title: 'Session Details'),
              content: EmptyState(
                icon: Icons.search_off,
                message: 'This session could not be found.',
              ),
            )
          : _SessionDetailView(session: session),
    );
  }
}

/// Full-bleed space-themed backdrop with the persistent header/content
/// column painted on top — mirrors `_ActiveFocusView`'s layering rationale
/// (full immersion beats `PushedScreenLayout`'s padded card for a moment
/// meant to feel like "you completed a meaningful focus journey," not "here
/// is a database record").
class _SessionDetailView extends StatelessWidget {
  const _SessionDetailView({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SpaceBackdrop(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Row(
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
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Session Details',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _SessionDetailContent(session: session),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// space.png behind a subtle bottom-anchored dark gradient — just enough to
/// keep the summary card/date text readable over the busy starfield without
/// globally darkening the image to the point it stops reading as space (the
/// top, where only the header sits, stays essentially untouched).
class _SpaceBackdrop extends StatelessWidget {
  const _SpaceBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/backgrounds/space.png',
          fit: BoxFit.cover,
          // space.png's own subject (planet surface + horizon) sits in its
          // lower third — anchoring on center keeps that horizon visible
          // rather than cropping it off the bottom on shorter screens.
          alignment: Alignment.center,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.5, 0.8, 1],
              colors: [
                Color(0x00000000),
                Color(0x00000000),
                Color(0x99000000),
                Color(0xCC000000),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionDetailContent extends StatelessWidget {
  const _SessionDetailContent({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final completed = session.status == FocusSessionStatus.completed;
    final actualDuration = session.elapsedAt(session.endedAt ?? DateTime.now());
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('h:mm a');

    return FadeSlideIn(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.sm),
            if (completed)
              // Not tied to Focus duration/progress — a purely decorative,
              // freely-looping celebration (see this screen's module doc:
              // the astronaut is an independent animated layer, never
              // baked into or driven by session state).
              SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset(
                  'assets/lottie/Happy Spaceman.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                session.status == FocusSessionStatus.cancelled
                    ? Icons.cancel_outlined
                    : Icons.flag_outlined,
                size: 96,
                color: Colors.white70,
              ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _statusHeadline(session.status),
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              actualDuration.toShortLabel,
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _completionMessage(completed, actualDuration),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SessionSummaryCard(
              session: session,
              timeFormat: timeFormat,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              dateFormat.format(session.startedAt),
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  String _statusHeadline(FocusSessionStatus status) => switch (status) {
    FocusSessionStatus.completed => 'Session Complete',
    FocusSessionStatus.cancelled => 'Session Cancelled',
    FocusSessionStatus.running => 'Focus Ended Early',
    FocusSessionStatus.paused => 'Focus Ended Early',
  };

  String _completionMessage(bool completed, Duration duration) {
    if (!completed) return 'This session didn\'t run to completion.';
    return 'Great work. You stayed focused for ${duration.toShortLabel}.';
  }
}

/// Replaces the old plain grey `Container` with a translucent glass-style
/// panel that stays readable over [_SpaceBackdrop] without a heavy blur
/// (a `BackdropFilter` would cost a full-screen blur pass every time this
/// static card repaints for no visual gain here, since the background
/// beneath it is already darkened by the gradient).
class _SessionSummaryCard extends StatelessWidget {
  const _SessionSummaryCard({required this.session, required this.timeFormat});

  final FocusSession session;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'SESSION SUMMARY',
            style: context.textTheme.labelSmall?.copyWith(
              color: Colors.white60,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Planned',
            value: '${session.plannedMinutes} min',
          ),
          _DetailRow(
            label: 'Started',
            value: timeFormat.format(session.startedAt),
          ),
          _DetailRow(
            label: 'Finished',
            value: session.endedAt == null
                ? '—'
                : timeFormat.format(session.endedAt!),
          ),
          _DetailRow(label: 'Status', value: _statusLabel(session.status)),
          _DetailRow(
            label: 'Paused',
            value: session.accumulatedPausedMs > 0 ? 'Yes' : 'No',
            isLast: true,
          ),
        ],
      ),
    );
  }

  String _statusLabel(FocusSessionStatus status) => switch (status) {
    FocusSessionStatus.completed => 'Completed',
    FocusSessionStatus.cancelled => 'Cancelled',
    FocusSessionStatus.running => 'Ended early',
    FocusSessionStatus.paused => 'Ended early',
  };
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
