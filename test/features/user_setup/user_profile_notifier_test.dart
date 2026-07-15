import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/config/di/core_providers.dart';
import 'package:lifeos/core/error/failures.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:lifeos/theme/theme_providers.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory fake so this test never touches platform channels for secure
/// storage — mirrors the fake proven in user_profile_repository_impl_test.dart.
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

  Future<ProviderContainer> makeContainer() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        preferencesServiceProvider.overrideWithValue(PreferencesService(prefs)),
        secureStorageServiceProvider.overrideWithValue(
          SecureStorageService(_FakeSecureStorage({})),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'completeSetup() defensively syncs currentWorkspaceProvider and themeModeProvider '
    'even when called without prior UI-side live-preview writes',
    () async {
      final container = await makeContainer();

      // Sanity check: providers start at their defaults, not the values
      // completeSetup() will be asked to persist.
      expect(container.read(currentWorkspaceProvider), WorkspaceIds.home);
      expect(container.read(themeModeProvider), ThemeMode.system);

      await container
          .read(userProfileNotifierProvider.notifier)
          .completeSetup(
            name: 'Amaan',
            avatarAssetPath: 'fox',
            accentWorkspaceId: WorkspaceIds.finance,
            themeMode: ThemeMode.dark,
            dailyReminderEnabled: true,
            requestBiometricLock: false,
            canUseBiometrics: () async => false,
          );

      expect(container.read(currentWorkspaceProvider), WorkspaceIds.finance);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    },
  );

  test(
    'completeSetup() throws on an empty name and does not sync anything',
    () async {
      final container = await makeContainer();

      expect(
        () => container
            .read(userProfileNotifierProvider.notifier)
            .completeSetup(
              name: '   ',
              avatarAssetPath: 'fox',
              accentWorkspaceId: WorkspaceIds.finance,
              themeMode: ThemeMode.dark,
              dailyReminderEnabled: true,
              requestBiometricLock: false,
              canUseBiometrics: () async => false,
            ),
        throwsA(isA<ValidationFailure>()),
      );

      expect(container.read(currentWorkspaceProvider), WorkspaceIds.home);
      expect(container.read(themeModeProvider), ThemeMode.system);
    },
  );
}
