import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/book_page_options.dart';
import 'package:gatuno/features/books/domain/repositories/books_repository.dart';
import 'package:gatuno/features/books/presentation/view_models/books_view_model.dart';
import 'package:gatuno/features/settings/domain/use_cases/settings_service.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class MockSettingsService extends Mock implements SettingsService {}

void main() {
  late BooksViewModel viewModel;
  late MockBooksRepository mockRepository;
  late MockSettingsService mockSettingsService;

  setUpAll(() {
    registerFallbackValue(const BookPageOptions());
  });

  setUp(() {
    mockRepository = MockBooksRepository();
    mockSettingsService = MockSettingsService();
    viewModel = BooksViewModel(
      repository: mockRepository,
      settingsService: mockSettingsService,
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

      when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenAnswer((_) async => bookList);

      await viewModel.fetchBooks();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.bookList, bookList);
    });

    test('fetchBooks failure updates state correctly', () async {
      when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenThrow(Exception('Failed to fetch books'));

      await viewModel.fetchBooks();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, 'Exception: Failed to fetch books');
    });

    test('clearError resets error message', () async {
      when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(false);
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

      when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(false);
      when(
        () => mockRepository.getBooks(any()),
      ).thenAnswer((_) async => bookList);

      // Set search initially
      viewModel.setSearch('test');
      expect(viewModel.options.search, 'test');

      // Attempt to clear search
      viewModel.setSearch(null);

      expect(viewModel.options.search, null);
    });
  });
}
