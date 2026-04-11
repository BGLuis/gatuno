import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../domain/entities/book_page_options.dart';

class BooksSortAction extends StatelessWidget {
  final void Function(String, SortOrder) onSortChanged;

  const BooksSortAction({super.key, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      tooltip: l10n.booksSortTitle,
      onSelected: (option) {
        onSortChanged(option.orderBy, option.order);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const SortOption('createdAt', SortOrder.desc),
          child: Text(l10n.booksSortMostRecentAdded),
        ),
        PopupMenuItem(
          value: const SortOption('createdAt', SortOrder.asc),
          child: Text(l10n.booksSortOldestAdded),
        ),
        PopupMenuItem(
          value: const SortOption('title', SortOrder.asc),
          child: Text(l10n.booksSortAlphabeticalAZ),
        ),
        PopupMenuItem(
          value: const SortOption('title', SortOrder.desc),
          child: Text(l10n.booksSortAlphabeticalZA),
        ),
        PopupMenuItem(
          value: const SortOption('updatedAt', SortOrder.desc),
          child: Text(l10n.booksSortMostRecentUpdate),
        ),
        PopupMenuItem(
          value: const SortOption('updatedAt', SortOrder.asc),
          child: Text(l10n.booksSortOldestUpdate),
        ),
        PopupMenuItem(
          value: const SortOption('publication', SortOrder.desc),
          child: Text(l10n.booksSortMostRecentPublished),
        ),
        PopupMenuItem(
          value: const SortOption('publication', SortOrder.asc),
          child: Text(l10n.booksSortOldestPublished),
        ),
      ],
    );
  }
}
