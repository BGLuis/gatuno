import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/presentation/components/molecules/book_info.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_title.dart';
import 'package:gatuno/features/books/presentation/components/atoms/book_description.dart';

void main() {
  testWidgets('BookInfo renders title and description', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookInfo(title: 'Test Title', description: 'Test Description'),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.byType(BookTitle), findsOneWidget);
    expect(find.byType(BookDescription), findsOneWidget);
  });

  testWidgets('BookInfo renders only title if description is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: BookInfo(title: 'Test Title')),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(BookDescription), findsNothing);
  });
}
