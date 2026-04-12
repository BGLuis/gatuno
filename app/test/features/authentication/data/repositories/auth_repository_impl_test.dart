import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:gatuno/features/authentication/data/models/auth_response.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRepositoryImpl repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = AuthRepositoryImpl(mockDio);
  });

  group('AuthRepositoryImpl', () {
    test('signIn returns AuthToken on success', () async {
      final responseData = {'access_token': 'access'};
      when(
        () =>
            mockDio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.signIn('email', 'password');

      expect(result.token, 'access');
      expect(result, isA<AuthResponse>());
    });

    test('refreshToken returns AuthToken on success', () async {
      final responseData = {'access_token': 'new_token'};
      when(
        () =>
            mockDio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.refreshToken();

      expect(result.token, 'new_token');
      expect(result, isA<AuthResponse>());
    });

    test('logout performs request without explicit headers', () async {
      when(() => mockDio.get<dynamic>(any())).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await repository.logout();

      verify(() => mockDio.get<dynamic>(any())).called(1);
    });
  });
}
