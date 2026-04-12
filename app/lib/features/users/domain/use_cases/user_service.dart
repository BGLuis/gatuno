import '../../../../core/utils/jwt_decoder.dart';
import '../../../authentication/domain/use_cases/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../../../core/logging/logger.dart';

class UserService {
  final AuthService _authService;
  static const String _logTag = 'UserService';

  UserService(this._authService);

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _authService.getToken();
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

  Future<void> logout() async {
    await _authService.logout();
  }
}
