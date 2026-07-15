import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/error/failures.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_setup_form_providers.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/accent_color_selector.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/avatar_picker_grid.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/setup_toggle_tile.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/theme_mode_selector.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/theme/theme_providers.dart';

/// Not account creation — fully local/offline profile setup. Collects
/// name, avatar, accent color, theme mode, and the reminder/biometric
/// toggles, then commits via [UserProfileNotifier.completeSetup].
///
/// Accent color and theme mode selections live-preview against the real
/// app theme immediately (writing straight through to
/// [currentWorkspaceProvider]/[themeModeProvider], not just the local
/// draft state) — see docs/theme.md for why this is safe: it never
/// rebuilds anything outside the widgets that actually watch those
/// providers, the same repaint-scoping guarantee the workspace/dark-mode
/// theme engine already provides.
class UserSetupScreen extends ConsumerStatefulWidget {
  const UserSetupScreen({super.key});

  @override
  ConsumerState<UserSetupScreen> createState() => _UserSetupScreenState();
}

class _UserSetupScreenState extends ConsumerState<UserSetupScreen> {
  final _nameController = TextEditingController();
  bool _isSubmitting = false;
  String? _setupError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = ref.read(userSetupFormProvider);
    setState(() {
      _isSubmitting = true;
      _setupError = null;
    });

    try {
      await ref
          .read(userProfileNotifierProvider.notifier)
          .completeSetup(
            name: _nameController.text,
            avatarAssetPath: form.avatarId,
            accentWorkspaceId: form.accentWorkspaceId,
            themeMode: form.themeMode,
            dailyReminderEnabled: form.dailyReminderEnabled,
            requestBiometricLock: form.biometricLockRequested,
            canUseBiometrics: () =>
                ref.read(biometricServiceProvider).canAuthenticate(),
          );
      if (!mounted) return;

      if (form.biometricLockRequested) {
        final saved = await ref.read(userProfileNotifierProvider.future);
        if (!saved!.biometricLockEnabled && mounted) {
          setState(() {
            _setupError =
                'Biometric lock isn\'t available on this device, so it was left off.';
          });
        }
      }

      if (!mounted) return;
      context.goNamed(RouteNames.home);
    } catch (error) {
      // Never let a failure here leave the user stuck on this screen with
      // no feedback — surface it inline and let them retry. `Failure`
      // subclasses carry a friendly message already; anything else falls
      // back to a generic one rather than leaking a raw exception string.
      if (!mounted) return;
      setState(() {
        _setupError = error is Failure
            ? error.message
            : 'Something went wrong finishing setup. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(userSetupFormProvider);
    final formNotifier = ref.read(userSetupFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Set up LifeOS')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What should we call you?',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                onChanged: formNotifier.setName,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 28),
              Text('Choose an avatar', style: context.textTheme.titleMedium),
              const SizedBox(height: 12),
              AvatarPickerGrid(
                selectedId: form.avatarId,
                onSelected: formNotifier.setAvatar,
              ),
              const SizedBox(height: 28),
              Text('Accent color', style: context.textTheme.titleMedium),
              const SizedBox(height: 12),
              AccentColorSelector(
                selectedWorkspaceId: form.accentWorkspaceId,
                onSelected: (workspaceId) {
                  formNotifier.setAccentWorkspace(workspaceId);
                  // Live preview: the app's real theme shifts immediately,
                  // not just after Finish Setup.
                  ref
                      .read(currentWorkspaceProvider.notifier)
                      .setWorkspace(workspaceId);
                },
              ),
              const SizedBox(height: 28),
              Text('Appearance', style: context.textTheme.titleMedium),
              const SizedBox(height: 12),
              ThemeModeSelector(
                value: form.themeMode,
                onChanged: (mode) {
                  formNotifier.setThemeMode(mode);
                  // Live preview + persists immediately via ThemeModeNotifier.
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                },
              ),
              const SizedBox(height: 28),
              SetupToggleTile(
                icon: Icons.notifications_active_outlined,
                title: 'Daily reminder',
                subtitle: 'A gentle nudge to check in on your day.',
                value: form.dailyReminderEnabled,
                onChanged: formNotifier.setDailyReminderEnabled,
              ),
              SetupToggleTile(
                icon: Icons.fingerprint,
                title: 'Biometric lock',
                subtitle: 'Require Face ID/fingerprint to open LifeOS.',
                value: form.biometricLockRequested,
                onChanged: formNotifier.setBiometricLockRequested,
              ),
              if (_setupError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _setupError!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Explicitly scoped to _nameController rather than relying on
              // the wider ref.watch(userSetupFormProvider) rebuild as a
              // side effect of onChanged: formNotifier.setName — the
              // button's enabled state now has its own direct, obvious
              // source of truth.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, _) {
                  return PrimaryButton(
                    label: 'Finish setup',
                    isLoading: _isSubmitting,
                    onPressed: value.text.trim().isEmpty ? null : _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
