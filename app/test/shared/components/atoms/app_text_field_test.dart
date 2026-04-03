import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_text_field.dart';

void main() {
  group('AppTextField', () {
    testWidgets('renders correctly with label', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(controller: controller, label: 'Test Label'),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('updates controller when text is entered', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(controller: controller, label: 'Test Label'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(controller.text, 'Hello');
    });

    testWidgets('obscures text when obscureText is true', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              label: 'Password',
              obscureText: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('shows validation error', (WidgetTester tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextField(
                controller: controller,
                label: 'Email',
                validator: (String? value) =>
                    value == null || value.isEmpty ? 'Error Message' : null,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Error Message'), findsOneWidget);
    });
  });
}
