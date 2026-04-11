import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:gatuno/core/network/interceptors/auth_interceptor.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';

class MockDioClient extends Mock implements DioClient {}

class MockAuthService extends Mock implements AuthService {}

class MockDio extends Mock implements Dio {}

class MockInterceptors extends Mock implements Interceptors {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeInterceptor extends Fake implements Interceptor {}

class FakeResponse extends Fake implements Response<dynamic> {}

class FakeDioException extends Fake implements DioException {}

void main() {
  late DioClient dioClient;
  late AuthService authService;
  late Dio dio;
  late Interceptors interceptors;
  late MockRequestInterceptorHandler requestHandler;
  late MockErrorInterceptorHandler errorHandler;
  const testBaseUrl = 'https://api.gatuno.com/api';

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeInterceptor());
    registerFallbackValue(FakeResponse());
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '/')),
    );
  });

  setUp(() {
    dioClient = MockDioClient();
    authService = MockAuthService();
    dio = MockDio();
    interceptors = MockInterceptors();
    requestHandler = MockRequestInterceptorHandler();
    errorHandler = MockErrorInterceptorHandler();

    when(() => dioClient.dio).thenReturn(dio);
    when(() => dio.interceptors).thenReturn(interceptors);
  });

  AuthInterceptor getInterceptor() {
    return AuthInterceptor(dioClient: dioClient, authService: authService);
  }

  group('onRequest', () {
    test(
      'should NOT add Authorization header when token is empty string',
      () async {
        final options = RequestOptions(path: '/test', baseUrl: testBaseUrl);
        when(() => authService.getAccessToken()).thenAnswer((_) async => '');
        when(() => requestHandler.next(any())).thenAnswer((_) {});

        getInterceptor().onRequest(options, requestHandler);

        await Future<void>.delayed(Duration.zero);
        expect(options.headers['Authorization'], isNull);
      },
    );

    test('should add Authorization header when token is valid', () async {
      final options = RequestOptions(path: '/test', baseUrl: testBaseUrl);

      // Create a non-expired valid-looking token (3 parts)
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
      final payload = base64Url
          .encode(utf8.encode('{"exp": $exp}'))
          .replaceAll('=', '');
      final token = 'header.$payload.signature';

      when(() => authService.getAccessToken()).thenAnswer((_) async => token);
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onRequest(options, requestHandler);

      await Future<void>.delayed(Duration.zero);
      expect(options.headers['Authorization'], 'Bearer $token');
      // Should NOT call performTokenRefresh because it's not near expiry
      verifyNever(() => authService.performTokenRefresh());
    });

    test('should NOT add Authorization header for external URLs', () async {
      final options = RequestOptions(
        path: 'https://other-api.com/data',
        baseUrl: testBaseUrl,
      );
      when(() => authService.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onRequest(options, requestHandler);

      await Future<void>.delayed(Duration.zero);
      expect(options.headers['Authorization'], isNull);
    });

    test(
      'should NOT add Authorization header for excluded paths (signin)',
      () async {
        final options = RequestOptions(
          path: '/auth/signin',
          baseUrl: testBaseUrl,
        );
        when(
          () => authService.getAccessToken(),
        ).thenAnswer((_) async => 'token');
        when(() => requestHandler.next(any())).thenAnswer((_) {});

        getInterceptor().onRequest(options, requestHandler);

        await Future<void>.delayed(Duration.zero);
        expect(options.headers['Authorization'], isNull);
      },
    );

    test('should trigger eager refresh when token is near expiry', () async {
      final options = RequestOptions(path: '/test', baseUrl: testBaseUrl);

      // Create a token that expires in 1 minute (within the 2-minute threshold)
      final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60;
      final payload = base64Url
          .encode(utf8.encode('{"exp": $exp}'))
          .replaceAll('=', '');
      final token = 'header.$payload.signature';

      when(() => authService.getAccessToken()).thenAnswer((_) async => token);
      when(() => authService.performTokenRefresh()).thenAnswer((_) async {});
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onRequest(options, requestHandler);

      await Future<void>.delayed(Duration.zero);
      expect(options.headers['Authorization'], 'Bearer $token');
      // Should call performTokenRefresh in the background
      verify(() => authService.performTokenRefresh()).called(1);
    });
  });

  group('onError', () {
    test(
      'should retry request if token was refreshed by another request',
      () async {
        final options = RequestOptions(
          path: '/test',
          baseUrl: testBaseUrl,
          headers: {'Authorization': 'Bearer old_token'},
        );
        final error = DioException(
          requestOptions: options,
          response: Response<dynamic>(requestOptions: options, statusCode: 401),
        );

        when(
          () => authService.getAccessToken(),
        ).thenAnswer((_) async => 'new_token');

        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
        );
        when(() => dio.fetch<dynamic>(any())).thenAnswer((_) async => response);
        when(() => errorHandler.resolve(any())).thenAnswer((_) {});

        getInterceptor().onError(error, errorHandler);

        await Future<void>.delayed(Duration.zero);
        verify(() => dio.fetch<dynamic>(options)).called(1);
        verify(() => errorHandler.resolve(response)).called(1);
      },
    );

    test('should NOT perform refresh for external URL 401', () async {
      final options = RequestOptions(
        path: 'https://other-api.com/data',
        baseUrl: testBaseUrl,
        headers: {'Authorization': 'Bearer some_token'},
      );
      final error = DioException(
        requestOptions: options,
        response: Response<dynamic>(requestOptions: options, statusCode: 401),
      );

      when(() => errorHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onError(error, errorHandler);

      await Future<void>.delayed(Duration.zero);
      verifyNever(() => authService.performTokenRefresh());
      verify(() => errorHandler.next(error)).called(1);
    });

    test('should perform refresh and retry if token is the same', () async {
      final options = RequestOptions(
        path: '/test',
        baseUrl: testBaseUrl,
        headers: {'Authorization': 'Bearer old_token'},
      );
      final error = DioException(
        requestOptions: options,
        response: Response<dynamic>(requestOptions: options, statusCode: 401),
      );

      when(
        () => authService.getAccessToken(),
      ).thenAnswer((_) async => 'old_token');
      when(() => authService.performTokenRefresh()).thenAnswer((_) async {});

      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
      );
      when(() => dio.fetch<dynamic>(any())).thenAnswer((_) async => response);
      when(() => errorHandler.resolve(any())).thenAnswer((_) {});

      getInterceptor().onError(error, errorHandler);

      await Future<void>.delayed(Duration.zero);
      verify(() => authService.performTokenRefresh()).called(1);
      verify(() => dio.fetch<dynamic>(options)).called(1);
      verify(() => errorHandler.resolve(response)).called(1);
    });

    test('should forward refresh error when refresh fails', () async {
      final options = RequestOptions(
        path: '/test',
        baseUrl: testBaseUrl,
        headers: {'Authorization': 'Bearer old_token'},
      );
      final error = DioException(
        requestOptions: options,
        response: Response<dynamic>(requestOptions: options, statusCode: 401),
      );

      final refreshError = DioException(
        requestOptions: RequestOptions(path: '/refresh'),
        message: 'Refresh failed',
        type: DioExceptionType.badResponse,
      );

      when(
        () => authService.getAccessToken(),
      ).thenAnswer((_) async => 'old_token');
      when(() => authService.performTokenRefresh()).thenThrow(refreshError);
      when(() => errorHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onError(error, errorHandler);

      await Future<void>.delayed(Duration.zero);

      final captured =
          verify(() => errorHandler.next(captureAny())).captured.first
              as DioException;
      expect(captured.message, contains('Refresh failed'));
    });
  });
}
