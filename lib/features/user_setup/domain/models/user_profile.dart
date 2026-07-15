import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// The user's locally-stored profile, set up once during onboarding and
/// editable later. Nothing here ever leaves the device.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String name,
    required String avatarAssetPath,
    required String accentWorkspaceId,
    required ThemeMode themeMode,
    required bool dailyReminderEnabled,
    required bool biometricLockEnabled,
  }) = _UserProfile;
}
