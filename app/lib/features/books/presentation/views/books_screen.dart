import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/organisms/books_app_bar.dart';
import '../components/organisms/books_content.dart';
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
            onFilterPressed: () => BooksFilterSheet.show(context, _viewModel),
            onSearchChanged: (value) => _viewModel.setSearch(value),
            onSortChanged: (orderBy, order) =>
                _viewModel.setSort(orderBy, order),
          ),
          body: BooksContent(viewModel: _viewModel),
        );
      },
    );
  }
}
