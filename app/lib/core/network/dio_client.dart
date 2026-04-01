import 'package:dio/dio.dart';
import '../../features/authentication/data/data_sources/auth_local_data_source.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;
  final AuthStorage _authStorage = AuthStorage();

  DioClient({String baseUrl = ApiConstants.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            // TODO: Implement refresh token logic here if needed
          }
          return handler.next(e);
        },
      ),
    );
  }
}
