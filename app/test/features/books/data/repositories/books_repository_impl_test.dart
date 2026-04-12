import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/api_constants.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:gatuno/core/network/exceptions.dart';
import 'package:gatuno/features/books/data/repositories/books_repository_impl.dart';
import 'package:gatuno/features/books/domain/entities/book_page_options.dart';
import 'package:gatuno/features/books/domain/entities/chapter_page_options.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late BooksRepositoryImpl repository;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    repository = BooksRepositoryImpl(mockDioClient);
  });

  group('getBooks', () {
    const options = BookPageOptions();
    final bookListJson = {
      'data': [
        {'id': '1', 'title': 'Book 1'},
      ],
      'metadata': {'total': 1, 'page': 1, 'limit': 20, 'lastPage': 1},
    };

    test('should return BookListModel when the call is successful', () async {
      // arrange
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: bookListJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiConstants.books),
        ),
      );

      // act
      final result = await repository.getBooks(options);

      // assert
      expect(result.data.length, 1);
      expect(result.data[0].id, '1');
      expect(result.total, 1);
    });

    test(
      'should throw ServerException when response format is invalid',
      () async {
        // arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ApiConstants.books),
          ),
        );

        // act
        final call = repository.getBooks(options);

        // assert
        expect(call, throwsA(isA<ServerException>()));
      },
    );

    test('should throw ServerException when statusCode is not 200', () async {
      // arrange
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: bookListJson,
          statusCode: 500,
          requestOptions: RequestOptions(path: ApiConstants.books),
        ),
      );

      // act
      final call = repository.getBooks(options);

      // assert
      expect(call, throwsA(isA<ServerException>()));
    });

    test(
      'should throw handled ApiException when DioException occurs',
      () async {
        // arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiConstants.books),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // act
        final call = repository.getBooks(options);

        // assert
        expect(call, throwsA(isA<NetworkException>()));
      },
    );

    test(
      'should throw generic Exception when an unexpected error occurs',
      () async {
        // arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        // act
        final call = repository.getBooks(options);

        // assert
        expect(call, throwsA(isA<Exception>()));
      },
    );
  });

  group('getBook', () {
    const bookId = '1';
    final bookJson = {'id': '1', 'title': 'Book 1'};

    test('should return BookModel when the call is successful', () async {
      // arrange
      when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: bookJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiConstants.books}/$bookId'),
        ),
      );

      // act
      final result = await repository.getBook(bookId);

      // assert
      expect(result.id, '1');
      expect(result.title, 'Book 1');
    });

    test(
      'should throw ServerException when response format is invalid',
      () async {
        // arrange
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: '${ApiConstants.books}/$bookId',
            ),
          ),
        );

        // act
        final call = repository.getBook(bookId);

        // assert
        expect(call, throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw handled ApiException when DioException occurs',
      () async {
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
          ),
        );

        expect(() => repository.getBook(bookId), throwsA(isA<AuthException>()));
      },
    );

    test('should throw generic Exception on unexpected error', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(any()),
      ).thenThrow(Exception());

      expect(() => repository.getBook(bookId), throwsA(isA<Exception>()));
    });
  });

  group('getBookChapters', () {
    const bookId = '1';
    const options = ChapterPageOptions();
    final chapterListJson = {
      'data': [
        {'id': '1', 'index': 1.0},
      ],
      'hasNextPage': false,
    };

    test(
      'should return ChapterListModel when the call is successful',
      () async {
        // arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: chapterListJson,
            statusCode: 200,
            requestOptions: RequestOptions(
              path: '${ApiConstants.books}/$bookId/chapters',
            ),
          ),
        );

        // act
        final result = await repository.getBookChapters(bookId, options);

        // assert
        expect(result.data.length, 1);
        expect(result.data[0].id, '1');
        expect(result.hasNextPage, false);
      },
    );

    test('should throw ServerException when response is invalid', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () => repository.getBookChapters(bookId, options),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw handled ApiException on DioException', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => repository.getBookChapters(bookId, options),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw generic Exception on unexpected error', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception());

      expect(
        () => repository.getBookChapters(bookId, options),
        throwsA(isA<Exception>()),
      );
    });
  });
}
