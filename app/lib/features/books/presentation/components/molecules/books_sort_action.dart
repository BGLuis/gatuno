import 'package:flutter/material.dart';
import '../../../domain/entities/book_page_options.dart';

class BooksSortAction extends StatelessWidget {
  final void Function(String, SortOrder) onSortChanged;

  const BooksSortAction({super.key, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: (option) {
        onSortChanged(option.orderBy, option.order);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortOption('createdAt', SortOrder.desc),
          child: Text('Most Recent Added'),
        ),
        const PopupMenuItem(
          value: SortOption('createdAt', SortOrder.asc),
          child: Text('Oldest Added'),
        ),
        const PopupMenuItem(
          value: SortOption('title', SortOrder.asc),
          child: Text('Alphabetical A-Z'),
        ),
        const PopupMenuItem(
          value: SortOption('title', SortOrder.desc),
          child: Text('Alphabetical Z-A'),
        ),
        const PopupMenuItem(
          value: SortOption('updatedAt', SortOrder.desc),
          child: Text('Most Recent Update'),
        ),
        const PopupMenuItem(
          value: SortOption('updatedAt', SortOrder.asc),
          child: Text('Oldest Update'),
        ),
        const PopupMenuItem(
          value: SortOption('publication', SortOrder.desc),
          child: Text('Most Recent Published'),
        ),
        const PopupMenuItem(
          value: SortOption('publication', SortOrder.asc),
          child: Text('Oldest Published'),
        ),
      ],
    );
  }
}
