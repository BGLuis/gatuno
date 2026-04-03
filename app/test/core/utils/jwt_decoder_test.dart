import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/utils/jwt_decoder.dart';

void main() {
  group('JwtDecoder', () {
    String createMockToken(Map<String, dynamic> payload) {
      const header = '{"alg":"HS256","typ":"JWT"}';
      final headerEncoded = base64Url
          .encode(utf8.encode(header))
          .replaceAll('=', '');
      final payloadEncoded = base64Url
          .encode(utf8.encode(json.encode(payload)))
          .replaceAll('=', '');
      return '$headerEncoded.$payloadEncoded.signature';
    }

    test('decode should return payload map for valid token', () {
      final payload = {
        'sub': '123',
        'email': 'test@example.com',
        'roles': ['user'],
      };
      final token = createMockToken(payload);

      final decoded = JwtDecoder.decode(token);

      expect(decoded['sub'], equals('123'));
      expect(decoded['email'], equals('test@example.com'));
      expect(decoded['roles'], equals(['user']));
    });

    test('decode should throw for invalid token format', () {
      expect(() => JwtDecoder.decode('invalid.token'), throwsException);
    });

    test('isExpired should return false for token with future exp', () {
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
      final token = createMockToken({'exp': exp});

      expect(JwtDecoder.isExpired(token), isFalse);
    });

    test('isExpired should return true for token with past exp', () {
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 3600;
      final token = createMockToken({'exp': exp});

      expect(JwtDecoder.isExpired(token), isTrue);
    });

    test('isExpired should return true for invalid token', () {
      expect(JwtDecoder.isExpired('invalid'), isTrue);
    });
  });
}
