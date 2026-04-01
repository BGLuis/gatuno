import '../repositories/auth_repository.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../../../core/logging/logger.dart';

class AuthService {
  final AuthRepository _authRepository;
  final AuthStorage _authStorage;
  static const String _logTag = 'AuthService';

  AuthService(this._authRepository, this._authStorage);

  Future<bool> signIn(String email, String password) async {
    AppLogger.i('Performing signIn for: $email', _logTag);
    try {
      final response = await _authRepository.signIn(email, password);

      await _authStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      AppLogger.i('SignIn completed and tokens saved for: $email', _logTag);
      return true;
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignIn failed in AuthService for: $email',
        e,
        stackTrace,
        _logTag,
      );
      rethrow;
    }
  }

  Future<bool> signUp(String email, String password) async {
    AppLogger.i('Performing signUp for: $email', _logTag);
    try {
      await _authRepository.signUp(email, password);
      AppLogger.i(
        'SignUp success, performing auto-signIn for: $email',
        _logTag,
      );
      // Auto-signIn after successful signup
      return signIn(email, password);
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignUp failed in AuthService for: $email',
        e,
        stackTrace,
        _logTag,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    AppLogger.i('Performing logout', _logTag);
    await _authStorage.clearTokens();
    AppLogger.i('Tokens cleared successfully', _logTag);
  }

  Future<String?> getAccessToken() async {
    return _authStorage.getAccessToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _authStorage.getAccessToken();
    final authenticated = token != null && token.isNotEmpty;
    AppLogger.d('Auth check: authenticated = $authenticated', _logTag);
    return authenticated;
  }

  Future<void> performTokenRefresh() async {
    AppLogger.i('Performing token refresh', _logTag);
    final refreshToken = await _authStorage.getRefreshToken();
    if (refreshToken == null) {
      AppLogger.w('Token refresh aborted: No refresh token available', _logTag);
      throw Exception('No refresh token available');
    }

    try {
      final response = await _authRepository.refreshToken(refreshToken);
      await _authStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      AppLogger.i('Token refresh success', _logTag);
    } catch (e, stackTrace) {
      AppLogger.e('Token refresh failed, logging out', e, stackTrace, _logTag);
      await logout();
      rethrow;
    }
  }
}
