import 'package:flutter/foundation.dart';
import '../../domain/use_cases/user_service.dart';
import '../../data/models/user_model.dart';
import '../../../../core/logging/logger.dart';

class MeViewModel extends ChangeNotifier {
  final UserService _userService;
  static const String _logTag = 'MeViewModel';

  UserModel? _user;
  bool _isSensitiveContentEnabled = false;
  bool _isLoading = true;

  MeViewModel(this._userService);

  UserModel? get user => _user;
  bool get isSensitiveContentEnabled => _isSensitiveContentEnabled;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    AppLogger.i('Initializing MeViewModel', _logTag);
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.getCurrentUser();
      _isSensitiveContentEnabled = await _userService
          .isSensitiveContentEnabled();
      AppLogger.i(
        'MeViewModel initialized: user=${_user?.displayName}, sensitive=$_isSensitiveContentEnabled',
        _logTag,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error initializing MeViewModel', e, stackTrace, _logTag);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSensitiveContent(bool value) async {
    AppLogger.i('Toggling sensitive content to: $value', _logTag);
    try {
      await _userService.setSensitiveContentEnabled(value);
      _isSensitiveContentEnabled = value;
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.e('Error toggling sensitive content', e, stackTrace, _logTag);
    }
  }

  Future<void> logout() async {
    AppLogger.i('User requested logout from MeViewModel', _logTag);
    await _userService.logout();
  }
}
