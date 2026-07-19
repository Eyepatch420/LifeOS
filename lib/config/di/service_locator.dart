import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lifeos/core/database/app_database.dart';
import 'package:lifeos/core/services/background_service.dart';
import 'package:lifeos/core/services/clock_manager.dart';
import 'package:lifeos/core/services/foreground_timer.dart';
import 'package:lifeos/core/services/notification_scheduler.dart';
import 'package:lifeos/core/services/sync_manager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Registers raw, non-reactive singletons (platform plugin instances, the DB
/// connection). Riverpod providers build repositories/notifiers on top of
/// these — GetIt never depends on Riverpod. Must be awaited before
/// `runApp()` since [SharedPreferences.getInstance] is itself async.
Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<LocalAuthentication>(LocalAuthentication.new)
    ..registerLazySingleton<ClockManager>(() => const SystemClockManager())
    ..registerLazySingleton<BackgroundService>(
      () => const NoopBackgroundService(),
    )
    ..registerLazySingletonAsync<NotificationScheduler>(() async {
      final scheduler = LocalNotificationScheduler(
        FlutterLocalNotificationsPlugin(),
      );
      await scheduler.initialize();
      // Must run after `initialize()` (registers the tap callbacks) so a
      // cold-start payload is forwarded through the same
      // `notificationTapDispatcher` stream those callbacks use — see
      // `LocalNotificationScheduler.consumeLaunchPayload`'s doc comment.
      await scheduler.consumeLaunchPayload();
      return scheduler;
    })
    ..registerLazySingleton<SyncManager>(() => const NoopSyncManager())
    ..registerFactory<ForegroundTimer>(() => const NoopForegroundTimer());

  // Resolved eagerly (not left lazy) so every later `getIt<NotificationScheduler>()`
  // call — all synchronous, per the rest of this file's convention — is safe.
  await getIt.isReady<NotificationScheduler>();
}
