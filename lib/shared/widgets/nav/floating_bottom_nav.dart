import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

class NavItemData {
  const NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Custom floating navigation — deliberately NOT `NavigationBar` or
/// `BottomNavigationBar`. Built from Stack/Positioned/BackdropFilter so the
/// selected-tab pill slides between positions, the background frosts, and
/// icons/labels animate rather than snap. See docs/animation_spec.md.
class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _height = 68;

  @override
  Widget build(BuildContext context) {
    final fabColor = context.appColors.fabColor;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      // The pill's height is a fixed 68 — unbounded system text scaling
      // would overflow the icon+label column, so clamp it here.
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: _height,
              decoration: BoxDecoration(
                color: context.colorScheme.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: context.isDarkMode ? 0.4 : 0.12,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / items.length;
                  return Stack(
                    children: [
                      AnimatedAlign(
                        duration: AppDurations.medium,
                        curve: AppCurves.navPill,
                        alignment: Alignment(
                          items.length == 1
                              ? 0
                              : (currentIndex / (items.length - 1)) * 2 - 1,
                          0,
                        ),
                        child: AnimatedContainer(
                          duration: AppDurations.medium,
                          curve: AppCurves.easeOutCubic,
                          width: itemWidth,
                          height: _height,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Container(
                              // clamp: itemWidth can drop below the 16px inset
                              // on very narrow screens; a negative width throws.
                              width: (itemWidth - 16).clamp(0.0, itemWidth),
                              height: _height - 16,
                              decoration: BoxDecoration(
                                color: fabColor.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Expanded(
                              child: _NavIconButton(
                                item: items[i],
                                selected: i == currentIndex,
                                color: fabColor,
                                onTap: () => onTap(i),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.item,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final NavItemData item;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unselectedColor = context.colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: AppDurations.fast,
              curve: AppCurves.easeOutCubic,
              scale: selected ? 1.1 : 1,
              child: AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  key: ValueKey(selected),
                  color: selected ? color : unselectedColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? color : unselectedColor,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
