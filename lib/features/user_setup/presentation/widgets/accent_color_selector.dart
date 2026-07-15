import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/theme/workspace_theme.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

const Map<String, IconData> _workspaceIcons = {
  WorkspaceIds.home: Icons.home_rounded,
  WorkspaceIds.reminders: Icons.notifications_rounded,
  WorkspaceIds.health: Icons.favorite_rounded,
  WorkspaceIds.finance: Icons.account_balance_wallet_rounded,
  WorkspaceIds.documents: Icons.folder_rounded,
};

const Map<String, String> _workspaceLabels = {
  WorkspaceIds.home: 'Home',
  WorkspaceIds.reminders: 'Reminders',
  WorkspaceIds.health: 'Health',
  WorkspaceIds.finance: 'Finance',
  WorkspaceIds.documents: 'Documents',
};

/// Row of selectable workspace accent preview cards — icon + gradient
/// swatch + label, not a bare color circle — reused later by a Settings
/// module (see docs/future_work.md).
class AccentColorSelector extends StatelessWidget {
  const AccentColorSelector({
    required this.selectedWorkspaceId,
    required this.onSelected,
    super.key,
  });

  final String selectedWorkspaceId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in kWorkspaceThemes.entries)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _AccentPreviewCard(
                workspaceId: entry.key,
                theme: entry.value,
                selected: entry.key == selectedWorkspaceId,
                onTap: () => onSelected(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccentPreviewCard extends StatelessWidget {
  const _AccentPreviewCard({
    required this.workspaceId,
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final String workspaceId;
  final WorkspaceTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${_workspaceLabels[workspaceId]} accent color',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.easeOutCubic,
          width: 88,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? theme.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ]
                : const [],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: theme.heroGradient,
                  ),
                ),
                child: Icon(
                  _workspaceIcons[workspaceId],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _workspaceLabels[workspaceId] ?? workspaceId,
                style: context.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
