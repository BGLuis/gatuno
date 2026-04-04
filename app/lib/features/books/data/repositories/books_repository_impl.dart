import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/entities/book_page_options.dart';
import '../../domain/repositories/books_repository.dart';
import '../models/book_model.dart';

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
        AppLogger.e(
          'Failed to fetch books: Invalid response format',
          null,
          null,
          _logTag,
        );
        throw ServerException(
          message: 'Failed to fetch books: Invalid response format',
          statusCode: response.statusCode,
        );
      }
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
}
