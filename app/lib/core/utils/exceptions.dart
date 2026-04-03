import '../exceptions/exceptions.dart';

class InvalidJwtException extends AppExceptions {
  InvalidJwtException({String? message})
    : super(message ?? 'Invalid JWT token');
}
