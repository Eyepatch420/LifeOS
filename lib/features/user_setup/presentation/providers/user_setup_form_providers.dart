import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

part 'user_setup_form_providers.freezed.dart';

/// Draft state held before the final "Finish" commit persists a
/// [UserProfile] — see [UserProfileNotifier.completeSetup].
@freezed
abstract class UserSetupFormState with _$UserSetupFormState {
  const factory UserSetupFormState({
    @Default('') String name,
    @Default('fox') String avatarId,
    @Default(WorkspaceIds.home) String accentWorkspaceId,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool dailyReminderEnabled,
    @Default(false) bool biometricLockRequested,
  }) = _UserSetupFormState;
}

class UserSetupFormNotifier extends Notifier<UserSetupFormState> {
  @override
  UserSetupFormState build() => const UserSetupFormState();

  void setName(String name) => state = state.copyWith(name: name);

  void setAvatar(String avatarId) => state = state.copyWith(avatarId: avatarId);

  void setAccentWorkspace(String workspaceId) =>
      state = state.copyWith(accentWorkspaceId: workspaceId);

  void setThemeMode(ThemeMode mode) => state = state.copyWith(themeMode: mode);

  void setDailyReminderEnabled(bool value) =>
      state = state.copyWith(dailyReminderEnabled: value);

  void setBiometricLockRequested(bool value) =>
      state = state.copyWith(biometricLockRequested: value);
}

final userSetupFormProvider =
    NotifierProvider<UserSetupFormNotifier, UserSetupFormState>(
      UserSetupFormNotifier.new,
    );
