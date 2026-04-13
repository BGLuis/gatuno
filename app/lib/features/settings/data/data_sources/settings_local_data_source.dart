import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsStorage {
  static const String _apiUrlKey = 'api_base_url';
  static const String _sensitiveContentKey = 'sensitive_content_enabled';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setApiUrl(String url) async {
    await _storage.write(key: _apiUrlKey, value: url);
  }

  Future<String?> getApiUrl() async {
    return await _storage.read(key: _apiUrlKey);
  }

  Future<void> setSensitiveContentEnabled(bool enabled) async {
    await _storage.write(key: _sensitiveContentKey, value: enabled.toString());
  }

  Future<bool> isSensitiveContentEnabled() async {
    final value = await _storage.read(key: _sensitiveContentKey);
    return value == 'true';
  }
}
