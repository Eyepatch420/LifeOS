import 'package:flutter/material.dart';
import 'package:lifeos/theme/workspace_theme.dart';

/// Stable workspace ids — used as the key across `currentWorkspaceProvider`,
/// bottom nav selection, and this palette map.
abstract final class WorkspaceIds {
  static const String home = 'home';
  static const String reminders = 'reminders';
  static const String health = 'health';
  static const String finance = 'finance';
  static const String documents = 'documents';
}

/// The 5 fixed workspace palettes. Compile-time data — no persistence
/// needed for the palette definitions themselves.
final Map<String, WorkspaceTheme> kWorkspaceThemes = {
  WorkspaceIds.home: const WorkspaceTheme(
    id: WorkspaceIds.home,
    primary: Color(0xFF2F6FED),
    secondary: Color(0xFF7CA6F5),
    heroGradient: [Color(0xFF1E4FBF), Color(0xFF5B9BF0)],
    fabColor: Color(0xFF2F6FED),
    chipSelectedColor: Color(0xFFDCE8FE),
    chartPalette: [Color(0xFF2F6FED), Color(0xFF7CA6F5), Color(0xFFB9D2FA)],
  ),
  WorkspaceIds.reminders: const WorkspaceTheme(
    id: WorkspaceIds.reminders,
    primary: Color(0xFFEF8A2C),
    secondary: Color(0xFFF6B678),
    heroGradient: [Color(0xFFC96A17), Color(0xFFF0A056)],
    fabColor: Color(0xFFEF8A2C),
    chipSelectedColor: Color(0xFFFCE6D0),
    chartPalette: [Color(0xFFEF8A2C), Color(0xFFF6B678), Color(0xFFFBD9B6)],
  ),
  WorkspaceIds.health: const WorkspaceTheme(
    id: WorkspaceIds.health,
    primary: Color(0xFF2FAE6A),
    secondary: Color(0xFF7DCE9F),
    heroGradient: [Color(0xFF1B8A4E), Color(0xFF57C387)],
    fabColor: Color(0xFF2FAE6A),
    chipSelectedColor: Color(0xFFD8F0E1),
    chartPalette: [Color(0xFF2FAE6A), Color(0xFF7DCE9F), Color(0xFFBBE6CE)],
  ),
  WorkspaceIds.finance: const WorkspaceTheme(
    id: WorkspaceIds.finance,
    primary: Color(0xFF1B9C93),
    secondary: Color(0xFF6BC4BD),
    heroGradient: [Color(0xFF0F7A73), Color(0xFF3EAFA6)],
    fabColor: Color(0xFF1B9C93),
    chipSelectedColor: Color(0xFFD3EEEC),
    chartPalette: [Color(0xFF1B9C93), Color(0xFF6BC4BD), Color(0xFFAEE0DB)],
  ),
  WorkspaceIds.documents: const WorkspaceTheme(
    id: WorkspaceIds.documents,
    primary: Color(0xFF5B6B7C),
    secondary: Color(0xFF97A4B0),
    heroGradient: [Color(0xFF3F4B58), Color(0xFF71818F)],
    fabColor: Color(0xFF5B6B7C),
    chipSelectedColor: Color(0xFFE1E5E9),
    chartPalette: [Color(0xFF5B6B7C), Color(0xFF97A4B0), Color(0xFFC7CFD6)],
  ),
};

WorkspaceTheme workspaceThemeFor(String workspaceId) =>
    kWorkspaceThemes[workspaceId] ?? kWorkspaceThemes[WorkspaceIds.home]!;
