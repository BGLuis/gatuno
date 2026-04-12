import '../../../../core/network/exceptions.dart';
import '../../domain/entities/auth_token.dart';

class AuthResponse extends AuthToken {
  AuthResponse({required super.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final token = json['access_token'] ?? json['accessToken'];

    if (token == null || token is! String) {
      throw ValidationException(
        message: 'Invalid or missing access_token in response',
      );
    }

    return AuthResponse(token: token);
  }

  Map<String, dynamic> toJson() {
    return {'access_token': token};
  }
}
