import 'dart:async';
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

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeInterceptor extends Fake implements Interceptor {}

void main() {
  late DioClient dioClient;
  late AuthService authService;
  late Dio dio;
  late Interceptors interceptors;
  late MockRequestInterceptorHandler handler;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeInterceptor());
  });

  setUp(() {
    dioClient = MockDioClient();
    authService = MockAuthService();
    dio = MockDio();
    interceptors = MockInterceptors();
    handler = MockRequestInterceptorHandler();

    when(() => dioClient.dio).thenReturn(dio);
    when(() => dio.interceptors).thenReturn(interceptors);
  });

  test(
    'should NOT add Authorization header when token is empty string',
    () async {
      // Arrange
      final options = RequestOptions(path: '/test');
      final completer = Completer<void>();

      late Interceptor authInterceptor;
      when(() => interceptors.add(any())).thenAnswer((invocation) {
        authInterceptor = invocation.positionalArguments[0] as Interceptor;
      });

      setupAuthInterceptor(dioClient, authService);

      when(() => authService.getAccessToken()).thenAnswer((_) async => '');
      when(() => handler.next(any())).thenAnswer((_) => completer.complete());

      // Act
      authInterceptor.onRequest(options, handler);
      await completer.future;

      // Assert
      expect(options.headers['Authorization'], isNull);
    },
  );

  test('should add Authorization header when token is valid', () async {
    // Arrange
    final options = RequestOptions(path: '/test');
    final completer = Completer<void>();

    late Interceptor authInterceptor;
    when(() => interceptors.add(any())).thenAnswer((invocation) {
      authInterceptor = invocation.positionalArguments[0] as Interceptor;
    });

    setupAuthInterceptor(dioClient, authService);

    when(
      () => authService.getAccessToken(),
    ).thenAnswer((_) async => 'valid_token');
    when(() => handler.next(any())).thenAnswer((_) => completer.complete());

    // Act
    authInterceptor.onRequest(options, handler);
    await completer.future;

    // Assert
    expect(options.headers['Authorization'], 'Bearer valid_token');
  });

  test('should NOT add Authorization header when token is null', () async {
    // Arrange
    final options = RequestOptions(path: '/test');
    final completer = Completer<void>();

    late Interceptor authInterceptor;
    when(() => interceptors.add(any())).thenAnswer((invocation) {
      authInterceptor = invocation.positionalArguments[0] as Interceptor;
    });

    setupAuthInterceptor(dioClient, authService);

    when(() => authService.getAccessToken()).thenAnswer((_) async => null);
    when(() => handler.next(any())).thenAnswer((_) => completer.complete());

    // Act
    authInterceptor.onRequest(options, handler);
    await completer.future;

    // Assert
    expect(options.headers['Authorization'], isNull);
  });
}
