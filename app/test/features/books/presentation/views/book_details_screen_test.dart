import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:gatuno/features/books/domain/entities/author.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/chapter.dart' as entity;
import 'package:gatuno/features/books/presentation/view_models/book_details_view_model.dart';
import 'package:gatuno/features/books/presentation/views/book_details_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/pump_app.dart';

class MockBookDetailsViewModel extends Mock implements BookDetailsViewModel {}

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockBookDetailsViewModel mockViewModel;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUpAll(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    when(() => mockDioClient.dio).thenReturn(mockDio);

    sl.registerSingleton<DioClient>(mockDioClient);

    // Register fallback for any()
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockViewModel = MockBookDetailsViewModel();

    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.error).thenReturn(null);
    when(() => mockViewModel.book).thenReturn(null);
    when(() => mockViewModel.chapterList).thenReturn(null);
    when(() => mockViewModel.fetchBookDetails()).thenAnswer((_) async {});

    // Handle listeners
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);

    // Mock dio get for images
    when(
      () => mockDio.get<List<int>>(any(), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<BookDetailsViewModel>.value(
      value: mockViewModel,
      child: const BookDetailsPage(),
    );
  }

  testWidgets('renders loading state', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);

    await tester.pumpApp(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error state', (tester) async {
    when(() => mockViewModel.error).thenReturn('Failed to load book');

    await tester.pumpApp(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Failed to load book'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('renders book details and chapters', (tester) async {
    final book = Book(
      id: '1',
      title: 'Test Book',
      authors: [const Author(id: '1', name: 'Test Author')],
      description: 'Test Description',
      cover: 'test_cover.jpg',
      tags: [],
      totalChapters: 1,
      publication: 2023,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final chapterList = entity.ChapterList(
      data: [
        const entity.Chapter(
          id: '1',
          index: 1,
          title: 'Chapter 1 Title',
          read: false,
        ),
      ],
      nextCursor: null,
      hasNextPage: false,
    );

    when(() => mockViewModel.book).thenReturn(book);
    when(() => mockViewModel.chapterList).thenReturn(chapterList);

    await tester.pumpApp(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Test Book'), findsOneWidget);
    expect(find.text('Test Author'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);

    // Check for chapters, possibly offstage due to SliverList in CustomScrollView
    expect(find.text('Chapter 1', skipOffstage: false), findsOneWidget);
    expect(find.text('Chapter 1 Title', skipOffstage: false), findsOneWidget);
  });
}
