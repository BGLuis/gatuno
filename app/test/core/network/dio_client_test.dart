import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    test('provides a Dio instance', () {
      final client = DioClient();
      expect(client.dio, isA<Dio>());
    });
  });
}
