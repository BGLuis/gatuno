import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../../data/data_sources/settings_local_data_source.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/logging/logger.dart';

class SettingsService extends ChangeNotifier {
  final SettingsStorage _storage;
  final DioClient _dioClient;
  static const String _logTag = 'SETTINGS_SERVICE';

  String? _apiUrl;
  bool _sensitiveContentEnabled = false;
  bool _isInitialized = false;

  SettingsService(this._storage, this._dioClient);

  String? get apiUrl => _apiUrl;
  bool get sensitiveContentEnabled => _sensitiveContentEnabled;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _apiUrl = await _storage.getApiUrl();
      _sensitiveContentEnabled = await _storage.isSensitiveContentEnabled();

      if (_apiUrl != null) {
        _dioClient.updateBaseUrl(_apiUrl!);
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e('Error initializing SettingsService', e, stackTrace, _logTag);
    }
  }

  Future<void> setApiUrl(String url) async {
    try {
      await _storage.setApiUrl(url);
      _apiUrl = url;
      _dioClient.updateBaseUrl(url);
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e('Error setting API URL', e, stackTrace, _logTag);
      rethrow;
    }
  }

  Future<void> setSensitiveContentEnabled(bool enabled) async {
    try {
      await _storage.setSensitiveContentEnabled(enabled);
      _sensitiveContentEnabled = enabled;
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e(
        'Error setting sensitive content enabled',
        e,
        stackTrace,
        _logTag,
      );
      rethrow;
    }
  }

  Future<bool> validateApiUrl(String url) async {
    if (url.isEmpty) return false;

    try {
      // Ensure the URL doesn't have a trailing slash for consistency
      final formattedUrl = url.endsWith('/')
          ? url.substring(0, url.length - 1)
          : url;
      final uri = Uri.tryParse(formattedUrl);
      if (uri == null) return false;

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) {
            return host == uri.host;
          };
          return client;
        },
      );

      final response = await dio.get<Map<String, dynamic>>(
        '$formattedUrl/health/liveness',
      );
      return response.statusCode == 200;
    } catch (e, stackTrace) {
      AppLogger.e('Error validating API URL', e, stackTrace, _logTag);
      return false;
    }
  }
}
