import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/error/failures.dart';
import 'package:lifeos/features/user_setup/data/repositories/user_profile_repository_impl.dart';
import 'package:lifeos/features/user_setup/domain/models/user_profile.dart';
import 'package:lifeos/features/user_setup/domain/repositories/user_profile_repository.dart';
import 'package:lifeos/theme/theme_providers.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    ref.watch(preferencesServiceProvider),
    ref.watch(secureStorageServiceProvider),
  );
});

/// True once the user has finished onboarding + user setup. Read
/// synchronously by the router's redirect logic.
final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(userProfileRepositoryProvider).isOnboardingComplete();
});

/// Loads/persists the user's profile. `null` state means setup hasn't been
/// completed yet.
class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() {
    return ref.watch(userProfileRepositoryProvider).getProfile();
  }

  /// The one multi-step orchestration flow in Module 1: validate the draft,
  /// verify biometric capability if requested (never persist the flag as
  /// enabled if the device can't satisfy it — that would lock the user out
  /// of their own app), persist the profile, then mark onboarding complete.
  Future<void> completeSetup({
    required String name,
    required String avatarAssetPath,
    required String accentWorkspaceId,
    required ThemeMode themeMode,
    required bool dailyReminderEnabled,
    required bool requestBiometricLock,
    required Future<bool> Function() canUseBiometrics,
  }) async {
    if (name.trim().isEmpty) {
      throw const ValidationFailure('Name cannot be empty.');
    }

    var biometricLockEnabled = false;
    if (requestBiometricLock) {
      biometricLockEnabled = await canUseBiometrics();
    }

    final profile = UserProfile(
      name: name.trim(),
      avatarAssetPath: avatarAssetPath,
      accentWorkspaceId: accentWorkspaceId,
      themeMode: themeMode,
      dailyReminderEnabled: dailyReminderEnabled,
      biometricLockEnabled: biometricLockEnabled,
    );

    final repository = ref.read(userProfileRepositoryProvider);
    await repository.saveProfile(profile);
    await repository.setOnboardingComplete();

    // Defensive final sync: the setup screen's live-preview wiring already
    // pushes accent/theme-mode choices into these providers as the user
    // interacts, but completeSetup() stays the single source of truth for
    // the persisted profile — so it re-asserts the same values here too.
    // This guarantees the live theme is correct even for a caller that
    // invokes completeSetup() without going through that UI (a test, or a
    // future "edit profile" reuse of this same orchestration).
    ref
        .read(currentWorkspaceProvider.notifier)
        .setWorkspace(profile.accentWorkspaceId);
    await ref.read(themeModeProvider.notifier).setThemeMode(profile.themeMode);

    state = AsyncData(profile);
    ref.invalidate(onboardingCompleteProvider);
  }
}

final userProfileNotifierProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
      UserProfileNotifier.new,
    );
