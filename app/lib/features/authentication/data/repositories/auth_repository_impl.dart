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
    final redactedEmail = AppLogger.redactEmail(email);
    AppLogger.i('SignIn attempt for: $redactedEmail', _logTag);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.signIn,
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        AppLogger.i('SignIn success for: $redactedEmail', _logTag);
        return AuthResponse.fromJson(data);
      } else {
        AppLogger.e(
          'SignIn failed: Invalid response format for $redactedEmail',
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
        'SignIn DioException for $redactedEmail: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } on AppExceptions {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignIn unexpected error for $redactedEmail',
        e,
        stackTrace,
        _logTag,
      );
      throw AuthException('An unexpected error occurred during signIn');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    final redactedEmail = AppLogger.redactEmail(email);
    AppLogger.i('SignUp attempt for: $redactedEmail', _logTag);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.signUp,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppLogger.e(
          'SignUp failed for $redactedEmail: ${response.statusMessage}',
          null,
          null,
          _logTag,
        );
        throw ServerException(
          message: 'Signup failed: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
      AppLogger.i('SignUp success for: $redactedEmail', _logTag);
    } on DioException catch (e) {
      AppLogger.e(
        'SignUp DioException for $redactedEmail: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } on AppExceptions {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.e(
        'SignUp unexpected error for $redactedEmail',
        e,
        stackTrace,
        _logTag,
      );
      throw AuthException('An unexpected error occurred during signup');
    }
  }

  @override
  Future<void> logout(String? refreshToken) async {
    AppLogger.i('Logout attempt in repository', _logTag);
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.logout,
        options: Options(
          headers: refreshToken != null
              ? {'Cookie': 'refreshToken=$refreshToken'}
              : null,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppLogger.w(
          'Logout returned unexpected status: ${response.statusCode}',
          _logTag,
        );
      } else {
        AppLogger.i('Logout successful in backend', _logTag);
      }
    } on DioException catch (e) {
      // If logout fails on backend (e.g. token expired), we still want to log it
      // but the service will still clear local tokens
      AppLogger.w('Logout backend call failed: ${e.message}', _logTag);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected error during logout backend call',
        e,
        stackTrace,
        _logTag,
      );
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    AppLogger.i('Token refresh attempt', _logTag);
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        options: Options(headers: {'Cookie': 'refreshToken=$refreshToken'}),
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
