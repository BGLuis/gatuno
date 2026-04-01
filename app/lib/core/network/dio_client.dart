import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient({String baseUrl = ApiConstants.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
      ),
    );
  }
}
