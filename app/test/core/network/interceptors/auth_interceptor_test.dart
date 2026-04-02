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
        final options = RequestOptions(path: '/test');
        when(() => authService.getAccessToken()).thenAnswer((_) async => '');
        when(() => requestHandler.next(any())).thenAnswer((_) {});

        getInterceptor().onRequest(options, requestHandler);

        await Future<void>.delayed(Duration.zero);
        expect(options.headers['Authorization'], isNull);
      },
    );

    test('should add Authorization header when token is valid', () async {
      final options = RequestOptions(path: '/test');
      when(
        () => authService.getAccessToken(),
      ).thenAnswer((_) async => 'valid_token');
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      getInterceptor().onRequest(options, requestHandler);

      await Future<void>.delayed(Duration.zero);
      expect(options.headers['Authorization'], 'Bearer valid_token');
    });
  });

  group('onError', () {
    test(
      'should retry request if token was refreshed by another request',
      () async {
        final options = RequestOptions(
          path: '/test',
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

    test('should perform refresh and retry if token is the same', () async {
      final options = RequestOptions(
        path: '/test',
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
