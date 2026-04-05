import '../../../../core/base/safe_change_notifier.dart';
import '../../../../core/logging/logger.dart';
import '../../../users/data/data_sources/user_local_data_source.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/book_page_options.dart';
import '../../domain/entities/book_type.dart';
import '../../domain/repositories/books_repository.dart';

enum BooksLayoutMode { grid, list }

class BooksViewModel extends SafeChangeNotifier {
  final BooksRepository _repository;
  final UserStorage _userStorage;
  static const String _logTag = 'BooksViewModel';

  BooksViewModel({
    required BooksRepository repository,
    required UserStorage userStorage,
  }) : _repository = repository,
       _userStorage = userStorage;

  BookList? _bookList;
  BookList? get bookList => _bookList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  BooksLayoutMode _layoutMode = BooksLayoutMode.grid;
  BooksLayoutMode get layoutMode => _layoutMode;

  BookPageOptions _options = const BookPageOptions();
  BookPageOptions get options => _options;

  Future<void> fetchBooks({bool refresh = false, bool resetPage = true}) async {
    if (_isLoading) return;

    AppLogger.i(
      'Fetching books: refresh=$refresh, resetPage=$resetPage, page=${_options.page}',
      _logTag,
    );
    _isLoading = true;
    _error = null;
    if (refresh && resetPage) {
      _options = _options.copyWith(page: 1);
    }
    notifyListeners();

    try {
      final sensitiveEnabled = await _userStorage.isSensitiveContentEnabled();
      // If no sensitive content filter is selected, we apply the default based on user settings.
      // If the user is NOT allowed sensitive content, we force 'Safe' even if they try to select something else.
      List<String>? sensitiveFilter = _options.sensitiveContent;

      if (!sensitiveEnabled) {
        sensitiveFilter = ['Safe'];
      }

      final currentOptions = _options.copyWith(
        sensitiveContent: sensitiveFilter,
      );

      final result = await _repository.getBooks(currentOptions);

      _bookList = result;
      AppLogger.i(
        'Books fetched successfully: page=${result.page}, count=${result.data.length}, total=${result.total}',
        _logTag,
      );
    } catch (e, stackTrace) {
      AppLogger.e('Error fetching books', e, stackTrace, _logTag);
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPage(int page) {
    if (page < 1 || (_bookList != null && page > _bookList!.totalPages)) {
      return;
    }
    AppLogger.i('Setting page to: $page', _logTag);
    _options = _options.copyWith(page: page);
    fetchBooks();
  }

  void loadNextPage() => setPage(_options.page + 1);

  void loadPreviousPage() => setPage(_options.page - 1);

  void setLayoutMode(BooksLayoutMode mode) {
    AppLogger.i('Setting layout mode to: $mode', _logTag);
    _layoutMode = mode;
    notifyListeners();
  }

  void setSearch(String? search) {
    AppLogger.i('Setting search to: $search', _logTag);
    _options = _options.copyWith(search: search, page: 1);
    fetchBooks(refresh: true);
  }

  void setSort(String orderBy, SortOrder order) {
    AppLogger.i('Setting sort: $orderBy $order', _logTag);
    _options = _options.copyWith(orderBy: orderBy, order: order, page: 1);
    fetchBooks(refresh: true);
  }

  void updateFilters({
    int? publication,
    String? publicationOperator,
    List<TypeBook>? type,
    List<String>? tags,
    String? tagsLogic,
    List<String>? excludeTags,
    String? excludeTagsLogic,
    List<String>? authors,
    String? authorsLogic,
    List<String>? sensitiveContent,
  }) {
    AppLogger.i('Updating filters', _logTag);
    _options = _options.copyWith(
      publication: publication,
      publicationOperator: publicationOperator,
      type: type,
      tags: tags,
      tagsLogic: tagsLogic,
      excludeTags: excludeTags,
      excludeTagsLogic: excludeTagsLogic,
      authors: authors,
      authorsLogic: authorsLogic,
      sensitiveContent: sensitiveContent,
      page: 1,
    );
    fetchBooks(refresh: true);
  }

  void clearFilters() {
    AppLogger.i('Clearing filters', _logTag);
    _options = const BookPageOptions();
    fetchBooks(refresh: true);
  }

  void clearError() {
    AppLogger.d('Clearing books error', _logTag);
    _error = null;
    notifyListeners();
  }
}
