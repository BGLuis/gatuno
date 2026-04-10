import '../../../../core/base/safe_change_notifier.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/entities/chapter_page_options.dart';
import '../../domain/repositories/books_repository.dart';

class BookDetailsViewModel extends SafeChangeNotifier {
  final BooksRepository _repository;
  final String bookId;
  static const String _logTag = 'BookDetailsViewModel';

  BookDetailsViewModel({
    required BooksRepository repository,
    required this.bookId,
  }) : _repository = repository;

  Book? _book;
  Book? get book => _book;

  ChapterList? _chapterList;
  ChapterList? get chapterList => _chapterList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingChapters = false;
  bool get isLoadingChapters => _isLoadingChapters;

  String? _error;
  String? get error => _error;

  String? _chaptersError;
  String? get chaptersError => _chaptersError;

  ChapterPageOptions _options = const ChapterPageOptions();
  ChapterPageOptions get options => _options;

  Future<void> fetchBookDetails() async {
    if (_isLoading) return;

    AppLogger.i('Fetching book details for ID: $bookId', _logTag);
    _isLoading = true;
    _error = null;
    _chaptersError = null;
    notifyListeners();

    try {
      final bookResult = await _repository.getBook(bookId);
      _book = bookResult;
      notifyListeners();

      await fetchChapters();
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching book details', e, stackTrace, _logTag);
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchChapters() async {
    if (_isLoadingChapters) return;

    AppLogger.i('Fetching chapters for ID: $bookId', _logTag);
    _isLoadingChapters = true;
    _chaptersError = null;
    notifyListeners();

    try {
      final chaptersResult = await _repository.getBookChapters(
        bookId,
        _options,
      );
      _chapterList = chaptersResult;

      AppLogger.i(
        'Chapters fetched successfully: id=$bookId, count=${_chapterList?.data.length}',
        _logTag,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching chapters', e, stackTrace, _logTag);
      _chaptersError = e.toString();
    } finally {
      _isLoadingChapters = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreChapters() async {
    if (_isLoading ||
        _isLoadingChapters ||
        _chapterList == null ||
        !_chapterList!.hasNextPage) {
      return;
    }

    AppLogger.i('Loading more chapters for ID: $bookId', _logTag);
    _isLoadingChapters = true;
    notifyListeners();

    try {
      _options = _options.copyWith(cursor: _chapterList!.nextCursor);
      final result = await _repository.getBookChapters(bookId, _options);

      _chapterList = ChapterList(
        data: [..._chapterList!.data, ...result.data],
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
      );

      AppLogger.i(
        'More chapters fetched successfully: count=${result.data.length}',
        _logTag,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching more chapters', e, stackTrace, _logTag);
      _chaptersError = e.toString();
    } finally {
      _isLoadingChapters = false;
      notifyListeners();
    }
  }

  void setChapterOrder(ChapterSortOrder order) {
    if (_options.order == order) return;
    AppLogger.i('Setting chapter order to: $order', _logTag);
    _options = ChapterPageOptions(order: order);
    _chapterList = null;
    fetchBookDetails();
  }

  void clearError() {
    AppLogger.d('Clearing book details error', _logTag);
    _error = null;
    notifyListeners();
  }
}
