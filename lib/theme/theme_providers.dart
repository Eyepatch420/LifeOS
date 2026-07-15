import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/constants/pref_keys.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';
import 'package:lifeos/theme/workspace_theme.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

/// Persisted light/dark/system theme preference.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final raw = ref
        .read(preferencesServiceProvider)
        .getString(PrefKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(preferencesServiceProvider)
        .setString(PrefKeys.themeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// The active workspace id, driven by bottom-nav tab selection.
class CurrentWorkspaceNotifier extends Notifier<String> {
  @override
  String build() => WorkspaceIds.home;

  void setWorkspace(String workspaceId) => state = workspaceId;
}

final currentWorkspaceProvider =
    NotifierProvider<CurrentWorkspaceNotifier, String>(
      CurrentWorkspaceNotifier.new,
    );

/// Derived, pure lookup — no async, no side effects.
final activeWorkspaceThemeProvider = Provider<WorkspaceTheme>((ref) {
  final workspaceId = ref.watch(currentWorkspaceProvider);
  return workspaceThemeFor(workspaceId);
});

/// Recomputed on each read; the Home hero re-renders this on a periodic
/// timer (see `home_providers.dart`) so the tint advances as time passes
/// during a long-lived session.
final timeOfDayTintProvider = Provider<TimeOfDayTint>((ref) {
  return timeOfDayTintFor(DateTime.now());
});
