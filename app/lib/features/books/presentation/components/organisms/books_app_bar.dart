import 'package:flutter/material.dart';
import '../../../domain/entities/book_page_options.dart';
import '../../view_models/books_view_model.dart';
import '../atoms/books_filter_action.dart';
import '../atoms/books_layout_action.dart';
import '../molecules/books_search_field.dart';
import '../molecules/books_sort_action.dart';

class BooksAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final BooksLayoutMode layoutMode;
  final VoidCallback onToggleLayout;
  final VoidCallback onFilterPressed;
  final void Function(String?) onSearchChanged;
  final void Function(String, SortOrder) onSortChanged;

  const BooksAppBar({
    super.key,
    required this.searchController,
    required this.layoutMode,
    required this.onToggleLayout,
    required this.onFilterPressed,
    required this.onSearchChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BooksSearchField(
        controller: searchController,
        onChanged: onSearchChanged,
      ),
      actions: [
        BooksSortAction(onSortChanged: onSortChanged),
        BooksLayoutAction(layoutMode: layoutMode, onPressed: onToggleLayout),
        BooksFilterAction(onPressed: onFilterPressed),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
