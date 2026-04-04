import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../../shared/components/molecules/pagination.dart';
import '../components/organisms/book_grid.dart';
import '../components/organisms/book_list.dart';
import '../components/organisms/books_app_bar.dart';
import '../components/organisms/books_filter_sheet.dart';
import '../components/templates/books_template.dart';
import '../view_models/books_view_model.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final TextEditingController _searchController = TextEditingController();
  late final BooksViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<BooksViewModel>();
    _viewModel.addListener(_onViewModelChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewModel.bookList == null) {
        _viewModel.fetchBooks(refresh: true);
      }
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_viewModel.error != null && mounted) {
      // Show snackbar only if there is already content on the screen
      // or if the error is different from a full-screen error
      if (_viewModel.bookList != null && _viewModel.bookList!.data.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        _viewModel.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return BooksTemplate(
          appBar: BooksAppBar(
            searchController: _searchController,
            layoutMode: _viewModel.layoutMode,
            onToggleLayout: () => _viewModel.setLayoutMode(
              _viewModel.layoutMode == BooksLayoutMode.grid
                  ? BooksLayoutMode.list
                  : BooksLayoutMode.grid,
            ),
            onFilterPressed: () => _showFilterSheet(context, _viewModel),
            onSearchChanged: (value) => _viewModel.setSearch(value),
            onSortChanged: (orderBy, order) =>
                _viewModel.setSort(orderBy, order),
          ),
          body: _buildContent(l10n, _viewModel),
        );
      },
    );
  }

  Widget _buildContent(AppLocalizations l10n, BooksViewModel viewModel) {
    if (viewModel.isLoading && (viewModel.bookList?.data.isEmpty ?? true)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null && (viewModel.bookList?.data.isEmpty ?? true)) {
      return Center(child: Text(viewModel.error!));
    }

    final books = viewModel.bookList?.data ?? [];

    if (books.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => viewModel.fetchBooks(refresh: true, resetPage: false),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: Text(l10n.booksNoBooksFound)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                viewModel.fetchBooks(refresh: true, resetPage: false),
            child: viewModel.layoutMode == BooksLayoutMode.grid
                ? BookGrid(books: books)
                : BookListView(books: books),
          ),
        ),
        Pagination(
          currentPage: viewModel.options.page,
          totalPages: viewModel.bookList?.totalPages ?? 1,
          isLoading: viewModel.isLoading,
          onPageChanged: (page) => viewModel.setPage(page),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context, BooksViewModel viewModel) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => BooksFilterSheet(
        initialOptions: viewModel.options,
        onApply: (newOptions) {
          viewModel.updateFilters(
            publication: newOptions.publication,
            publicationOperator: newOptions.publicationOperator,
            type: newOptions.type,
            tags: newOptions.tags,
            tagsLogic: newOptions.tagsLogic,
            excludeTags: newOptions.excludeTags,
            excludeTagsLogic: newOptions.excludeTagsLogic,
            authors: newOptions.authors,
            authorsLogic: newOptions.authorsLogic,
          );
        },
        onClear: viewModel.clearFilters,
      ),
    );
  }
}
