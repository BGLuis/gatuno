import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders button with correct text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Click Me', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when clicked', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Click Me', onPressed: () => pressed = true),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, true);
    });

    testWidgets(
      'shows loading indicator and disables button when isLoading is true',
      (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Click Me',
                onPressed: () => pressed = true,
                isLoading: true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Click Me'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        expect(pressed, false);
      },
    );
  });
}
