import 'package:flutter/foundation.dart';
import '../../domain/use_cases/auth_service.dart';
import '../../../../core/logging/logger.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService;
  static const String _logTag = 'SignInViewModel';

  bool _isLoading = false;
  String? _errorMessage;

  SignInViewModel(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    final redactedEmail = AppLogger.redactEmail(email);
    AppLogger.i('SignIn requested for: $redactedEmail', _logTag);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.signIn(email, password);
      _isLoading = false;
      AppLogger.i('SignIn result for $redactedEmail: $success', _logTag);
      notifyListeners();
      return success;
    } catch (e, stackTrace) {
      _isLoading = false;
      _errorMessage = e.toString();
      AppLogger.e(
        'SignIn error for $redactedEmail: $_errorMessage',
        e,
        stackTrace,
        _logTag,
      );
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    AppLogger.d('Clearing SignIn error', _logTag);
    _errorMessage = null;
    notifyListeners();
  }
}
