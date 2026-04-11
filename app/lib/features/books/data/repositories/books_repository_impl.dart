import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/entities/book_page_options.dart';
import '../../domain/entities/chapter_page_options.dart';
import '../../domain/repositories/books_repository.dart';
import '../models/book_model.dart';
import '../models/chapter_model.dart';

class BooksRepositoryImpl implements BooksRepository {
  final DioClient _dioClient;
  static const String _logTag = 'BooksRepository';

  BooksRepositoryImpl(this._dioClient);

  @override
  Future<BookListModel> getBooks(BookPageOptions options) async {
    AppLogger.i('Fetching books with options: ${options.toJson()}', _logTag);
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        ApiConstants.books,
        queryParameters: options.toJson(),
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return BookListModel.fromJson(data);
      } else {
        throw ServerException(
          message: 'Failed to fetch books: Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      AppLogger.e(
        'DioException fetching books: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error fetching books', e, stackTrace, _logTag);
      throw Exception('An unexpected error occurred while fetching books');
    }
  }

  @override
  Future<BookModel> getBook(String bookId) async {
    AppLogger.i('Fetching book with ID: $bookId', _logTag);
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '${ApiConstants.books}/$bookId',
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return BookModel.fromJson(data);
      } else {
        throw ServerException(
          message: 'Failed to fetch book: Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      AppLogger.e(
        'DioException fetching book: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error fetching book', e, stackTrace, _logTag);
      throw Exception('An unexpected error occurred while fetching book');
    }
  }

  @override
  Future<ChapterListModel> getBookChapters(
    String bookId,
    ChapterPageOptions options,
  ) async {
    AppLogger.i(
      'Fetching chapters for book: $bookId, options: ${options.toJson()}',
      _logTag,
    );
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        '${ApiConstants.books}/$bookId/chapters',
        queryParameters: options.toJson(),
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return ChapterListModel.fromJson(data);
      } else {
        throw ServerException(
          message: 'Failed to fetch chapters: Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      AppLogger.e(
        'DioException fetching chapters: ${e.message}',
        e,
        e.stackTrace,
        _logTag,
      );
      throw ApiExceptionHandler.handle(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error fetching chapters', e, stackTrace, _logTag);
      throw Exception('An unexpected error occurred while fetching chapters');
    }
  }
}
