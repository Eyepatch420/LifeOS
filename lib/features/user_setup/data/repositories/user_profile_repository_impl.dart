import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/core/constants/secure_storage_keys.dart';
import 'package:lifeos/features/user_setup/domain/models/user_profile.dart';
import 'package:lifeos/features/user_setup/domain/repositories/user_profile_repository.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

/// Splits storage across two backends: everything scalar/non-sensitive goes
/// to [PreferencesService]; [UserProfile.biometricLockEnabled] specifically
/// goes to [SecureStorageService], since flipping that flag off should
/// require more than editing a plaintext prefs file (see docs/theme.md /
/// architecture.md for the full rationale).
class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._prefs, this._secureStorage);

  final PreferencesService _prefs;
  final SecureStorageService _secureStorage;

  @override
  Future<UserProfile?> getProfile() async {
    final name = _prefs.getString(PrefKeys.userName);
    if (name == null) return null;

    final biometricLockEnabled = await _secureStorage.readBool(
      SecureStorageKeys.biometricLockEnabled,
    );

    return UserProfile(
      name: name,
      avatarAssetPath: _prefs.getString(PrefKeys.userAvatarAssetPath) ?? '',
      accentWorkspaceId:
          _prefs.getString(PrefKeys.userAccentWorkspaceId) ?? WorkspaceIds.home,
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == _prefs.getString(PrefKeys.themeMode),
        orElse: () => ThemeMode.system,
      ),
      dailyReminderEnabled: _prefs.getBool(PrefKeys.dailyReminderEnabled),
      biometricLockEnabled: biometricLockEnabled,
    );
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(PrefKeys.userName, profile.name);
    await _prefs.setString(
      PrefKeys.userAvatarAssetPath,
      profile.avatarAssetPath,
    );
    await _prefs.setString(
      PrefKeys.userAccentWorkspaceId,
      profile.accentWorkspaceId,
    );
    await _prefs.setString(PrefKeys.themeMode, profile.themeMode.name);
    await _prefs.setBool(
      PrefKeys.dailyReminderEnabled,
      profile.dailyReminderEnabled,
    );
    await _secureStorage.writeBool(
      SecureStorageKeys.biometricLockEnabled,
      profile.biometricLockEnabled,
    );
  }

  @override
  bool isOnboardingComplete() => _prefs.getBool(PrefKeys.onboardingComplete);

  @override
  Future<void> setOnboardingComplete() =>
      _prefs.setBool(PrefKeys.onboardingComplete, true);
}
