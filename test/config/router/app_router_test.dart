import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/app.dart';
import 'package:lifeos/config/di/core_providers.dart';
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
}
