import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../../../features/authentication/domain/use_cases/auth_service.dart';

void setupAuthInterceptor(DioClient dioClient, AuthService authService) {
  dioClient.dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await authService.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // TODO: Implement refresh token logic using authService
        }
        return handler.next(e);
      },
    ),
  );
}
