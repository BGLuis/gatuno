import 'package:dio/dio.dart';
import '../../features/authentication/exceptions/exceptions.dart';
import '../exceptions/exceptions.dart';

export '../../features/authentication/exceptions/exceptions.dart';
export '../exceptions/exceptions.dart';

class NetworkException extends AppExceptions {
  NetworkException({String? message})
    : super(message ?? 'No internet connection or server unreachable');
}

class ValidationException extends AppExceptions {
  final Map<String, dynamic>? errors;
  ValidationException({String? message, this.errors})
    : super(message ?? 'Validation failed', statusCode: 400);
}

class ServerException extends AppExceptions {
  ServerException({String? message, int? statusCode})
    : super(message ?? 'Internal server error', statusCode: statusCode ?? 500);
}

class ApiExceptionHandler {
  static AppExceptions handle(DioException error) {
    final dynamic responseData = error.response?.data;
    String? message;

    if (responseData is Map) {
      message = responseData['message']?.toString();
    }

    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          errors: responseData is Map
              ? responseData['errors'] as Map<String, dynamic>?
              : null,
        );
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return AuthException('Access denied: ${message ?? ''}');
      case 404:
        return AuthException('Resource not found');
      case 500:
        return ServerException(message: message, statusCode: 500);
      default:
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return NetworkException();
        }
        return AuthException(
          message ?? error.message ?? 'An unexpected error occurred',
        );
    }
  }
}
