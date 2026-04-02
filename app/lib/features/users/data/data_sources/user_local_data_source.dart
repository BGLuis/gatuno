import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static const String _sensitiveContentKey = 'sensitive_content_enabled';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setSensitiveContentEnabled(bool enabled) async {
    await _storage.write(key: _sensitiveContentKey, value: enabled.toString());
  }

  Future<bool> isSensitiveContentEnabled() async {
    final value = await _storage.read(key: _sensitiveContentKey);
    return value == 'true';
  }
}
