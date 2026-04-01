import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/data/models/auth_response.dart';
import 'package:gatuno/core/network/exceptions.dart';

void main() {
  group('AuthResponse', () {
    test('fromJson returns AuthResponse on valid map (snake_case)', () {
      final json = {'access_token': 'access', 'refresh_token': 'refresh'};
      final result = AuthResponse.fromJson(json);
      expect(result.accessToken, 'access');
      expect(result.refreshToken, 'refresh');
    });

    test('fromJson returns AuthResponse on valid map (camelCase)', () {
      final json = {'accessToken': 'access', 'refreshToken': 'refresh'};
      final result = AuthResponse.fromJson(json);
      expect(result.accessToken, 'access');
      expect(result.refreshToken, 'refresh');
    });

    test('fromJson throws ValidationException on missing access_token', () {
      final json = {'refresh_token': 'refresh'};
      expect(
        () => AuthResponse.fromJson(json),
        throwsA(isA<ValidationException>()),
      );
    });

    test('fromJson throws ValidationException on missing refresh_token', () {
      final json = {'access_token': 'access'};
      expect(
        () => AuthResponse.fromJson(json),
        throwsA(isA<ValidationException>()),
      );
    });

    test('toJson returns correct map', () {
      final response = AuthResponse(accessToken: 'a', refreshToken: 'b');
      final result = response.toJson();
      expect(result['access_token'], 'a');
      expect(result['refresh_token'], 'b');
    });
  });
}
