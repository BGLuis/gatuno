import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/molecules/pagination.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('Pagination renders correctly', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Pagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
      ),
    );

    // Should show 1, ellipsis, 3, 4, 5, 6, 7, ellipsis, 10
    expect(find.text('1'), findsOneWidget);
    expect(find.text('...'), findsNWidgets(2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('Pagination handles page tap', (tester) async {
    int? changedPage;
    await tester.pumpApp(
      Scaffold(
        body: Pagination(
          currentPage: 5,
          totalPages: 10,
          onPageChanged: (page) => changedPage = page,
        ),
      ),
    );

    await tester.tap(find.text('3'));
    expect(changedPage, equals(3));
  });

  testWidgets('Pagination hides when only one page', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Pagination(currentPage: 1, totalPages: 1, onPageChanged: (_) {}),
      ),
    );

    expect(find.byType(Padding), findsNothing);
  });

  testWidgets('Pagination shows loader when isLoading is true', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: Pagination(
          currentPage: 2,
          totalPages: 5,
          isLoading: true,
          onPageChanged: (_) {},
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Page number text should be hidden when loading that specific page
    expect(find.text('2'), findsNothing);
  });
}
