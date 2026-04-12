import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const String _tokenKey = 'access_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Legacy support for clearTokens if needed by other parts of the app,
  // but following the plan we rename it.
  Future<void> clearTokens() => clearToken();
}
