import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:gatuno/core/network/interceptors/logging_interceptor.dart';
import 'package:gatuno/core/network/interceptors/cache_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockX509Certificate extends Mock implements X509Certificate {}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('DioClient', () {
    test('provides a Dio instance with correct base options', () {
      final client = DioClient(baseUrl: 'https://api.test.com');
      expect(client.dio, isA<Dio>());
      expect(client.dio.options.baseUrl, 'https://api.test.com');
      expect(client.dio.options.contentType, 'application/json');
    });

    test(
      'configures IOHttpClientAdapter with correct badCertificateCallback',
      () {
        const baseUrl = 'https://api.test.com/api';
        final mockHttpClient = MockHttpClient();

        // DioClient will call _setupCertificatePinning which sets httpClientAdapter
        final client = DioClient(baseUrl: baseUrl, httpClient: mockHttpClient);

        final adapter = client.dio.httpClientAdapter as IOHttpClientAdapter;

        // Capturing the callback
        final httpClient = adapter.createHttpClient!();
        expect(httpClient, mockHttpClient);

        final cert = MockX509Certificate();

        // Access the callback that was set on the mock
        final capturedCallback =
            verify(
                  () => mockHttpClient.badCertificateCallback = captureAny(),
                ).captured.single
                as bool Function(X509Certificate, String, int);

        // Should allow matching host
        expect(capturedCallback(cert, 'api.test.com', 443), isTrue);

        // Should deny different host
        expect(capturedCallback(cert, 'malicious.com', 443), isFalse);
      },
    );

    test('setupLoggingInterceptor adds LoggingInterceptor', () {
      final client = DioClient();
      setupLoggingInterceptor(client);

      final loggingInterceptors = client.dio.interceptors
          .whereType<LoggingInterceptor>();
      expect(loggingInterceptors, isNotEmpty);
    });

    test('setupCacheInterceptor adds DioCacheInterceptor', () async {
      final client = DioClient();
      // Use a MemCacheStore for testing to avoid disk I/O
      await setupCacheInterceptor(client, store: MemCacheStore());

      final cacheInterceptors = client.dio.interceptors
          .whereType<DioCacheInterceptor>();
      expect(cacheInterceptors, isNotEmpty);
    });
  });
}
