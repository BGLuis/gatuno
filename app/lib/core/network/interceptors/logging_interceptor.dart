import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../logging/logger.dart';
import '../dio_client.dart';

class LoggingInterceptor extends Interceptor {
  static const String _tag = 'Dio';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i('--> ${options.method} ${options.uri}', _tag);
    if (kDebugMode) {
      if (options.headers.isNotEmpty) {
        AppLogger.d('Headers: ${options.headers}', _tag);
      }
      if (options.data != null) {
        AppLogger.d('Body: ${jsonEncode(options.data)}', _tag);
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.i(
      '<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
      _tag,
    );
    if (kDebugMode) {
      AppLogger.d('Headers: ${response.headers}', _tag);
      if (response.data != null) {
        AppLogger.d(jsonEncode(response.data), _tag);
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '<-- Error ${err.response?.statusCode ?? 'Unknown'} ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.error,
      err.stackTrace,
      _tag,
    );
    if (kDebugMode && err.response != null) {
      if (err.response?.headers != null) {
        AppLogger.d('Headers: ${err.response?.headers}', _tag);
      }
      if (err.response?.data != null) {
        AppLogger.e(jsonEncode(err.response?.data), err, err.stackTrace, _tag);
      }
    }
    return super.onError(err, handler);
  }
}

void setupLoggingInterceptor(DioClient dioClient) {
  dioClient.dio.interceptors.add(LoggingInterceptor());
}
