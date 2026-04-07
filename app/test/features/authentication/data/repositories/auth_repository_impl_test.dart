import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/exceptions.dart';
import 'package:gatuno/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:gatuno/features/authentication/domain/entities/auth_tokens.dart';
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
    test('signIn returns AuthTokens on success', () async {
      final responseData = {
        'access_token': 'access',
        'refresh_token': 'refresh',
      };

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

      final result = await repository.signIn('test@example.com', 'password');

      expect(result, isA<AuthTokens>());
      expect(result.accessToken, 'access');
      expect(result.refreshToken, 'refresh');
    });

    test(
      'signIn throws ValidationException on invalid response format',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'invalid': 'format'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => repository.signIn('a', 'b'),
          throwsA(isA<ValidationException>()),
        );
      },
    );

    test('signIn throws ServerException on unexpected status code', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          data: {'some': 'data'},
          statusCode: 202, // Not 200 or 201
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () => repository.signIn('a', 'b'),
        throwsA(isA<ServerException>()),
      );
    });

    test('signUp returns void on success', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async =>
            Response(statusCode: 201, requestOptions: RequestOptions(path: '')),
      );

      await repository.signUp('test@example.com', 'password');

      verify(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: {'email': 'test@example.com', 'password': 'password'},
        ),
      ).called(1);
    });

    test('refreshToken returns AuthTokens on success', () async {
      final responseData = {
        'access_token': 'new_access',
        'refresh_token': 'new_refresh',
      };

      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.refreshToken('old_refresh');

      expect(result.accessToken, 'new_access');
      expect(result.refreshToken, 'new_refresh');

      verify(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: <String, dynamic>{},
          options: any(
            named: 'options',
            that: isA<Options>().having(
              (o) => o.headers?['Cookie'],
              'Cookie header',
              'refreshToken=old_refresh',
            ),
          ),
        ),
      ).called(1);
    });

    test('logout calls GET with Cookie header', () async {
      when(
        () => mockDio.get<dynamic>(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async =>
            Response(statusCode: 200, requestOptions: RequestOptions(path: '')),
      );

      await repository.logout('some_refresh');

      verify(
        () => mockDio.get<dynamic>(
          any(),
          options: any(
            named: 'options',
            that: isA<Options>().having(
              (o) => o.headers?['Cookie'],
              'Cookie header',
              'refreshToken=some_refresh',
            ),
          ),
        ),
      ).called(1);
    });

    test('handles DioException using ApiExceptionHandler', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
            data: {'message': 'Unauthorized'},
          ),
        ),
      );

      expect(
        () => repository.signIn('a', 'b'),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });
}
