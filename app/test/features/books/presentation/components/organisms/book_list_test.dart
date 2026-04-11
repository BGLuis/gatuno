import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book.dart';
import 'package:gatuno/features/books/domain/entities/book_type.dart';
import 'package:gatuno/features/books/presentation/components/organisms/book_list.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../helpers/pump_app.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    if (sl.isRegistered<DioClient>()) {
      sl.unregister<DioClient>();
    }
    sl.registerSingleton<DioClient>(mockDioClient);
  });

  tearDown(() {
    sl.unregister<DioClient>();
  });

  final testBooks = List.generate(
    5,
    (i) => Book(
      id: '$i',
      title: 'Book $i',
      type: TypeBook.manga,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  testWidgets('BookListView renders all items with fixed extent', (
    tester,
  ) async {
    await tester.pumpApp(Scaffold(body: BookListView(books: testBooks)));

    // Verify all books are present
    for (int i = 0; i < testBooks.length; i++) {
      expect(find.text('Book $i'), findsOneWidget);
    }
  });
}
