import '../../domain/entities/book.dart';
import '../../domain/entities/book_type.dart';
import 'author_model.dart';
import 'tag_model.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    super.authors,
    super.tags,
    super.description,
    super.cover,
    super.type,
    super.publication,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: _parseAuthors(json['authors']),
      tags: _parseTags(json['tags']),
      description: json['description'] as String?,
      cover: json['cover'] as String?,
      type: _parseType(json['type'] as String?),
      publication: json['publication'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static List<AuthorModel> _parseAuthors(dynamic authors) {
    if (authors == null) return const [];
    return (authors as List<dynamic>)
        .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<TagModel> _parseTags(dynamic tags) {
    if (tags == null) return const [];
    return (tags as List<dynamic>)
        .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static TypeBook? _parseType(String? type) {
    if (type == null) return null;
    try {
      return TypeBook.values.firstWhere(
        (e) => e.name.toLowerCase() == type.toLowerCase(),
      );
    } catch (_) {
      return TypeBook.other;
    }
  }
}

class BookListModel extends BookList {
  const BookListModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>? ?? {};
    final items = (json['data'] as List<dynamic>? ?? [])
        .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return BookListModel(
      data: items,
      total: meta['total'] as int? ?? 0,
      page: meta['page'] as int? ?? 1,
      limit: meta['limit'] as int? ?? 20,
      totalPages: meta['lastPage'] as int? ?? 0,
    );
  }
}
