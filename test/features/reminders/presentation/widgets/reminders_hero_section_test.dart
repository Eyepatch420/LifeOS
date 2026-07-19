import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_hero_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  final theme = kWorkspaceThemes[WorkspaceIds.reminders]!;

  // The controls row's notifications button and the workspace nav's
  // "Reminders" chip both use Icons.notifications_outlined, so — unlike
  // search/avatar, whose icons are unique in the tree — the notifications
  // button must be found via its `Semantics(label: 'Notifications')`
  // ancestor rather than by icon alone.
  Finder findBySemanticsLabel(String label) => find.byWidgetPredicate(
    (widget) => widget is Semantics && widget.properties.label == label,
  );

  testWidgets('renders greeting, date, and user name from props', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        RemindersHeroSection(
          greeting: 'Good morning',
          dateLabel: 'Monday, 1 January 2026',
          userName: 'Amaan',
          theme: theme,
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Good morning'), findsOneWidget);
    expect(find.text('Amaan'), findsOneWidget);
    expect(find.text('Monday, 1 January 2026'), findsOneWidget);
  });

  testWidgets('falls back to "there" when userName is empty', (tester) async {
    await tester.pumpWidget(
      wrap(
        RemindersHeroSection(
          greeting: 'Good morning',
          dateLabel: 'Monday, 1 January 2026',
          userName: '',
          theme: theme,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('there'), findsOneWidget);
  });

  testWidgets(
    'invokes onSearchTap/onNotificationsTap/onAvatarTap when supplied',
    (tester) async {
      var searchTapped = false;
      var notificationsTapped = false;
      var avatarTapped = false;

      await tester.pumpWidget(
        wrap(
          RemindersHeroSection(
            greeting: 'Good morning',
            dateLabel: 'Monday, 1 January 2026',
            userName: 'Amaan',
            theme: theme,
            onSearchTap: () => searchTapped = true,
            onNotificationsTap: () => notificationsTapped = true,
            onAvatarTap: () => avatarTapped = true,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(findBySemanticsLabel('Search'));
      await tester.tap(findBySemanticsLabel('Notifications'));
      await tester.tap(findBySemanticsLabel('Profile'));
      await tester.pump();

      expect(searchTapped, isTrue);
      expect(notificationsTapped, isTrue);
      expect(avatarTapped, isTrue);
    },
  );

  testWidgets('participates in HeroScaffold hit-testing via the reported '
      'controls region, mirroring HomeHeroSection', (tester) async {
    var searchTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroScaffold(
            heroBuilder: (context, reportControlsRegion) =>
                RemindersHeroSection(
                  greeting: 'Good morning',
                  dateLabel: 'Monday, 1 January 2026',
                  userName: 'Amaan',
                  theme: theme,
                  onSearchTap: () => searchTapped = true,
                  onControlsRegionMeasured: reportControlsRegion,
                ),
            content: const SizedBox(height: 2000),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(findBySemanticsLabel('Search'));
    await tester.pump();

    expect(searchTapped, isTrue);
  });

  testWidgets(
    'a workspace nav pill tap reaches its onSelected callback through the '
    'full HeroScaffold composition — regression for the bug where '
    'HeroScaffold\'s full-bleed scroll view swallowed every pill tap '
    'because the workspace nav row was never included in the reported '
    'controls region',
    (tester) async {
      var plannerTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeroScaffold(
              heroBuilder: (context, reportControlsRegion) =>
                  RemindersHeroSection(
                    greeting: 'Good morning',
                    dateLabel: 'Monday, 1 January 2026',
                    userName: 'Amaan',
                    theme: theme,
                    navItems: [
                      const RemindersWorkspaceNavItem(
                        label: 'Reminders',
                        icon: Icons.notifications_outlined,
                      ),
                      RemindersWorkspaceNavItem(
                        label: 'Planner',
                        icon: Icons.calendar_month_outlined,
                        onSelected: () => plannerTapped = true,
                      ),
                    ],
                    onControlsRegionMeasured: reportControlsRegion,
                  ),
              content: const SizedBox(height: 2000),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // A real pointer tap, not a direct onTap() invocation — this is the
      // only way to prove the tap actually reaches through HeroScaffold's
      // Stack/RectExcludingPointer composition, not just that the callback
      // exists and works when called directly.
      await tester.tap(find.text('Planner'));
      await tester.pump();

      expect(plannerTapped, isTrue);
    },
  );

  testWidgets(
    'a horizontal drag on the workspace nav row is not swallowed by the '
    'HeroScaffold scroll view — the row itself still owns horizontal drag',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeroScaffold(
              heroBuilder: (context, reportControlsRegion) =>
                  RemindersHeroSection(
                    greeting: 'Good morning',
                    dateLabel: 'Monday, 1 January 2026',
                    userName: 'Amaan',
                    theme: theme,
                    onControlsRegionMeasured: reportControlsRegion,
                  ),
              content: const SizedBox(height: 2000),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Dragging over the nav row must not move HeroScaffold's own
      // CustomScrollView — if the drag were reaching the wrong scrollable,
      // this would scroll the sheet instead of (or as well as) the pill
      // row, which the exception-free/nav-still-rendered assertions below
      // would not by themselves catch, so this also checks the sheet
      // hasn't moved.
      final scrollableBefore = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels;

      await tester.drag(find.text('Reminders'), const Offset(-300, 0));
      await tester.pump();

      final scrollableAfter = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels;

      expect(tester.takeException(), isNull);
      expect(scrollableAfter, scrollableBefore);
    },
  );
}
