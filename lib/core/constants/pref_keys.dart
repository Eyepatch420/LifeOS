/// SharedPreferences key names — single source of truth so no feature
/// hardcodes a raw string key.
abstract final class PrefKeys {
  static const String onboardingComplete = 'onboarding_complete';
  static const String userName = 'user_name';
  static const String userAvatarAssetPath = 'user_avatar_asset_path';
  static const String userAccentWorkspaceId = 'user_accent_workspace_id';
  static const String themeMode = 'theme_mode';
  static const String dailyReminderEnabled = 'daily_reminder_enabled';
  static const String focusDndOptIn = 'focus_dnd_opt_in';
  // Records the interruption filter to restore once Focus stops applying
  // DND — set the instant DND is turned on, cleared the instant it's
  // restored. Its mere presence at startup (see FocusDndCoordinator's
  // reconciliation) means the last session ended (crash, force-quit, OS
  // kill) without running that restore, so startup finishes the job DND
  // itself can't: this key, not app lifecycle, is what "was DND left on by
  // us" actually depends on.
  static const String focusDndPriorFilter = 'focus_dnd_prior_filter';
}
