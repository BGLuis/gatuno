import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/jwt_decoder.dart';
import '../../../users/data/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthStorage _authStorage;
  static const String _logTag = 'AuthService';

  bool _isInitialized = false;
  bool _isAuthenticated = false;
  String? _token;

  AuthService(this._authRepository, this._authStorage) {
    _initAuth();
  }

  bool get isInitialized => _isInitialized;
  bool get authenticated => _isAuthenticated;

  UserModel? get currentUser {
    if (_token == null || _token!.isEmpty) return null;
    try {
      if (JwtDecoder.isExpired(_token!)) return null;
      final payload = JwtDecoder.decode(_token!);
      return UserModel.fromJwt(payload);
    } catch (e) {
      return null;
    }
  }

  Future<void>? _refreshFuture;

  Future<void> _initAuth() async {
    _token = await _authStorage.getToken();
    if (_token != null && _token!.isNotEmpty) {
      if (JwtDecoder.isExpired(_token!)) {
        AppLogger.i('Stored token is expired, attempting refresh', _logTag);
        try {
          await performTokenRefresh();
          return;
        } catch (e) {
          AppLogger.w('Initial token refresh failed: $e', _logTag);
          _isAuthenticated = false;
        }
      } else {
        _isAuthenticated = true;
      }
    } else {
      _isAuthenticated = false;
    }
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

      _token = response.token;
      await _authStorage.saveToken(_token!);

      AppLogger.i(
        'SignIn completed and token saved for: $redactedEmail',
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
      // Call backend logout
      await _authRepository.logout();
    } catch (e) {
      // We log but still clear tokens locally
      AppLogger.w(
        'Backend logout failed, clearing local tokens anyway: $e',
        _logTag,
      );
    }
    await _authStorage.clearToken();
    _token = null;
    _isAuthenticated = false;
    AppLogger.i('Tokens cleared successfully', _logTag);
    notifyListeners();
  }

  Future<String?> getToken() async {
    return _authStorage.getToken();
  }

  Future<bool> isAuthenticated() async {
    _token = await _authStorage.getToken();
    bool authenticated = _token != null && _token!.isNotEmpty;

    if (authenticated && JwtDecoder.isExpired(_token!)) {
      AppLogger.i('Token expired in isAuthenticated check', _logTag);
      try {
        await performTokenRefresh();
        return true;
      } catch (e) {
        authenticated = false;
      }
    }

    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      notifyListeners();
    }

    _isInitialized = true;
    return _isAuthenticated;
  }

  Future<void> performTokenRefresh() async {
    if (_refreshFuture != null) {
      AppLogger.d(
        'Refresh already in progress, waiting for existing future',
        _logTag,
      );
      return _refreshFuture;
    }

    _refreshFuture = _performTokenRefreshInternal();
    try {
      await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<void> _performTokenRefreshInternal() async {
    AppLogger.i('Performing token refresh', _logTag);
    try {
      final response = await _authRepository.refreshToken();
      _token = response.token;
      await _authStorage.saveToken(_token!);
      _isAuthenticated = true;
      _isInitialized = true;
      AppLogger.i('Token refresh success', _logTag);
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e('Token refresh failed, logging out', e, stackTrace, _logTag);
      await logout();
      rethrow;
    }
  }
}
