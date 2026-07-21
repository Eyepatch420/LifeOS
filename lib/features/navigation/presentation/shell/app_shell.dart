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
///
/// Also closes the back-button gap `StatefulShellRoute` leaves open by
/// default: each branch owns its own independent `Navigator` (preserved via
/// `IndexedStack`), so pressing system back at a non-Home branch's ROOT
/// falls through to the OS and exits the app instead of returning to Home —
/// there is no built-in "step back to the previous branch" behavior. The
/// [PopScope] below makes system back consistently walk
/// Nested Screen -> Workspace Root -> Home Root -> Exit:
/// - A pushed screen (Reminder Detail, New Habit, etc.) is popped by its
///   own branch `Navigator` before this `PopScope` is ever consulted, since
///   that pop happens on a `Navigator` further down the tree — unaffected.
/// - At any non-Home branch's root, `canPop` is false, so the pop is
///   intercepted and redirected to `goBranch(0, initialLocation: true)` —
///   deliberately the ROOT of Home, not whatever Home's `Navigator` last had
///   pushed (`goBranch`'s default `initialLocation: false` would instead
///   restore Home's preserved stack, which is the right behavior for
///   tapping the Home tab icon, but wrong here: back should always land on
///   Home's root, not resume a mid-note-editing state from earlier).
/// - At Home's own root, `canPop` is true and the pop is allowed through
///   to the OS, exiting the app on Android (a no-op back gesture on iOS).
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Workspace/theme ownership lives here, not at individual navigation
    // call sites (bottom nav, Search, notification taps, deep links). This
    // build method runs on every branch change regardless of *how* the
    // branch was reached — `navigationShell.currentIndex` is go_router's own
    // authoritative branch index — so syncing `currentWorkspaceProvider`
    // from it here is the single point that keeps route and theme
    // consistent. Previously each navigation call site had to remember to
    // call `setWorkspace()` itself; Search's `goNamed` calls didn't, which
    // left the workspace theme stuck on the previous tab after navigating
    // through Search into a different workspace.
    final workspaceId = _workspaceIdByIndex[navigationShell.currentIndex];
    if (ref.read(currentWorkspaceProvider) != workspaceId) {
      Future.microtask(
        () => ref.read(currentWorkspaceProvider.notifier).setWorkspace(workspaceId),
      );
    }

    return BiometricGate(
      child: PopScope(
        canPop: navigationShell.currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          ref.read(bottomNavIndexProvider.notifier).setIndex(0);
          navigationShell.goBranch(0, initialLocation: true);
        },
        child: Scaffold(
          extendBody: true,
          body: navigationShell,
          bottomNavigationBar: FloatingBottomNav(
            items: _navItems,
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              ref.read(bottomNavIndexProvider.notifier).setIndex(index);
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
