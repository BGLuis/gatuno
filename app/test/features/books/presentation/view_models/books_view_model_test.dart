import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/book_page_options.dart';
import 'package:gatuno/features/books/domain/repositories/books_repository.dart';
import 'package:gatuno/features/books/presentation/view_models/books_view_model.dart';
import 'package:gatuno/features/users/data/data_sources/user_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockUserStorage extends Mock implements UserStorage {}

void main() {
  late BooksViewModel viewModel;
  late MockBooksRepository mockRepository;
  late MockUserStorage mockUserStorage;

  setUpAll(() {
    registerFallbackValue(const BookPageOptions());
  });

  setUp(() {
    mockRepository = MockBooksRepository();
    mockUserStorage = MockUserStorage();
    viewModel = BooksViewModel(
      repository: mockRepository,
      userStorage: mockUserStorage,
    );
  });

  group('BooksViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.bookList, null);
      expect(viewModel.layoutMode, BooksLayoutMode.grid);
    });

    test('fetchBooks success updates state correctly', () async {
      final bookList = BookList(
        data: [],
        total: 0,
        page: 1,
        limit: 20,
        totalPages: 1,
      );

      when(
        () => mockUserStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenAnswer((_) async => bookList);

      await viewModel.fetchBooks();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.bookList, bookList);
    });

    test('fetchBooks failure updates state correctly', () async {
      when(
        () => mockUserStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenThrow(Exception('Failed to fetch books'));

      await viewModel.fetchBooks();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, 'Exception: Failed to fetch books');
    });

    test('clearError resets error message', () async {
      when(
        () => mockUserStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => false);
      when(() => mockRepository.getBooks(any())).thenThrow(Exception('Error'));

      await viewModel.fetchBooks();
      expect(viewModel.error, isNotNull);

      viewModel.clearError();
      expect(viewModel.error, null);
    });

    test('setSearch(null) should clear search filter', () async {
      final bookList = BookList(
        data: [],
        total: 0,
        page: 1,
        limit: 20,
        totalPages: 1,
      );

      when(
        () => mockUserStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenAnswer((_) async => bookList);

      // Set search initially
      viewModel.setSearch('test');
      expect(viewModel.options.search, 'test');

      // Attempt to clear search
      viewModel.setSearch(null);

      // If copyWith bug exists, search will still be 'test'
      expect(viewModel.options.search, null);
    });
  });
}
