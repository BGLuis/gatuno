import '../entities/book.dart';
import '../entities/book_page_options.dart';
import '../entities/chapter.dart';
import '../entities/chapter_page_options.dart';

abstract class BooksRepository {
  Future<BookList> getBooks(BookPageOptions options);
  Future<Book> getBook(String bookId);
  Future<ChapterList> getBookChapters(
    String bookId,
    ChapterPageOptions options,
  );
}
