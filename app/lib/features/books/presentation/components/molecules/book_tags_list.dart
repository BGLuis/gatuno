import 'package:flutter/material.dart';
import 'package:gatuno/features/books/domain/entities/tag.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_tag.dart';

class BookTagsList extends StatelessWidget {
  final List<Tag> tags;

  const BookTagsList({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: tags.map((tag) => BookTag(label: tag.name)).toList(),
    );
  }
}
