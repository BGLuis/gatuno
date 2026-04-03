import '../../../core/exceptions/exceptions.dart';

class UnauthorizedException extends AppExceptions {
  UnauthorizedException({String? message})
    : super(message ?? 'Invalid credentials', statusCode: 401);
}

class AuthException extends AppExceptions {
  AuthException(super.message);
}
