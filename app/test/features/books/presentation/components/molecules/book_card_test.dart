import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/book_type.dart';
import 'package:gatuno/features/books/presentation/components/molecules/book_card.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_cover.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_title.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../helpers/pump_app.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();

    when(() => mockDioClient.dio).thenReturn(mockDio);

    // Mock successful image fetch
    registerFallbackValue(RequestOptions(path: ''));
    when(
      () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response(
        data: [0, 1, 2, 3],
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    if (sl.isRegistered<DioClient>()) {
      sl.unregister<DioClient>();
    }
    sl.registerSingleton<DioClient>(mockDioClient);
  });

  tearDown(() {
    sl.unregister<DioClient>();
  });

  final testBook = Book(
    id: '1',
    title: 'Test Book Title',
    type: TypeBook.manga,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    cover: 'https://example.com/cover.jpg',
  );

  testWidgets('BookCard renders title correctly over image', (tester) async {
    await tester.pumpApp(BookCard(book: testBook));

    // Verify Atoms are present
    expect(find.byType(BookCover), findsOneWidget);
    expect(find.byType(BookTitle), findsOneWidget);

    // Verify Title text is present
    expect(find.text('Test Book Title'), findsOneWidget);

    // Verify it's inside a Stack
    expect(find.byType(Stack), findsOneWidget);

    // Verify Card has Clip.antiAlias
    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.clipBehavior, Clip.antiAlias);
  });
}
