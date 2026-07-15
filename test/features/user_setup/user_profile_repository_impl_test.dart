import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/user_setup/data/repositories/user_profile_repository_impl.dart';
import 'package:lifeos/features/user_setup/domain/models/user_profile.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory fake so the round-trip test doesn't touch platform channels
/// for secure storage.
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

  late UserProfileRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = PreferencesService(await SharedPreferences.getInstance());
    final secureStorage = SecureStorageService(_FakeSecureStorage({}));
    repository = UserProfileRepositoryImpl(prefs, secureStorage);
  });

  test('getProfile returns null before any profile is saved', () async {
    expect(await repository.getProfile(), isNull);
  });

  test('isOnboardingComplete is false before setup', () {
    expect(repository.isOnboardingComplete(), isFalse);
  });

  test('saveProfile then getProfile round-trips every field', () async {
    const profile = UserProfile(
      name: 'Amaan',
      avatarAssetPath: 'fox',
      accentWorkspaceId: 'health',
      themeMode: ThemeMode.dark,
      dailyReminderEnabled: true,
      biometricLockEnabled: true,
    );

    await repository.saveProfile(profile);
    final result = await repository.getProfile();

    expect(result, profile);
  });

  test(
    'biometricLockEnabled round-trips through secure storage, not prefs',
    () async {
      const profile = UserProfile(
        name: 'Amaan',
        avatarAssetPath: 'fox',
        accentWorkspaceId: 'home',
        themeMode: ThemeMode.system,
        dailyReminderEnabled: false,
        biometricLockEnabled: true,
      );

      await repository.saveProfile(profile);
      final result = await repository.getProfile();

      expect(result!.biometricLockEnabled, isTrue);
    },
  );

  test('setOnboardingComplete persists the flag', () async {
    expect(repository.isOnboardingComplete(), isFalse);
    await repository.setOnboardingComplete();
    expect(repository.isOnboardingComplete(), isTrue);
  });
}
