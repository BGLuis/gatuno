import 'package:flutter/foundation.dart';
import '../../domain/use_cases/auth_service.dart';
import '../../../../core/logging/logger.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;
  static const String _logTag = 'SignUpViewModel';

  bool _isLoading = false;
  String? _errorMessage;

  SignUpViewModel(this._authService);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp(String email, String password) async {
    AppLogger.i('SignUp requested for: $email', _logTag);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.signUp(email, password);
      _isLoading = false;
      AppLogger.i('SignUp result for $email: $success', _logTag);
      notifyListeners();
      return success;
    } catch (e, stackTrace) {
      _isLoading = false;
      _errorMessage = e.toString();
      AppLogger.e(
        'SignUp error for $email: $_errorMessage',
        e,
        stackTrace,
        _logTag,
      );
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    AppLogger.d('Clearing SignUp error', _logTag);
    _errorMessage = null;
    notifyListeners();
  }
}
