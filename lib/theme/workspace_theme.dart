import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_theme.freezed.dart';

/// The per-workspace color set (Home/Reminders/Health/Finance/Documents).
/// Swapping the active workspace re-colors the primary seed, FAB, chips,
/// and chart palette without a full app rebuild — see `theme_providers.dart`.
@freezed
abstract class WorkspaceTheme with _$WorkspaceTheme {
  const factory WorkspaceTheme({
    required String id,
    required Color primary,
    required Color secondary,
    required List<Color> heroGradient,
    required Color fabColor,
    required Color chipSelectedColor,
    required List<Color> chartPalette,
  }) = _WorkspaceTheme;
}
