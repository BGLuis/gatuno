import 'package:gatuno/features/books/data/models/author_model.dart';
import 'package:gatuno/features/books/data/models/book_model.dart';
import 'package:gatuno/features/books/data/models/tag_model.dart';
import 'package:gatuno/features/books/domain/entities/book_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookModel', () {
    const json = {
      'id': '1',
      'title': 'Test Book',
      'authors': [
        {'id': '1', 'name': 'Author 1'},
        {'id': '2', 'name': 'Author 2'},
      ],
      'tags': [
        {'id': '1', 'name': 'Tag 1'},
        {'id': '2', 'name': 'Tag 2'},
      ],
      'description': 'Description',
      'cover': 'cover.jpg',
      'type': 'manga',
      'publication': 2021,
      'createdAt': '2021-01-01T00:00:00.000Z',
      'updatedAt': '2021-01-01T00:00:00.000Z',
    };

    test('fromJson should return a valid model', () {
      final model = BookModel.fromJson(json);

      expect(model.id, '1');
      expect(model.title, 'Test Book');
      expect(model.authors.length, 2);
      expect(model.authors[0], isA<AuthorModel>());
      expect(model.authors[0].name, 'Author 1');
      expect(model.tags.length, 2);
      expect(model.tags[0], isA<TagModel>());
      expect(model.tags[0].name, 'Tag 1');
      expect(model.description, 'Description');
      expect(model.cover, 'cover.jpg');
      expect(model.type, TypeBook.manga);
      expect(model.publication, 2021);
      expect(model.createdAt, DateTime.parse('2021-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2021-01-01T00:00:00.000Z'));
    });

    test('fromJson should handle null type', () {
      final model = BookModel.fromJson({...json, 'type': null});
      expect(model.type, isNull);
    });

    test('fromJson should handle unknown type as OTHER', () {
      final model = BookModel.fromJson({...json, 'type': 'UNKNOWN'});
      expect(model.type, TypeBook.other);
    });

    test('fromJson should handle null authors and tags', () {
      const jsonNoAuthorsTags = {
        'id': '1',
        'title': 'Test Book',
        'authors': null,
        'tags': null,
        'description': null,
        'cover': null,
        'type': 'MANGA',
        'publication': null,
        'createdAt': '2021-01-01T00:00:00.000Z',
        'updatedAt': '2021-01-01T00:00:00.000Z',
      };

      final model = BookModel.fromJson(jsonNoAuthorsTags);

      expect(model.authors, isEmpty);
      expect(model.tags, isEmpty);
    });

    test('fromJson should handle missing authors and tags', () {
      const jsonMissingAuthorsTags = {
        'id': '1',
        'title': 'Test Book',
        'type': 'MANGA',
        'createdAt': '2021-01-01T00:00:00.000Z',
        'updatedAt': '2021-01-01T00:00:00.000Z',
      };

      final model = BookModel.fromJson(jsonMissingAuthorsTags);

      expect(model.authors, isEmpty);
      expect(model.tags, isEmpty);
    });

    test('fromJson should handle null createdAt and updatedAt', () {
      const jsonNullDates = {
        'id': '1',
        'title': 'Test Book',
        'createdAt': null,
        'updatedAt': null,
      };

      final model = BookModel.fromJson(jsonNullDates);

      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
    });
  });
}
