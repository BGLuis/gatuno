import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_loading_indicator.dart';

void main() {
  group('AppLoadingIndicator', () {
    testWidgets('renders CircularProgressIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLoadingIndicator())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('respects custom size', (WidgetTester tester) async {
      const double customSize = 42.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingIndicator(size: customSize)),
        ),
      );

      final SizedBox sizedBox = tester.widget(find.byType(SizedBox));
      expect(sizedBox.height, customSize);
      expect(sizedBox.width, customSize);
    });

    testWidgets('respects custom color', (WidgetTester tester) async {
      const Color customColor = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingIndicator(color: customColor)),
        ),
      );

      final CircularProgressIndicator indicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, customColor);
    });

    testWidgets('uses theme primary color by default', (
      WidgetTester tester,
    ) async {
      const Color primaryColor = Colors.purple;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          ),
          home: const Scaffold(body: AppLoadingIndicator()),
        ),
      );

      final CircularProgressIndicator indicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      // In ThemeData.fromSeed, primary color might be slightly different from seed color,
      // but it will be the one from the theme.
      final theme = Theme.of(tester.element(find.byType(AppLoadingIndicator)));
      expect(indicator.color, theme.colorScheme.primary);
    });
  });
}
