import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over [FlutterSecureStorage] — reserved for values sensitive
/// enough that a plaintext prefs file shouldn't hold them (see
/// [SecureStorageKeys]).
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final raw = await read(key);
    if (raw == null) return defaultValue;
    return raw == 'true';
  }

  Future<void> writeBool(String key, bool value) =>
      write(key, value.toString());
}
