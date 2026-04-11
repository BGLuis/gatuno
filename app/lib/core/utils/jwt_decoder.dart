import 'dart:convert';
import '../../core/logging/logger.dart';
import 'exceptions.dart';

class JwtDecoder {
  static const String _logTag = 'JwtDecoder';

  static Map<String, dynamic> decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw InvalidJwtException(
          message: 'Invalid token: expected 3 parts, got ${parts.length}',
        );
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw InvalidJwtException(
          message: 'Invalid payload: expected a JSON object',
        );
      }

      return payloadMap;
    } catch (e, stackTrace) {
      if (e is InvalidJwtException) rethrow;
      AppLogger.e('Error decoding JWT', e, stackTrace, _logTag);
      throw InvalidJwtException(message: 'Error decoding JWT: $e');
    }
  }

  static bool isExpired(String token, {Duration threshold = Duration.zero}) {
    try {
      final payload = decode(token);
      if (payload['exp'] == null) {
        return false;
      }

      final int exp = payload['exp'] as int;
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().add(threshold).isAfter(expirationTime);
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
        throw InvalidJwtException(message: 'Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
