import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/book.dart';
import '../atoms/book_cover.dart';
import 'book_info.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.push('/books/${book.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCover(imageUrl: book.cover, width: 70, height: 100),
              const SizedBox(width: 16),
              Expanded(
                child: BookInfo(
                  title: book.title,
                  description: book.description,
                  titleStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  descriptionStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
