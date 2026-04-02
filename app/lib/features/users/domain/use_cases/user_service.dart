import '../../../../core/utils/jwt_decoder.dart';
import '../../../authentication/domain/use_cases/auth_service.dart';
import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/user_model.dart';
import '../../../../core/logging/logger.dart';

class UserService {
  final AuthService _authService;
  final UserStorage _userStorage;
  static const String _logTag = 'UserService';

  UserService(this._authService, this._userStorage);

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      if (JwtDecoder.isExpired(token)) {
        AppLogger.w('Access token expired while getting current user', _logTag);
        return null;
      }

      final payload = JwtDecoder.decode(token);
      return UserModel.fromJwt(payload);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Error getting current user from JWT',
        e,
        stackTrace,
        _logTag,
      );
      return null;
    }
  }

  Future<void> setSensitiveContentEnabled(bool enabled) async {
    AppLogger.i('Setting sensitive content enabled: $enabled', _logTag);
    await _userStorage.setSensitiveContentEnabled(enabled);
  }

  Future<bool> isSensitiveContentEnabled() async {
    return await _userStorage.isSensitiveContentEnabled();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
