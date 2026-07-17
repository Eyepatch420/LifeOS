import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/features/user_setup/presentation/screens/user_setup_screen.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/accent_color_selector.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/setup_toggle_tile.dart';
import 'package:lifeos/features/user_setup/presentation/widgets/theme_mode_selector.dart';
import 'package:lifeos/services/biometric_service.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fake so this test never touches the `local_auth` platform channel
/// (which has no plugin registered in the widget-test environment and
/// would otherwise throw `MissingPluginException`, which is exactly the
/// class of failure `BiometricService.canAuthenticate()` is now hardened
/// against — but the raw `LocalAuthentication()` constructor itself still
/// needs a real platform to back it, so tests fake the whole service).
class _FakeBiometricService implements BiometricService {
  const _FakeBiometricService() : canAuthenticateResult = false;

  final bool canAuthenticateResult;

  @override
  Future<bool> canAuthenticate() async => canAuthenticateResult;

  @override
  Future<bool> authenticate({String reason = 'Unlock LifeOS'}) async => true;
}

/// In-memory fake so this test never touches platform channels for secure
/// storage — mirrors the fake already proven in
/// user_profile_repository_impl_test.dart.
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
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpSetup(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(_FakeSecureStorage({})),
          ),
        ],
        child: const MaterialApp(home: UserSetupScreen()),
      ),
    );
    await tester.pump();
  }

  /// Same as [pumpSetup] but with a real GoRouter so
  /// `context.goNamed(RouteNames.home)` actually navigates somewhere
  /// observable, for the "does Finish Setup actually leave this screen"
  /// regression tests below.
  Future<GoRouter> pumpSetupWithRouter(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: RoutePaths.userSetup,
      routes: [
        GoRoute(
          path: RoutePaths.userSetup,
          name: RouteNames.userSetup,
          builder: (context, state) => const UserSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
          secureStorageServiceProvider.overrideWithValue(
            SecureStorageService(_FakeSecureStorage({})),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    return router;
  }

  testWidgets('Finish setup button is disabled until a name is entered', (
    tester,
  ) async {
    await pumpSetup(tester);

    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Amaan');
    await tester.pump();

    final updatedButton = tester.widget<PrimaryButton>(
      find.byType(PrimaryButton),
    );
    expect(updatedButton.onPressed, isNotNull);
  });

  testWidgets(
    'selecting an accent color live-previews currentWorkspaceProvider',
    (tester) async {
      await pumpSetup(tester);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UserSetupScreen)),
      );
      expect(container.read(currentWorkspaceProvider), WorkspaceIds.home);

      // Tap the Finance accent preview card via its visible label text.
      await tester.tap(find.text('Finance'));
      await tester.pump();

      expect(container.read(currentWorkspaceProvider), WorkspaceIds.finance);
    },
  );

  testWidgets('selecting a theme mode live-previews themeModeProvider', (
    tester,
  ) async {
    await pumpSetup(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(UserSetupScreen)),
    );
    expect(container.read(themeModeProvider), ThemeMode.system);

    final darkSegment = find.descendant(
      of: find.byType(ThemeModeSelector),
      matching: find.text('Dark'),
    );
    await tester.tap(darkSegment);
    await tester.pump();

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('accent selector renders a preview card per workspace', (
    tester,
  ) async {
    await pumpSetup(tester);

    expect(find.byType(AccentColorSelector), findsOneWidget);
    for (final label in [
      'Home',
      'Reminders',
      'Health',
      'Finance',
      'Documents',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets(
    'regression: tapping Finish setup navigates to Home even when the '
    'device cannot determine biometric capability (was getting stuck on '
    'this screen when the platform channel threw instead of returning false)',
    (tester) async {
      final router = await pumpSetupWithRouter(tester);

      await tester.enterText(find.byType(TextField), 'Amaan');
      await tester.pump();

      // Enable Biometric lock — this is what previously caused
      // BiometricService.canAuthenticate() to propagate a platform
      // exception (e.g. missing macOS entitlement) uncaught, aborting
      // completeSetup() before it ever reached the navigation call.
      final biometricToggle = find.descendant(
        of: find.widgetWithText(SetupToggleTile, 'Biometric lock'),
        matching: find.byType(Switch),
      );
      await tester.ensureVisible(biometricToggle);
      await tester.pump();
      await tester.tap(biometricToggle);
      await tester.pump();

      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.pump();

      final buttonBeforeTap = tester.widget<PrimaryButton>(
        find.byType(PrimaryButton),
      );
      expect(
        buttonBeforeTap.onPressed,
        isNotNull,
        reason: 'Finish setup should be enabled once a name is entered',
      );

      await tester.tap(find.byType(PrimaryButton));
      // Let completeSetup()'s async work (including the now-defensive
      // canAuthenticate() call) resolve.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(tester.takeException(), isNull);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        RoutePaths.home,
      );
    },
  );

  testWidgets(
    'tapping Finish setup with a plain name (no biometric lock) navigates to Home',
    (tester) async {
      final router = await pumpSetupWithRouter(tester);

      await tester.enterText(find.byType(TextField), 'Amaan');
      await tester.pump();

      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.pump();
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(tester.takeException(), isNull);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        RoutePaths.home,
      );
    },
  );
}
