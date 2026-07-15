import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lifeos/core/database/app_database.dart';
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
    ..registerLazySingleton<LocalAuthentication>(LocalAuthentication.new);
}
