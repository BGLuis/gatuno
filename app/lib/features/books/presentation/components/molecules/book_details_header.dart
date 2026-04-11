import 'package:flutter/material.dart';
import 'package:gatuno/features/books/domain/entities/author.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class BookDetailsHeader extends StatelessWidget {
  final String title;
  final List<Author> authors;
  final int? totalChapters;
  final int? publicationYear;

  const BookDetailsHeader({
    super.key,
    required this.title,
    required this.authors,
    this.totalChapters,
    this.publicationYear,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          authors.map((e) => e.name).join(', '),
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (totalChapters != null) ...[
          Text(
            '$totalChapters ${l10n.booksChapterCount}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (publicationYear != null)
          Text(
            '${l10n.booksPublicationYear} $publicationYear',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }
}
