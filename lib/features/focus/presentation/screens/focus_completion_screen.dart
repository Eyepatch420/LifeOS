import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/core/utils/duration_format.dart';
import 'package:lifeos/features/focus/presentation/providers/focus_session_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lottie/lottie.dart';

/// A short, one-shot celebration shown immediately after a Focus session
/// finishes (naturally or via "End Focus") — distinct from
/// [FocusSessionDetailScreen], which is the permanent record a user returns
/// to later. Reached via `pushReplacementNamed` from the active Focus screen
/// (see `focus_screen.dart`) so Back never lands on the now-finished active
/// timer, then itself navigates with `goNamed(RouteNames.focus)` (a full
/// replace, not a push) back to the Overview — the intended stack after
/// this screen is `Overview` only, per this feature's navigation spec.
class FocusCompletionScreen extends ConsumerStatefulWidget {
  const FocusCompletionScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<FocusCompletionScreen> createState() =>
      _FocusCompletionScreenState();
}

class _FocusCompletionScreenState extends ConsumerState<FocusCompletionScreen> {
  Timer? _autoContinueTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _autoContinueTimer = Timer(const Duration(seconds: 2), _continue);
  }

  @override
  void dispose() {
    _autoContinueTimer?.cancel();
    super.dispose();
  }

  /// Safe one-shot navigation: guards against the auto-continue timer and a
  /// manual "Continue" tap both firing (whichever happens first wins; the
  /// other is a no-op) and against navigating after this screen has already
  /// been disposed.
  void _continue() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _autoContinueTimer?.cancel();
    context.goNamed(RouteNames.focus);
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(focusSessionByIdProvider(widget.sessionId));
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: const Color(0xFF12172B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Semantics(
                label: 'Focus session complete celebration',
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: reduceMotion
                      ? const Icon(
                          Icons.rocket_launch,
                          size: 96,
                          color: Colors.white,
                        )
                      : Lottie.asset(
                          'assets/lottie/Businessman flies up with rocket.json',
                          repeat: false,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Focus Complete!',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              sessionAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (session) {
                  final duration = session?.elapsedAt(
                    session.endedAt ?? session.startedAt,
                  );
                  return Text(
                    duration == null
                        ? 'Great work.'
                        : 'Great work. You focused for '
                              '${duration.toShortLabel}.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  );
                },
              ),
              const Spacer(),
              Semantics(
                button: true,
                label: 'Continue',
                child: PrimaryButton(label: 'Continue', onPressed: _continue),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
