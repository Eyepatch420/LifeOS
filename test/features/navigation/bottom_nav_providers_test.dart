import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/navigation/presentation/providers/bottom_nav_providers.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  test('bottomNavIndexProvider starts at 0', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(bottomNavIndexProvider), 0);
  });

  test('setIndex updates the nav index', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(bottomNavIndexProvider.notifier).setIndex(2);
    expect(container.read(bottomNavIndexProvider), 2);
  });

  test('currentWorkspaceProvider starts at home', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(currentWorkspaceProvider), WorkspaceIds.home);
  });

  test('setWorkspace updates the active workspace and its derived theme', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(currentWorkspaceProvider.notifier)
        .setWorkspace(WorkspaceIds.finance);

    expect(container.read(currentWorkspaceProvider), WorkspaceIds.finance);
    expect(
      container.read(activeWorkspaceThemeProvider).id,
      WorkspaceIds.finance,
    );
  });
}
