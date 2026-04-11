import 'author.dart';
import 'book_type.dart';
import 'tag.dart';

class Book {
  final String id;
  final String title;
  final List<Author> authors;
  final List<Tag> tags;
  final String? description;
  final String? cover;
  final TypeBook? type;
  final int? publication;
  final int? totalChapters;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.tags = const [],
    this.description,
    this.cover,
    this.type,
    this.publication,
    this.totalChapters,
    this.createdAt,
    this.updatedAt,
  });
}

class BookList {
  final List<Book> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const BookList({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
