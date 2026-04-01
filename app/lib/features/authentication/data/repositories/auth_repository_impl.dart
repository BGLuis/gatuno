import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  static const String _logTag = 'AuthRepository';

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthTokens> signIn(String email, String password) async {
    AppLogger.i('SignIn attempt for: $email', _logTag);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.signIn,
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        AppLogger.i('SignIn success for: $email', _logTag);
        return AuthResponse.fromJson(data);
      } else {
        AppLogger.e(
          'SignIn failed: Invalid response format for $email',
          null,
          null,
          _logTag,
        );
        throw ServerException(
          message: 'SignIn failed: Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e(
        'SignIn DioException for $email: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } on AppExceptions {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e('SignIn unexpected error for $email', e, stackTrace, _logTag);
      throw AuthException('An unexpected error occurred during signIn');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    AppLogger.i('SignUp attempt for: $email', _logTag);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.signUp,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppLogger.e(
          'SignUp failed for $email: ${response.statusMessage}',
          null,
          null,
          _logTag,
        );
        throw ServerException(
          message: 'Signup failed: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
      AppLogger.i('SignUp success for: $email', _logTag);
    } on DioException catch (e) {
      AppLogger.e(
        'SignUp DioException for $email: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } on AppExceptions {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e('SignUp unexpected error for $email', e, stackTrace, _logTag);
      throw AuthException('An unexpected error occurred during signup');
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    AppLogger.i('Token refresh attempt', _logTag);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        AppLogger.i('Token refresh success', _logTag);
        return AuthResponse.fromJson(data);
      } else {
        AppLogger.e(
          'Token refresh failed: Invalid response format',
          null,
          null,
          _logTag,
        );
        throw ServerException(
          message: 'Refresh failed: Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e(
        'Token refresh DioException: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } on AppExceptions {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e('Token refresh unexpected error', e, stackTrace, _logTag);
      throw AuthException('An unexpected error occurred during token refresh');
    }
  }
}
