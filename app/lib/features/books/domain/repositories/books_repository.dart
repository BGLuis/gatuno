import '../entities/book.dart';
import '../entities/book_page_options.dart';

abstract class BooksRepository {
  Future<BookList> getBooks(BookPageOptions options);
}
