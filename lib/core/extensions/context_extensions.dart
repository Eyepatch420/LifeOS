import 'package:flutter/material.dart';
import 'package:lifeos/theme/app_color_extension.dart';

/// Shorthand accessors so feature code reads `context.colors`/`context.textTheme`
/// instead of the more verbose `Theme.of(context)...` everywhere.
extension ContextThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The app's custom colors (gradients, FAB, chips, chart palette) beyond
  /// what [ColorScheme] provides. Always registered by [AppTheme.build], so
  /// this is safe to assume non-null.
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
