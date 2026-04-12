import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<AuthToken> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<AuthToken> refreshToken();
  Future<void> logout();
}
