import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../api_constants.dart';
import '../../../features/authentication/domain/use_cases/auth_service.dart';
import '../../utils/jwt_decoder.dart';
import '../../logging/logger.dart';

class AuthInterceptor extends Interceptor {
  final DioClient dioClient;
  final AuthService authService;
  final List<String> _excludedPaths = [
    ApiConstants.signIn,
    ApiConstants.signUp,
    ApiConstants.refreshToken,
  ];

  AuthInterceptor({required this.dioClient, required this.authService});

  bool _shouldIntercept(RequestOptions options) {
    // 1. Check if the request is targeting the API origin
    if (options.baseUrl.isEmpty) return false;

    final baseUri = Uri.parse(options.baseUrl);
    final requestUri = options.uri;

    // Use a basic origin check (scheme, host, port) to identify API requests.
    // This prevents leaking tokens to third-party domains.
    final bool isApiOrigin =
        requestUri.scheme == baseUri.scheme &&
        requestUri.host == baseUri.host &&
        requestUri.port == baseUri.port;

    if (!isApiOrigin) return false;

    // 2. Check if the path is an auth endpoint that shouldn't have the token
    // Some auth endpoints (signin, signup) don't need the Authorization header.
    // The refresh token endpoint uses a cookie-based approach.
    final bool isExcluded = _excludedPaths.any(
      (path) => options.path == path || requestUri.path.endsWith(path),
    );

    return !isExcluded;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldIntercept(options)) {
      final token = await authService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';

        // Eager refresh if token expires in less than 2 minutes.
        // We don't wait for the result to not block the current request.
        if (JwtDecoder.isExpired(
          token,
          threshold: const Duration(minutes: 2),
        )) {
          authService.performTokenRefresh().catchError((Object e) {
            // Log error but don't fail the current request
            AppLogger.w(
              'Background token refresh failed: $e',
              'AuthInterceptor',
            );
          });
        }
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        _shouldIntercept(err.requestOptions)) {
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
        // Atomic refresh handled by AuthService
        await authService.performTokenRefresh();

        // Retry the original request with the new token
        final options = err.requestOptions;

        // Fetch original request again.
        // The onRequest will be called again and will add the new token.
        final response = await dioClient.dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } catch (e) {
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
