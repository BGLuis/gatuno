import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_image.dart';
import 'package:gatuno/shared/components/atoms/app_loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/test_injection.dart';

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() async {
    mockDioClient = MockDioClient();
    mockDio = mockDioClient.dio as MockDio;

    await initTestDI(dioClient: mockDioClient);

    registerFallbackValue(RequestOptions(path: ''));
  });

  Widget createWidget(String url) {
    return MaterialApp(
      home: Scaffold(body: AppImage(imageUrl: url)),
    );
  }

  group('AppImage', () {
    testWidgets('shows loading indicator while fetching', (
      WidgetTester tester,
    ) async {
      when(
        () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
      ).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return Response<List<int>>(
          data: [1, 2, 3],
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
      });

      await tester.pumpWidget(createWidget('http://example.com/image.png'));

      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('shows error widget when fetch fails', (
      WidgetTester tester,
    ) async {
      when(
        () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      await tester.pumpWidget(createWidget('http://example.com/image.png'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('shows error widget when data is null', (
      WidgetTester tester,
    ) async {
      when(
        () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<List<int>>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await tester.pumpWidget(createWidget('http://example.com/image.png'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('renders Image.memory when fetch is successful', (
      WidgetTester tester,
    ) async {
      // Smallest valid 1x1 transparent PNG
      final transparentPng = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x06,
        0x00,
        0x00,
        0x00,
        0x1F,
        0x15,
        0xC4,
        0x89,
        0x00,
        0x00,
        0x00,
        0x0A,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9C,
        0x63,
        0x00,
        0x01,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0D,
        0x0A,
        0x2D,
        0xB4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ]);

      when(
        () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<List<int>>(
          data: transparentPng,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await tester.pumpWidget(createWidget('http://example.com/image.png'));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });
    group('AppImage didUpdateWidget', () {
      testWidgets('refetches when imageUrl changes', (
        WidgetTester tester,
      ) async {
        when(
          () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<List<int>>(
            data: [1, 2],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await tester.pumpWidget(createWidget('http://example.com/image1.png'));
        await tester.pumpAndSettle();

        verify(
          () => mockDio.get<List<int>>(
            'http://example.com/image1.png',
            options: any(named: 'options'),
          ),
        ).called(1);

        await tester.pumpWidget(createWidget('http://example.com/image2.png'));
        await tester.pump(); // Start fetching

        verify(
          () => mockDio.get<List<int>>(
            'http://example.com/image2.png',
            options: any(named: 'options'),
          ),
        ).called(1);
      });
    });
  });
}
