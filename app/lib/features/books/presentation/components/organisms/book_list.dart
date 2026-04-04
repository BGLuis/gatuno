import 'package:flutter/material.dart';
import '../../../domain/entities/book.dart';
import '../molecules/book_list_item.dart';

class BookListView extends StatelessWidget {
  final List<Book> books;
  final ScrollController? scrollController;

  const BookListView({super.key, required this.books, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemExtent: 116.0,
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookListItem(book: books[index]);
      },
    );
  }
}
