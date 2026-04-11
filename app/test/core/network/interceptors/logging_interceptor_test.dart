import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/core/network/interceptors/logging_interceptor.dart';

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late LoggingInterceptor interceptor;
  late MockRequestInterceptorHandler requestHandler;
  late MockResponseInterceptorHandler responseHandler;
  late MockErrorInterceptorHandler errorHandler;

  setUp(() {
    interceptor = LoggingInterceptor();
    requestHandler = MockRequestInterceptorHandler();
    responseHandler = MockResponseInterceptorHandler();
    errorHandler = MockErrorInterceptorHandler();

    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(
      Response<dynamic>(requestOptions: RequestOptions(path: '')),
    );
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '')),
    );
  });

  group('LoggingInterceptor', () {
    test('onRequest calls handler.next', () {
      final options = RequestOptions(path: '/test', method: 'GET');
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      interceptor.onRequest(options, requestHandler);

      verify(() => requestHandler.next(options)).called(1);
    });

    test('onResponse calls handler.next', () {
      final options = RequestOptions(path: '/test');
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
      );
      when(() => responseHandler.next(any())).thenAnswer((_) {});

      interceptor.onResponse(response, responseHandler);

      verify(() => responseHandler.next(response)).called(1);
    });

    test('onError calls handler.next', () {
      final options = RequestOptions(path: '/test');
      final error = DioException(requestOptions: options);
      when(() => errorHandler.next(any())).thenAnswer((_) {});

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.next(error)).called(1);
    });

    test('onRequest logs with data and headers', () {
      final options = RequestOptions(
        path: '/test',
        method: 'POST',
        headers: {'test': 'header'},
        data: {'test': 'data'},
      );
      when(() => requestHandler.next(any())).thenAnswer((_) {});

      interceptor.onRequest(options, requestHandler);

      verify(() => requestHandler.next(options)).called(1);
    });

    test('onResponse logs with data', () {
      final options = RequestOptions(path: '/test');
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: {'test': 'data'},
      );
      when(() => responseHandler.next(any())).thenAnswer((_) {});

      interceptor.onResponse(response, responseHandler);

      verify(() => responseHandler.next(response)).called(1);
    });

    test('onError logs with response data', () {
      final options = RequestOptions(path: '/test');
      final error = DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 400,
          data: {'error': 'bad request'},
        ),
      );
      when(() => errorHandler.next(any())).thenAnswer((_) {});

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.next(error)).called(1);
    });
  });
}
