import 'dart:convert';
import '../../core/logging/logger.dart';

class JwtDecoder {
  static const String _logTag = 'JwtDecoder';

  static Map<String, dynamic> decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid token: expected 3 parts, got ${parts.length}');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('Invalid payload: expected a JSON object');
      }

      return payloadMap;
    } catch (e, stackTrace) {
      AppLogger.e('Error decoding JWT', e, stackTrace, _logTag);
      rethrow;
    }
  }

  static bool isExpired(String token) {
    try {
      final payload = decode(token);
      if (payload['exp'] == null) {
        return false;
      }

      final int exp = payload['exp'] as int;
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationTime);
    } catch (e) {
      return true;
    }
  }

  static String _decodeBase64(String str) {
    String output = str;

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
