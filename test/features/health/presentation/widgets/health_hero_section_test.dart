import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/health/presentation/widgets/health_hero_section.dart';
import 'package:lifeos/features/reminders/presentation/widgets/reminders_workspace_nav.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  final theme = kWorkspaceThemes[WorkspaceIds.health]!;

  Finder findBySemanticsLabel(String label) => find.byWidgetPredicate(
    (widget) => widget is Semantics && widget.properties.label == label,
  );

  testWidgets('renders greeting, date, and user name from props', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        HealthHeroSection(
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
        HealthHeroSection(
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
          HealthHeroSection(
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

  testWidgets(
    'participates in HeroScaffold hit-testing via the reported controls '
    'region, mirroring RemindersHeroSection',
    (tester) async {
      var searchTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeroScaffold(
              heroBuilder: (context, reportControlsRegion) => HealthHeroSection(
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
    },
  );

  testWidgets(
    'a workspace nav pill tap reaches its onSelected callback through the '
    'full HeroScaffold composition — same hit-testing regression coverage '
    'as RemindersHeroSection, since HealthHeroSection copies the identical '
    'measured-region pattern',
    (tester) async {
      var medicationsTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeroScaffold(
              heroBuilder: (context, reportControlsRegion) => HealthHeroSection(
                greeting: 'Good morning',
                dateLabel: 'Monday, 1 January 2026',
                userName: 'Amaan',
                theme: theme,
                navItems: [
                  const RemindersWorkspaceNavItem(
                    label: 'Mood',
                    icon: Icons.mood_rounded,
                  ),
                  RemindersWorkspaceNavItem(
                    label: 'Medications',
                    icon: Icons.medication_outlined,
                    onSelected: () => medicationsTapped = true,
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

      await tester.tap(find.text('Medications'));
      await tester.pump();

      expect(medicationsTapped, isTrue);
    },
  );
}
