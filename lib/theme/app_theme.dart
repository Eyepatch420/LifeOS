import 'package:flutter/material.dart';
import 'package:lifeos/theme/app_color_extension.dart';
import 'package:lifeos/theme/workspace_theme.dart';

/// Builds one [ThemeData] for a given [brightness] × [workspace] pair.
abstract final class AppTheme {
  static ThemeData build(Brightness brightness, WorkspaceTheme workspace) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: workspace.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [
        AppColorsExtension(
          heroGradient: workspace.heroGradient,
          fabColor: workspace.fabColor,
          chipSelectedColor: workspace.chipSelectedColor,
          chartPalette: workspace.chartPalette,
        ),
      ],
    );
  }
}
