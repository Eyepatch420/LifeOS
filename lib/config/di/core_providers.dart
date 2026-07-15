import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/service_locator.dart';
import 'package:lifeos/services/biometric_service.dart';
import 'package:lifeos/services/preferences_service.dart';
import 'package:lifeos/services/secure_storage_service.dart';

/// Riverpod-facing wrappers over the raw singletons GetIt owns. Repositories
/// and notifiers depend on these providers, never on GetIt directly, so
/// they stay overridable in tests.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(getIt());
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(getIt());
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(getIt());
});
