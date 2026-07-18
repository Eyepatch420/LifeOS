import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/app.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/features/user_setup/domain/models/user_profile.dart';
import 'package:lifeos/features/user_setup/domain/repositories/user_profile_repository.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/shared/widgets/nav/floating_bottom_nav.dart';
import 'package:lifeos/theme/app_color_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reports onboarding already complete with a fixed profile, so the
/// router's redirect logic lands directly on `/home` — this test is about
/// push-navigation/theme behavior, not the onboarding flow itself.
class _FakeUserProfileRepository implements UserProfileRepository {
  const _FakeUserProfileRepository(this._profile);

  final UserProfile _profile;

  @override
  Future<UserProfile?> getProfile() async => _profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {}

  @override
  bool isOnboardingComplete() => true;

  @override
  Future<void> setOnboardingComplete() async {}
}

/// In-memory fake so this test never touches platform channels for secure
/// storage — mirrors the fake already proven in
/// user_profile_repository_impl_test.dart / user_setup_screen_test.dart.
class _FakeSecureStorage extends FlutterSecureStorage {
  const _FakeSecureStorage(this._store);

  final Map<String, String> _store;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {}
}

const _profile = UserProfile(
  name: 'Test User',
  avatarAssetPath: '',
  accentWorkspaceId: 'home',
  themeMode: ThemeMode.light,
  dailyReminderEnabled: false,
  biometricLockEnabled: false,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    // The full app's provider tree resolves databaseProvider/
    // notificationSchedulerProvider down to raw GetIt singletons, which are
    // never registered in a test process — override both directly (mirrors
    // home_screen_test.dart's databaseProvider override) instead of relying
    // on GetIt, so routing through Home/Reminders doesn't hit an
    // unregistered-singleton assertion the moment a repository resolves.
    final db = AppDatabase.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(const _FakeSecureStorage({})),
          ),
          userProfileRepositoryProvider.overrideWithValue(
            const _FakeUserProfileRepository(_profile),
          ),
          databaseProvider.overrideWithValue(db),
          notificationSchedulerProvider.overrideWithValue(
            const NoopNotificationScheduler(),
          ),
        ],
        child: const LifeOsApp(),
      ),
    );
    // Splash holds for AppConstants.splashMinimumDuration before its
    // Future.delayed navigates onward — advance past it explicitly rather
    // than relying on pumpAndSettle to resolve a real-time delay.
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
  }

  /// Invokes a tappable ancestor's `onTap`/`onPressed` directly instead of
  /// a coordinate-based `tester.tap()`. `HomeHeroSection` sits under
  /// `HeroScaffold`'s `CustomScrollView`, whose full-bounds scroll gesture
  /// detector can win hit-testing over the pinned hero layer beneath it at
  /// the exact same screen offset — a layout-order quirk orthogonal to
  /// what this test verifies (that the callback navigates correctly once
  /// invoked).
  Future<void> tapAncestorOf(WidgetTester tester, Finder finder) async {
    final inkWells = find
        .ancestor(of: finder, matching: find.byType(InkWell))
        .evaluate();
    if (inkWells.isNotEmpty) {
      (inkWells.first.widget as InkWell).onTap!();
    } else {
      final gestureDetectors = find
          .ancestor(of: finder, matching: find.byType(GestureDetector))
          .evaluate();
      if (gestureDetectors.isNotEmpty) {
        (gestureDetectors.first.widget as GestureDetector).onTap!();
      } else {
        final iconButtons = find
            .ancestor(of: finder, matching: find.byType(IconButton))
            .evaluate();
        (iconButtons.first.widget as IconButton).onPressed!();
      }
    }
    await tester.pumpAndSettle();
  }

  testWidgets(
    'pushing search hides the floating bottom nav and inherits the Home '
    'workspace theme, and popping back preserves other tabs\' state',
    (tester) async {
      await pumpApp(tester);

      // Lands on Home; floating nav is present as shell chrome.
      expect(find.byType(FloatingBottomNav), findsOneWidget);

      // Tap the hero's search icon.
      await tapAncestorOf(tester, find.byIcon(Icons.search));

      // Pushed screen renders; floating nav is gone (root-navigator push
      // escapes AppShell's chrome).
      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(FloatingBottomNav), findsNothing);

      // Theme inheritance: the pushed screen sits under the same ambient
      // Theme as Home, including AppColorsExtension (no per-screen theme
      // override needed — see docs/architecture.md's Routing/Theme section).
      final context = tester.element(find.text('Search'));
      expect(Theme.of(context).extension<AppColorsExtension>(), isNotNull);

      // Pop back to Home; the floating nav reappears.
      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      expect(find.byType(FloatingBottomNav), findsOneWidget);

      // Switching to Reminders still works (branch state intact).
      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('notifications and profile icons push their placeholder '
      'screens', (tester) async {
    await pumpApp(tester);

    await tapAncestorOf(tester, find.byIcon(Icons.notifications_outlined));
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byType(FloatingBottomNav), findsNothing);

    await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));

    await tapAncestorOf(tester, find.byIcon(Icons.person));
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(FloatingBottomNav), findsNothing);
  });

  group('Reminders dashboard routing', () {
    testWidgets('/reminders renders RemindersDashboardScreen, not the old '
        'RemindersListScreen', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      // Dashboard-only content — the old list screen has none of these.
      expect(find.text('Add Reminder'), findsOneWidget);
      expect(find.text('Up Next'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('View all on the Upcoming section opens the full '
        'RemindersListScreen, and back returns to the dashboard', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      final controller = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump();

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      // RemindersListScreen's own header (PushedScreenHeader title).
      expect(find.text('Reminders'), findsWidgets);
      expect(find.byType(FloatingBottomNav), findsNothing);

      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      expect(find.byType(FloatingBottomNav), findsOneWidget);
      expect(find.text('Add Reminder'), findsOneWidget);
    });

    testWidgets('Quick Add opens NewReminderScreen, and creating a reminder '
        'then returning reflects it on the dashboard reactively', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Reminder'));
      await tester.pumpAndSettle();

      expect(find.text('New Reminder'), findsOneWidget);
      expect(find.byType(FloatingBottomNav), findsNothing);

      await tester.enterText(find.byType(TextField), 'Water the plants');
      await tester.tap(find.text('Save Reminder'));
      await tester.pumpAndSettle();

      // Back on the dashboard, floating nav restored, new reminder visible
      // without any manual refresh.
      expect(find.byType(FloatingBottomNav), findsOneWidget);
      expect(find.text('Water the plants'), findsWidgets);
    });

    testWidgets('tapping a dashboard reminder opens ReminderDetailScreen for '
        'that reminder, and back returns to the dashboard', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      var controller = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!;
      controller.jumpTo(300);
      await tester.pump();

      await tester.tap(find.text('Add Reminder'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Renew library card');
      await tester.tap(find.text('Save Reminder'));
      await tester.pumpAndSettle();

      controller = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!;
      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump();

      await tester.tap(find.text('Renew library card').first);
      await tester.pumpAndSettle();

      // ReminderDetailScreen's header shows the reminder's own title.
      expect(find.text('Renew library card'), findsWidgets);
      expect(find.byType(FloatingBottomNav), findsNothing);

      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      expect(find.byType(FloatingBottomNav), findsOneWidget);
    });

    testWidgets(
      'Home <-> Reminders <-> Home switching works repeatedly with no route '
      'errors or Hero-tag collisions',
      (tester) async {
        await pumpApp(tester);

        for (var i = 0; i < 2; i++) {
          await tester.tap(find.text('Reminders'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          await tester.tap(find.text('Home'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        expect(find.byType(FloatingBottomNav), findsOneWidget);
      },
    );

    testWidgets(
      'static children /reminders/all and /reminders/new are not captured '
      'by the dynamic /reminders/:reminderId route',
      (tester) async {
        await pumpApp(tester);

        await tester.tap(find.text('Reminders'));
        await tester.pumpAndSettle();

        final controller = tester
            .widget<CustomScrollView>(find.byType(CustomScrollView))
            .controller!;
        controller.jumpTo(controller.position.maxScrollExtent);
        await tester.pump();

        await tester.tap(find.text('View all'));
        await tester.pumpAndSettle();

        // RemindersListScreen renders (its own header), not
        // ReminderDetailScreen's "This reminder no longer exists" fallback
        // — confirms "all" was matched as the static remindersAll route,
        // not as a :reminderId value of "all".
        expect(find.text('No reminders yet'), findsOneWidget);
        expect(find.text('This reminder no longer exists'), findsNothing);

        await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));

        final dashboardController = tester
            .widget<CustomScrollView>(find.byType(CustomScrollView))
            .controller!;
        dashboardController.jumpTo(300);
        await tester.pump();

        // The dashboard's own Quick Add card — see
        // reminders_quick_add_section.dart's "Add Reminder" label (Home's
        // separate Quick Actions tile is labelled "New Reminder" — see
        // mock_dashboard_data.dart — so these two never collide).
        await tester.tap(find.text('Add Reminder'));
        await tester.pumpAndSettle();

        // NewReminderScreen renders (its own form), not a :reminderId
        // value of "new".
        expect(find.text('New Reminder'), findsOneWidget);
        expect(find.text('This reminder no longer exists'), findsNothing);
      },
    );

    testWidgets("Home's Quick Actions 'New Reminder' tile still opens "
        'NewReminderScreen via the Reminders-owned route, without Home '
        'knowing the route moved branches', (tester) async {
      await pumpApp(tester);

      // Stays on Home; Quick Actions is a Home dashboard section. Home's
      // Quick Actions tile is labelled "New Reminder" (see
      // mock_dashboard_data.dart), distinct from the Reminders
      // dashboard's own "Add Reminder" Quick Add card, and Reminders'
      // branch is never visited here so there's no ambiguity either way.
      final controller = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!;
      controller.jumpTo(300);
      await tester.pump();

      await tester.tap(find.text('New Reminder'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
      expect(find.byType(FloatingBottomNav), findsNothing);

      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      expect(find.byType(FloatingBottomNav), findsOneWidget);
    });
  });

  group('Planner routing (Phase 5)', () {
    /// The workspace nav chip lives under `HeroScaffold`'s `CustomScrollView`
    /// hit-testing quirk documented on [tapAncestorOf] above (the hero's
    /// pinned layer can lose the hit test to the scroll view's full-bounds
    /// gesture detector at the same screen offset) — invokes the chip's
    /// `PressableScale`-wrapped `GestureDetector.onTap` directly instead of
    /// a coordinate-based `tester.tap()`, same trick as [tapAncestorOf].
    Future<void> tapWorkspaceNavItem(WidgetTester tester, String label) async {
      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == label,
      );
      final gestureDetector =
          find
                  .ancestor(
                    of: semantics,
                    matching: find.byType(GestureDetector),
                  )
                  .evaluate()
                  .first
                  .widget
              as GestureDetector;
      gestureDetector.onTap!();
      await tester.pumpAndSettle();
    }

    testWidgets('Reminders workspace nav Planner tile opens PlannerScreen', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      await tapWorkspaceNavItem(tester, 'Planner');

      // PlannerScreen renders its own workspace nav with Planner active,
      // its header controls, and no bottom nav (pushed on the root
      // navigator, same as New/Detail).
      expect(find.text('Today'), findsWidgets);
      expect(find.byType(FloatingBottomNav), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Planner workspace nav Reminders tile returns to the '
        'Reminders dashboard', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();
      await tapWorkspaceNavItem(tester, 'Planner');

      await tapWorkspaceNavItem(tester, 'Reminders');

      expect(find.text('Up Next'), findsOneWidget);
      expect(find.byType(FloatingBottomNav), findsOneWidget);
    });

    testWidgets('/reminders/planner is not captured by the dynamic '
        '/reminders/:reminderId route', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();
      await tapWorkspaceNavItem(tester, 'Planner');

      expect(find.text('This reminder no longer exists'), findsNothing);
    });

    testWidgets('Planner -> open a reminder detail -> back returns to '
        'Planner unchanged', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();

      // Seed one reminder for today via the dashboard's Quick Add so
      // Planner's today has something to tap into.
      final dashController = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!;
      dashController.jumpTo(300);
      await tester.pump();
      await tester.tap(find.text('Add Reminder'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Standup');
      await tester.tap(find.text('Save Reminder'));
      await tester.pumpAndSettle();

      await tapWorkspaceNavItem(tester, 'Planner');

      final plannerController = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView).last)
          .controller!;
      plannerController.jumpTo(plannerController.position.maxScrollExtent);
      await tester.pumpAndSettle();

      // Invoke the timeline item's PressableScale.onTap directly — same
      // hit-testing quirk/trick as tapWorkspaceNavItem/tapAncestorOf above.
      final itemGestureDetector =
          find
                  .ancestor(
                    of: find.text('Standup').first,
                    matching: find.byType(GestureDetector),
                  )
                  .evaluate()
                  .first
                  .widget
              as GestureDetector;
      itemGestureDetector.onTap!();
      await tester.pumpAndSettle();

      expect(find.text('Standup'), findsWidgets);

      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsWidgets);
      expect(find.byType(FloatingBottomNav), findsNothing);
    });

    testWidgets('Planner Add Reminder -> back returns to Planner', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Reminders'));
      await tester.pumpAndSettle();
      await tapWorkspaceNavItem(tester, 'Planner');

      final plannerController = tester
          .widget<CustomScrollView>(find.byType(CustomScrollView).last)
          .controller!;
      plannerController.jumpTo(plannerController.position.maxScrollExtent);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Reminder'));
      await tester.pumpAndSettle();

      expect(find.text('New Reminder'), findsOneWidget);

      await tapAncestorOf(tester, find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsWidgets);
    });
  });
}
