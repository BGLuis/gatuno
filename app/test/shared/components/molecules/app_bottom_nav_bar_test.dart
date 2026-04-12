import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/molecules/app_bottom_nav_bar.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('AppBottomNavBar', () {
    testWidgets('renders correctly with given parameters', (tester) async {
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 0,
            onTap: (index) => tappedIndex = index,
            isAuthenticated: false,
          ),
        ),
      );

      // Verify background color and border
      final containerFinder = find.ancestor(
        of: find.byType(BottomAppBar),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      final BuildContext context = tester.element(find.byType(AppBottomNavBar));
      expect(decoration.color, Theme.of(context).scaffoldBackgroundColor);
      expect(decoration.border, isNotNull);
      expect(decoration.border!.top.width, 1.0);
      expect(
        decoration.border!.top.color,
        Theme.of(context).dividerTheme.color ?? Theme.of(context).dividerColor,
      );

      // Verify icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify tap
      await tester.tap(find.byIcon(Icons.book));
      expect(tappedIndex, 1);
    });

    testWidgets('renders settings icon regardless of auth', (tester) async {
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 2,
            onTap: (_) {},
            isAuthenticated: true,
            displayName: 'John Doe',
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('J'), findsNothing);
    });
  });
}
