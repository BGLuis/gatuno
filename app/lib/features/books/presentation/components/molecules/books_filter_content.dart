import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../domain/entities/book_page_options.dart';
import '../../../domain/entities/book_type.dart';
import 'books_sensitive_content_filter.dart';
import 'books_types_filter.dart';
import 'books_year_filter.dart';

class BooksFilterContent extends StatelessWidget {
  final BookPageOptions options;
  final TextEditingController yearController;
  final void Function(String?) onOperatorChanged;
  final void Function(String) onYearChanged;
  final void Function(TypeBook, bool) onTypeSelected;
  final void Function(String, bool) onSensitiveContentSelected;

  const BooksFilterContent({
    super.key,
    required this.options,
    required this.yearController,
    required this.onOperatorChanged,
    required this.onYearChanged,
    required this.onTypeSelected,
    required this.onSensitiveContentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BooksYearFilter(
            operator: options.publicationOperator,
            yearController: yearController,
            onOperatorChanged: onOperatorChanged,
            onYearChanged: onYearChanged,
          ),
          const SizedBox(height: 16),
          BooksTypesFilter(
            selectedTypes: options.type,
            onSelected: onTypeSelected,
          ),
          const SizedBox(height: 16),
          BooksSensitiveContentFilter(
            selectedContent: options.sensitiveContent,
            onSelected: onSensitiveContentSelected,
          ),
          const SizedBox(height: 16),
          Text(l10n.booksTags, style: theme.textTheme.titleMedium),
          // TODO: Implement proper tag selection
          const Text('Tag selection to be implemented...'),
        ],
      ),
    );
  }
}
