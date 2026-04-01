import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/exceptions.dart';

void main() {
  group('ApiExceptionHandler', () {
    test('handles 400 ValidationException', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
          data: {
            'message': 'Invalid input',
            'errors': {'email': 'invalid'},
          },
        ),
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<ValidationException>());
      expect(result.message, 'Invalid input');
      expect((result as ValidationException).errors?['email'], 'invalid');
    });

    test('handles 401 UnauthorizedException', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Unauthorized'},
        ),
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<UnauthorizedException>());
      expect(result.message, 'Unauthorized');
    });

    test('handles 403 Forbidden', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Forbidden'},
        ),
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<AuthException>());
      expect(result.message, contains('Access denied'));
    });

    test('handles 404 Not Found', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<AuthException>());
      expect(result.message, contains('Resource not found'));
    });

    test('handles 500 ServerException', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Internal error'},
        ),
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<ServerException>());
      expect(result.message, 'Internal error');
    });

    test('handles network timeouts', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<NetworkException>());
    });

    test('handles unknown errors', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        message: 'Unknown error',
      );

      final result = ApiExceptionHandler.handle(error);

      expect(result, isA<AuthException>());
      expect(result.message, 'Unknown error');
    });
  });
}
