import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/features/navigation/presentation/providers/bottom_nav_providers.dart';
import 'package:lifeos/security/biometric_gate.dart';
import 'package:lifeos/shared/widgets/nav/floating_bottom_nav.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

const List<NavItemData> _navItems = [
  NavItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
  NavItemData(
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
    label: 'Reminders',
  ),
  NavItemData(
    icon: Icons.favorite_outline,
    activeIcon: Icons.favorite,
    label: 'Health',
  ),
  NavItemData(
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet,
    label: 'Finance',
  ),
  NavItemData(
    icon: Icons.folder_outlined,
    activeIcon: Icons.folder,
    label: 'Documents',
  ),
];

const List<String> _workspaceIdByIndex = [
  WorkspaceIds.home,
  WorkspaceIds.reminders,
  WorkspaceIds.health,
  WorkspaceIds.finance,
  WorkspaceIds.documents,
];

/// Hosts the 5 tab branches behind the floating bottom nav, gated by
/// [BiometricGate]. Tapping a tab drives both the shell branch and the
/// active workspace theme together.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BiometricGate(
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: FloatingBottomNav(
          items: _navItems,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).setIndex(index);
            ref
                .read(currentWorkspaceProvider.notifier)
                .setWorkspace(_workspaceIdByIndex[index]);
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
