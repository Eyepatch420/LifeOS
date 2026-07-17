import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';
import 'package:lifeos/features/home/presentation/widgets/home_hero_section.dart';
import 'package:lifeos/shared/widgets/layouts/hero_scaffold.dart';
import 'package:lifeos/theme/time_of_day_theme.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const tint = TimeOfDayTint(
    gradient: [Color(0xFF2F6FED), Color(0xFF5B9BF0)],
    greeting: 'Good morning',
    bucket: TimeOfDayBucket.morning,
  );

  testWidgets('renders greeting, date, and user name from props', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const HomeHeroSection(
          greeting: 'Good morning',
          dateLabel: 'Monday, 1 January 2026',
          userName: 'Amaan',
          tint: tint,
          motivationalMessage: 'Keep going.',
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Good morning'), findsOneWidget);
    expect(find.text('Amaan'), findsOneWidget);
    expect(find.text('Monday, 1 January 2026'), findsOneWidget);
    expect(find.text('Keep going.'), findsOneWidget);
  });

  testWidgets('falls back to "there" when userName is empty', (tester) async {
    await tester.pumpWidget(
      wrap(
        const HomeHeroSection(
          greeting: 'Good morning',
          dateLabel: 'Monday, 1 January 2026',
          userName: '',
          tint: tint,
          motivationalMessage: 'Keep going.',
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
          HomeHeroSection(
            greeting: 'Good morning',
            dateLabel: 'Monday, 1 January 2026',
            userName: 'Amaan',
            tint: tint,
            motivationalMessage: 'Keep going.',
            onSearchTap: () => searchTapped = true,
            onNotificationsTap: () => notificationsTapped = true,
            onAvatarTap: () => avatarTapped = true,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      expect(searchTapped, isTrue);
      expect(notificationsTapped, isTrue);
      expect(avatarTapped, isTrue);
    },
  );

  testWidgets('regression: a long motivational message does not overflow the '
      'fixed-height hero (was: unbounded Text with no maxLines/ellipsis '
      'wrapping to 2 lines inside a Positioned with a hard height)', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroScaffold(
            hero: const HomeHeroSection(
              greeting: 'Good afternoon',
              dateLabel: 'Wednesday, 15 July 2026',
              userName: 'dasdas',
              tint: tint,
              motivationalMessage:
                  'Small progress today, big change tomorrow. Keep '
                  'showing up for yourself every single day this week.',
            ),
            content: const SizedBox(height: 400),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
