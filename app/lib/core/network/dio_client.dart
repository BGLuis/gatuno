import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient({String baseUrl = ApiConstants.baseUrl, HttpClient? httpClient}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        contentType: 'application/json',
        headers: const {'x-client-platform': 'mobile'},
      ),
    );

    _setupCertificatePinning(baseUrl, httpClient);
  }

  void _setupCertificatePinning(String baseUrl, HttpClient? httpClient) {
    // Support self-signed certificates for the configured API host
    final baseUri = Uri.parse(baseUrl);
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = httpClient ?? HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          return host == baseUri.host;
        };
        return client;
      },
    );
  }
}
