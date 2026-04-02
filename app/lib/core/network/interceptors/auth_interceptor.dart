import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../api_constants.dart';
import '../../../features/authentication/domain/use_cases/auth_service.dart';

class AuthInterceptor extends Interceptor {
  final DioClient dioClient;
  final AuthService authService;
  Future<void>? _refreshFuture;

  AuthInterceptor({required this.dioClient, required this.authService});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Don't add auth header to the refresh token endpoint itself
    if (options.path != ApiConstants.refreshToken) {
      final token = await authService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiConstants.refreshToken) {
      final currentToken = await authService.getAccessToken();
      final authHeader = err.requestOptions.headers['Authorization']
          ?.toString();
      final requestToken = authHeader?.replaceFirst('Bearer ', '');

      // If we have a new token already (refreshed by another concurrent request),
      // just retry the original request.
      if (currentToken != null && currentToken != requestToken) {
        try {
          final response = await dioClient.dio.fetch<dynamic>(
            err.requestOptions,
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }

      try {
        // Handle concurrent refresh requests
        _refreshFuture ??= authService.performTokenRefresh();
        await _refreshFuture;
        _refreshFuture = null;

        // Retry the original request with the new token
        final options = err.requestOptions;

        // Fetch original request again.
        // The onRequest will be called again and will add the new token.
        final response = await dioClient.dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } catch (e) {
        _refreshFuture = null;
        // If refresh fails, the AuthService.performTokenRefresh already handles logout.
        // We forward the refresh failure (if it's a DioException) or a new DioException wrapping the error,
        // so callers can see the real reason why refresh failed.
        final forwardError = e is DioException
            ? e
            : DioException(
                requestOptions: err.requestOptions,
                error: e,
                type: DioExceptionType.unknown,
                message: 'Token refresh failed: $e',
              );
        return handler.next(forwardError);
      }
    }
    return handler.next(err);
  }
}

void setupAuthInterceptor(DioClient dioClient, AuthService authService) {
  dioClient.dio.interceptors.add(
    AuthInterceptor(dioClient: dioClient, authService: authService),
  );
}
