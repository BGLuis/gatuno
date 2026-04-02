import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../../../core/logging/logger.dart';

class AuthService extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthStorage _authStorage;
  static const String _logTag = 'AuthService';

  bool _isInitialized = false;
  bool _isAuthenticated = false;

  AuthService(this._authRepository, this._authStorage) {
    _initAuth();
  }

  bool get isInitialized => _isInitialized;
  bool get authenticated => _isAuthenticated;

  Future<void> _initAuth() async {
    final token = await _authStorage.getAccessToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    _isInitialized = true;
    AppLogger.d(
      'AuthService initialized: authenticated = $_isAuthenticated',
      _logTag,
    );
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    final redactedEmail = AppLogger.redactEmail(email);
    AppLogger.i('Performing signIn for: $redactedEmail', _logTag);
    try {
      final response = await _authRepository.signIn(email, password);

      await _authStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      AppLogger.i(
        'SignIn completed and tokens saved for: $redactedEmail',
        _logTag,
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignIn failed in AuthService for: $redactedEmail',
        e,
        stackTrace,
        _logTag,
      );
      rethrow;
    }
  }

  Future<bool> signUp(String email, String password) async {
    final redactedEmail = AppLogger.redactEmail(email);
    AppLogger.i('Performing signUp for: $redactedEmail', _logTag);
    try {
      await _authRepository.signUp(email, password);
      AppLogger.i(
        'SignUp success, performing auto-signIn for: $redactedEmail',
        _logTag,
      );
      // Auto-signIn after successful signup
      return signIn(email, password);
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignUp failed in AuthService for: $redactedEmail',
        e,
        stackTrace,
        _logTag,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    AppLogger.i('Performing logout', _logTag);
    try {
      // Call backend logout if possible
      await _authRepository.logout();
    } catch (e) {
      // We log but still clear tokens locally
      AppLogger.w(
        'Backend logout failed, clearing local tokens anyway: $e',
        _logTag,
      );
    }
    await _authStorage.clearTokens();
    _isAuthenticated = false;
    AppLogger.i('Tokens cleared successfully', _logTag);
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    return _authStorage.getAccessToken();
  }

  Future<bool> isAuthenticated() async {
    final token = await _authStorage.getAccessToken();
    final authenticated = token != null && token.isNotEmpty;

    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      notifyListeners();
    }

    _isInitialized = true;
    return _isAuthenticated;
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
      _isAuthenticated = true;
      AppLogger.i('Token refresh success', _logTag);
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e('Token refresh failed, logging out', e, stackTrace, _logTag);
      await logout();
      rethrow;
    }
  }
}
