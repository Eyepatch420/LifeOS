import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/theme/workspace_theme.dart';

/// One selectable item in [RemindersWorkspaceNav]. `onSelected` is nullable
/// so an item can be rendered without being navigation-capable yet
/// (Planner/Habits/Calendar in Phase 2) without special-casing the item
/// model itself — later phases wire real navigation by supplying a
/// callback, not by changing this shape.
@immutable
class RemindersWorkspaceNavItem {
  const RemindersWorkspaceNavItem({
    required this.label,
    required this.icon,
    this.onSelected,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onSelected;
}

/// The secondary in-hero workspace nav row seen under the Reminders hero
/// (Reminders / Planner / Habits / Calendar): a horizontally scrollable row
/// of pill chips, the active one filled with the current [WorkspaceTheme]'s
/// accent. Data-driven via [items]/[selectedIndex] rather than hardcoded,
/// so later phases can wire Planner/Habits/Calendar navigation by supplying
/// real `onSelected` callbacks without restructuring this widget.
///
/// Has no [HeroScaffold]/hit-testing involvement — it's ordinary content
/// inside the hero's `Column`, same as `HomeHeroSection`'s date row or
/// `MotivationalBanner`.
class RemindersWorkspaceNav extends StatelessWidget {
  const RemindersWorkspaceNav({
    required this.theme,
    super.key,
    this.items = defaultItems,
    this.selectedIndex = 0,
  });

  final WorkspaceTheme theme;
  final List<RemindersWorkspaceNavItem> items;
  final int selectedIndex;

  /// Non-navigating default items — every existing call site
  /// (`RemindersHeroSection` with no `navItems` override, and any test that
  /// constructs [RemindersWorkspaceNav] directly) keeps this exact shape.
  /// [PlanningWorkspaceScaffold] supplies its own section-aware item list
  /// with real `onSelected` callbacks instead of this default.
  static const defaultItems = [
    RemindersWorkspaceNavItem(
      label: 'Reminders',
      icon: Icons.notifications_outlined,
    ),
    RemindersWorkspaceNavItem(
      label: 'Planner',
      icon: Icons.calendar_month_outlined,
    ),
    RemindersWorkspaceNavItem(
      label: 'Habits',
      icon: Icons.track_changes_outlined,
    ),
    RemindersWorkspaceNavItem(
      label: 'Calendar',
      icon: Icons.calendar_today_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i == items.length - 1 ? 0 : AppSpacing.sm,
              ),
              child: _WorkspaceNavChip(
                item: items[i],
                selected: i == selectedIndex,
                accent: theme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _WorkspaceNavChip extends StatelessWidget {
  const _WorkspaceNavChip({
    required this.item,
    required this.selected,
    required this.accent,
  });

  final RemindersWorkspaceNavItem item;
  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: item.onSelected,
      child: Semantics(
        button: true,
        selected: selected,
        label: item.label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 16,
                color: selected ? accent : Colors.white,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                item.label,
                style: TextStyle(
                  color: selected ? accent : Colors.white,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
