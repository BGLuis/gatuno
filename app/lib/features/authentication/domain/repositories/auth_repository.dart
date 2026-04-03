import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<AuthTokens> refreshToken(String refreshToken);
  Future<void> logout(String? refreshToken);
}
