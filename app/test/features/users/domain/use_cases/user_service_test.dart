import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/users/domain/use_cases/user_service.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/users/data/data_sources/user_local_data_source.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserStorage extends Mock implements UserStorage {}

void main() {
  late UserService userService;
  late MockAuthService mockAuthService;
  late MockUserStorage mockUserStorage;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserStorage = MockUserStorage();
    userService = UserService(mockAuthService, mockUserStorage);
  });

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

  group('UserService', () {
    test('getCurrentUser should return UserModel for valid token', () async {
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
      final payload = {
        'sub': '123',
        'email': 'test@example.com',
        'roles': ['user'],
        'exp': exp,
      };
      final token = createMockToken(payload);

      when(
        () => mockAuthService.getAccessToken(),
      ).thenAnswer((_) async => token);

      final user = await userService.getCurrentUser();

      expect(user, isNotNull);
      expect(user!.id, equals('123'));
      expect(user.email, equals('test@example.com'));
    });

    test('getCurrentUser should return null for expired token', () async {
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 3600;
      final payload = {
        'sub': '123',
        'email': 'test@example.com',
        'roles': ['user'],
        'exp': exp,
      };
      final token = createMockToken(payload);

      when(
        () => mockAuthService.getAccessToken(),
      ).thenAnswer((_) async => token);

      final user = await userService.getCurrentUser();

      expect(user, isNull);
    });

    test('getCurrentUser should return null for null token', () async {
      when(
        () => mockAuthService.getAccessToken(),
      ).thenAnswer((_) async => null);

      final user = await userService.getCurrentUser();

      expect(user, isNull);
    });

    test('setSensitiveContentEnabled should call storage', () async {
      when(
        () => mockUserStorage.setSensitiveContentEnabled(any()),
      ).thenAnswer((_) async {});

      await userService.setSensitiveContentEnabled(true);

      verify(() => mockUserStorage.setSensitiveContentEnabled(true)).called(1);
    });

    test('isSensitiveContentEnabled should call storage', () async {
      when(
        () => mockUserStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => true);

      final result = await userService.isSensitiveContentEnabled();

      expect(result, isTrue);
      verify(() => mockUserStorage.isSensitiveContentEnabled()).called(1);
    });

    test('logout should call authService.logout', () async {
      when(() => mockAuthService.logout()).thenAnswer((_) async {});

      await userService.logout();

      verify(() => mockAuthService.logout()).called(1);
    });
  });
}
