import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos/config/di/service_locator.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/extensions/datetime_extensions.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
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

/// The bridge from GetIt's raw [AppDatabase] singleton to Riverpod. Every
/// feature repository depends on this provider (or a DAO getter on it),
/// never on `getIt<AppDatabase>()` directly, so repositories stay
/// overridable in tests via `ProviderContainer(overrides: [...])`.
final databaseProvider = Provider<AppDatabase>((ref) => getIt());

final clockManagerProvider = Provider<ClockManager>((ref) => getIt());

/// The Riverpod-facing wrapper over GetIt's [NotificationScheduler] singleton
/// — [setupServiceLocator] awaits its async registration before `runApp()`,
/// so this synchronous `getIt()` resolve is always safe. Every feature
/// repository/`NotificationEngine` depends on this, never
/// `getIt<NotificationScheduler>()` directly, so it stays overridable in
/// tests.
final notificationSchedulerProvider = Provider<NotificationScheduler>(
  (ref) => getIt(),
);

/// Today's local date key (`yyyy-MM-dd`), re-evaluated once a minute. The
/// shared seam every feature keys "today" state off (habit completions,
/// mood entries, per-day agenda dismissals) so a session left open across
/// midnight rolls over lazily instead of requiring a background job — see
/// docs/architecture_principles.md. Lives in `core/di`, not
/// `features/home`, since Home is only one of several consumers.
final todayProvider = StreamProvider<String>((ref) {
  final clock = ref.watch(clockManagerProvider);
  Stream<String> tick() async* {
    yield clock.now().localDateKey;
    yield* Stream<String>.periodic(
      const Duration(minutes: 1),
      (_) => clock.now().localDateKey,
    ).distinct();
  }

  return tick().distinct();
});
