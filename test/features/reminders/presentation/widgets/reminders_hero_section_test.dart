import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_hero_section.dart';
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
}
