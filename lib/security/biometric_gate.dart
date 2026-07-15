import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';

/// In-memory, per-session biometric-authenticated flag. Resets on every
/// cold start by design — re-locks on relaunch even if the OS didn't fully
/// kill the process, per docs/theme.md / architecture.md security notes.
class BiometricAuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markAuthenticated() => state = true;
}

final biometricAuthStateProvider =
    NotifierProvider<BiometricAuthNotifier, bool>(BiometricAuthNotifier.new);

/// Wraps the shell's content and blocks it behind a full-screen unlock
/// prompt when the user has enabled biometric lock. Implemented as a widget
/// wrapper (not a GoRouter redirect) because `local_auth.authenticate()` is
/// async/interactive — mixing that into declarative redirects invites races.
class BiometricGate extends ConsumerWidget {
  const BiometricGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final authenticated = ref.watch(biometricAuthStateProvider);

    final locked =
        profileAsync.value?.biometricLockEnabled == true && !authenticated;

    return AnimatedSwitcher(
      duration: AppDurations.medium,
      switchInCurve: AppCurves.easeOutCubic,
      child: locked ? const _UnlockScreen() : child,
    );
  }
}

class _UnlockScreen extends ConsumerWidget {
  const _UnlockScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 56,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('LifeOS is locked', style: context.textTheme.headlineSmall),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  final authenticated = await ref
                      .read(biometricServiceProvider)
                      .authenticate();
                  if (authenticated) {
                    ref
                        .read(biometricAuthStateProvider.notifier)
                        .markAuthenticated();
                  }
                },
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
