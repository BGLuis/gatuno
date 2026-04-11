import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/books/domain/entities/book_page_options.dart';
import 'package:gatuno/features/books/domain/entities/book_type.dart';
import 'package:gatuno/features/books/presentation/components/organisms/books_filter_sheet.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_injection.dart';

void main() {
  setUp(() async {
    await initTestDI();
  });

  group('BooksFilterSheet', () {
    testWidgets('shows initial options correctly', (tester) async {
      const initialOptions = BookPageOptions(
        publication: 2020,
        publicationOperator: 'gt',
        type: [TypeBook.manga],
      );

      await tester.pumpApp(
        Scaffold(
          body: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (context) => BooksFilterSheet(
                initialOptions: initialOptions,
                onApply: (_) {},
                onClear: () {},
              ),
            ),
          ),
        ),
      );

      // Check year
      expect(find.text('2020'), findsOneWidget);
      // Check operator (After corresponds to 'gt' in en locale)
      expect(find.text('After'), findsOneWidget);
      // Check type (Manga chip selected)
      final mangaChip = tester.widget<FilterChip>(
        find.byWidgetPredicate(
          (widget) =>
              widget is FilterChip &&
              widget.label is Text &&
              (widget.label as Text).data == 'Manga',
        ),
      );
      expect(mangaChip.selected, true);
    });

    testWidgets('calls onClear when clear button is pressed', (tester) async {
      bool cleared = false;
      await tester.pumpApp(
        Scaffold(
          body: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (context) => BooksFilterSheet(
                initialOptions: const BookPageOptions(),
                onApply: (_) {},
                onClear: () => cleared = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(cleared, true);
    });

    testWidgets('calls onApply with updated options', (tester) async {
      BookPageOptions? appliedOptions;
      await tester.pumpApp(
        Scaffold(
          body: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (context) => BooksFilterSheet(
                initialOptions: const BookPageOptions(),
                onApply: (options) => appliedOptions = options,
                onClear: () {},
              ),
            ),
          ),
        ),
      );

      // Change year
      await tester.enterText(find.byType(TextField), '2022');

      // Change operator
      await tester.tap(find.text('Equal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Before').last); // The dropdown menu item
      await tester.pumpAndSettle();

      // Select type
      await tester.tap(find.text('Manhwa'));
      await tester.pumpAndSettle();

      // Select sensitive content
      await tester.tap(find.text('Ecchi'));
      await tester.pumpAndSettle();

      // Apply
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(appliedOptions?.publication, 2022);
      expect(appliedOptions?.publicationOperator, 'lt');
      expect(appliedOptions?.type, contains(TypeBook.manhwa));
      expect(appliedOptions?.sensitiveContent, contains('Ecchi'));
    });
  });
}
