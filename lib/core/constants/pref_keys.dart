/// SharedPreferences key names — single source of truth so no feature
/// hardcodes a raw string key.
abstract final class PrefKeys {
  static const String onboardingComplete = 'onboarding_complete';
  static const String userName = 'user_name';
  static const String userAvatarAssetPath = 'user_avatar_asset_path';
  static const String userAccentWorkspaceId = 'user_accent_workspace_id';
  static const String themeMode = 'theme_mode';
  static const String dailyReminderEnabled = 'daily_reminder_enabled';
}
