import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/shared/widgets/nav/floating_bottom_nav.dart';
import 'package:lifeos/theme/app_theme.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  const items = [
    NavItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
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

  Widget wrap(Widget nav, {double textScale = 1.0}) {
    return MaterialApp(
      theme: AppTheme.build(Brightness.light, kWorkspaceThemes.values.first),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(extendBody: true, bottomNavigationBar: nav),
      ),
    );
  }

  testWidgets('renders all items and highlights the current one', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(FloatingBottomNav(items: items, currentIndex: 2, onTap: (_) {})),
    );
    await tester.pumpAndSettle();

    for (final item in items) {
      expect(find.text(item.label), findsOneWidget);
    }
    // Selected tab shows its active (filled) icon, others their outline icon.
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping an item reports its index', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      wrap(
        FloatingBottomNav(
          items: items,
          currentIndex: 0,
          onTap: (i) => tapped = i,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finance'));
    expect(tapped, 3);
  });

  testWidgets('does not overflow at extreme system text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        FloatingBottomNav(items: items, currentIndex: 0, onTap: (_) {}),
        textScale: 3.0,
      ),
    );
    await tester.pumpAndSettle();

    // A RenderFlex overflow surfaces as a FlutterError in tests.
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not overflow or throw on a very narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(240, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(FloatingBottomNav(items: items, currentIndex: 0, onTap: (_) {})),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'does not overflow with long labels at high scale on a small phone',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      const longItems = [
        NavItemData(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Extremely Long Home Label',
        ),
        NavItemData(
          icon: Icons.folder_outlined,
          activeIcon: Icons.folder,
          label: 'Documents And Attachments',
        ),
      ];

      await tester.pumpWidget(
        wrap(
          FloatingBottomNav(items: longItems, currentIndex: 0, onTap: (_) {}),
          textScale: 2.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('selection pill moves toward the newly selected tab', (
    tester,
  ) async {
    Widget build(int index) => wrap(
      FloatingBottomNav(items: items, currentIndex: index, onTap: (_) {}),
    );

    await tester.pumpWidget(build(0));
    await tester.pumpAndSettle();
    final alignBefore =
        tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment
            as Alignment;

    await tester.pumpWidget(build(4));
    await tester.pumpAndSettle();
    final alignAfter =
        tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment
            as Alignment;

    expect(alignBefore.x, -1);
    expect(alignAfter.x, 1);
  });
}
