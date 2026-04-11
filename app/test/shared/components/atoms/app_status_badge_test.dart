import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_status_badge.dart';

void main() {
  group('AppStatusBadge', () {
    testWidgets('should render label in uppercase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatusBadge(label: 'ready', color: Colors.green),
          ),
        ),
      );

      expect(find.text('READY'), findsOneWidget);
    });

    testWidgets('should use provided color for border and text', (
      tester,
    ) async {
      const testColor = Colors.blue;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatusBadge(label: 'PROCESS', color: testColor),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, testColor.withValues(alpha: 0.2));
      expect(decoration.border?.top.color, testColor.withValues(alpha: 0.5));

      final text = tester.widget<Text>(find.text('PROCESS'));
      expect(text.style?.color, testColor);
    });

    testWidgets('should use custom textColor if provided', (tester) async {
      const testColor = Colors.red;
      const customTextColor = Colors.white;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStatusBadge(
              label: 'ERROR',
              color: testColor,
              textColor: customTextColor,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('ERROR'));
      expect(text.style?.color, customTextColor);
    });
  });
}
