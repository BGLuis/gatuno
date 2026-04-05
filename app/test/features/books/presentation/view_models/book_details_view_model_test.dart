import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/chapter.dart';
import 'package:gatuno/features/books/domain/entities/chapter_page_options.dart';
import 'package:gatuno/features/books/domain/repositories/books_repository.dart';
import 'package:gatuno/features/books/presentation/view_models/book_details_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  late BookDetailsViewModel viewModel;
  late MockBooksRepository mockRepository;
  const bookId = '1';

  setUpAll(() {
    registerFallbackValue(const ChapterPageOptions());
  });

  setUp(() {
    mockRepository = MockBooksRepository();
    viewModel = BookDetailsViewModel(
      repository: mockRepository,
      bookId: bookId,
    );
  });

  group('BookDetailsViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.book, null);
      expect(viewModel.chapterList, null);
      expect(viewModel.options.order, ChapterSortOrder.asc);
    });

    test('fetchBookDetails success updates state correctly', () async {
      const book = Book(id: bookId, title: 'Test Book');
      const chapterList = ChapterList(
        data: [Chapter(id: '1', index: 1.0)],
        hasNextPage: false,
      );

      when(() => mockRepository.getBook(bookId)).thenAnswer((_) async => book);
      when(
        () => mockRepository.getBookChapters(bookId, any()),
      ).thenAnswer((_) async => chapterList);

      await viewModel.fetchBookDetails();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.book, book);
      expect(viewModel.chapterList, chapterList);
    });

    test('fetchBookDetails failure updates error state', () async {
      when(
        () => mockRepository.getBook(bookId),
      ).thenThrow(Exception('Failed to fetch book'));

      await viewModel.fetchBookDetails();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, 'Exception: Failed to fetch book');
    });

    test('loadMoreChapters success appends chapters', () async {
      const book = Book(id: bookId, title: 'Test Book');
      const initialChapterList = ChapterList(
        data: [Chapter(id: '1', index: 1.0)],
        nextCursor: 'cursor',
        hasNextPage: true,
      );
      const moreChapterList = ChapterList(
        data: [Chapter(id: '2', index: 2.0)],
        hasNextPage: false,
      );

      when(() => mockRepository.getBook(bookId)).thenAnswer((_) async => book);
      when(
        () => mockRepository.getBookChapters(bookId, any()),
      ).thenAnswer((_) async => initialChapterList);

      await viewModel.fetchBookDetails();

      when(
        () => mockRepository.getBookChapters(bookId, any()),
      ).thenAnswer((_) async => moreChapterList);

      await viewModel.loadMoreChapters();

      expect(viewModel.isLoading, false);
      expect(viewModel.chapterList?.data.length, 2);
      expect(viewModel.chapterList?.data[1].id, '2');
      expect(viewModel.chapterList?.hasNextPage, false);
    });

    test('setChapterOrder changes order and refetches', () async {
      const book = Book(id: bookId, title: 'Test Book');
      const chapterList = ChapterList(data: [], hasNextPage: false);

      when(() => mockRepository.getBook(bookId)).thenAnswer((_) async => book);
      when(
        () => mockRepository.getBookChapters(bookId, any()),
      ).thenAnswer((_) async => chapterList);

      viewModel.setChapterOrder(ChapterSortOrder.desc);

      expect(viewModel.options.order, ChapterSortOrder.desc);
      expect(viewModel.isLoading, true); // It starts fetching immediately

      await Future<void>.delayed(Duration.zero); // Allow fetch to complete

      verify(
        () => mockRepository.getBookChapters(
          bookId,
          any(
            that: predicate<ChapterPageOptions>(
              (o) => o.order == ChapterSortOrder.desc,
            ),
          ),
        ),
      ).called(1);
    });

    test('clearError resets error', () {
      viewModel.clearError(); // Just to trigger it, we need to set error first

      // We can't set error directly, so we trigger a failure
      when(() => mockRepository.getBook(bookId)).thenThrow(Exception('Error'));

      return viewModel.fetchBookDetails().then((_) {
        expect(viewModel.error, isNotNull);
        viewModel.clearError();
        expect(viewModel.error, null);
      });
    });
  });
}
