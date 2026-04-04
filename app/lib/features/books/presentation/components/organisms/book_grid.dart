import 'package:flutter/material.dart';
import '../../../domain/entities/book.dart';
import '../molecules/book_card.dart';

class BookGrid extends StatelessWidget {
  final List<Book> books;
  final ScrollController? scrollController;

  const BookGrid({super.key, required this.books, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(book: books[index]);
      },
    );
  }
}
