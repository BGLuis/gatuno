import '../../../../core/network/exceptions.dart';
import '../../domain/entities/auth_tokens.dart';

class AuthResponse extends AuthTokens {
  AuthResponse({required super.accessToken, required super.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] ?? json['accessToken'];
    final refreshToken = json['refresh_token'] ?? json['refreshToken'];

    if (accessToken == null || accessToken is! String) {
      throw ValidationException(
        message: 'Invalid or missing access_token in response',
      );
    }
    if (refreshToken == null || refreshToken is! String) {
      throw ValidationException(
        message: 'Invalid or missing refresh_token in response',
      );
    }

    return AuthResponse(accessToken: accessToken, refreshToken: refreshToken);
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }
}
