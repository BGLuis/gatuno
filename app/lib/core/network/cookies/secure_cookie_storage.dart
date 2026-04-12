import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A secure implementation of [Storage] for [PersistCookieJar].
/// Uses [FlutterSecureStorage] to persist cookies securely.
class SecureCookieStorage implements Storage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _prefix = 'cookie_';

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    // No specific initialization required for FlutterSecureStorage
  }

  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: '$_prefix$key');
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: '$_prefix$key', value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: '$_prefix$key');
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (final key in keys) {
      await _secureStorage.delete(key: '$_prefix$key');
    }
  }
}
