import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:gatuno/features/authentication/data/models/auth_response.dart';
import 'package:gatuno/core/network/exceptions.dart';
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
    group('signIn', () {
      test('returns AuthToken on success', () async {
        final responseData = {'access_token': 'access'};
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
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

      test('throws ServerException when response data is invalid', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => repository.signIn('email', 'password'),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws Handled Exception on DioException', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        expect(
          () => repository.signIn('email', 'password'),
          throwsA(isA<NetworkException>()),
        );
      });

      test('rethrows AppExceptions', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(ValidationException(message: 'validation error'));

        expect(
          () => repository.signIn('email', 'password'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws AuthException on unexpected error', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('unexpected'));

        expect(
          () => repository.signIn('email', 'password'),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signUp', () {
      test('returns void on success', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await repository.signUp('email', 'password');

        verify(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: {'email': 'email', 'password': 'password'},
          ),
        ).called(1);
      });

      test('throws ServerException when statusCode is not 200/201', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 400,
            statusMessage: 'Bad Request',
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => repository.signUp('email', 'password'),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws Handled Exception on DioException', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 409,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        expect(
          () => repository.signUp('email', 'password'),
          throwsA(isA<AuthException>()),
        );
      });

      test('throws AuthException on unexpected error', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('unexpected'));

        expect(
          () => repository.signUp('email', 'password'),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('logout', () {
      test('performs request and logs success', () async {
        when(() => mockDio.get<dynamic>(any())).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await repository.logout();

        verify(() => mockDio.get<dynamic>(any())).called(1);
      });

      test('handles unexpected status code without throwing', () async {
        when(() => mockDio.get<dynamic>(any())).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await repository.logout();

        verify(() => mockDio.get<dynamic>(any())).called(1);
      });

      test('handles DioException without throwing', () async {
        when(
          () => mockDio.get<dynamic>(any()),
        ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        await repository.logout();

        verify(() => mockDio.get<dynamic>(any())).called(1);
      });

      test('handles unexpected error without throwing', () async {
        when(() => mockDio.get<dynamic>(any())).thenThrow(Exception());

        await repository.logout();

        verify(() => mockDio.get<dynamic>(any())).called(1);
      });
    });

    group('refreshToken', () {
      test('returns AuthToken on success', () async {
        final responseData = {'access_token': 'new_token'};
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
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

      test('throws ServerException when response data is invalid', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        expect(
          () => repository.refreshToken(),
          throwsA(isA<ServerException>()),
        );
      });

      test('throws Handled Exception on DioException', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.receiveTimeout,
          ),
        );

        expect(
          () => repository.refreshToken(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws AuthException on unexpected error', () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('unexpected'));

        expect(() => repository.refreshToken(), throwsA(isA<AuthException>()));
      });
    });
  });
}
