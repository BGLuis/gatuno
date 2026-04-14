import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/presentation/components/templates/auth_template.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('AuthTemplate', () {
    testWidgets('renders logo, title, and form', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AuthTemplate(
            logo: const Icon(Icons.logo_dev, key: Key('logo')),
            title: const Text('Welcome', key: Key('title')),
            form: const Text('Form Area', key: Key('form')),
          ),
        ),
      );

      expect(find.byKey(const Key('logo')), findsOneWidget);
      expect(find.byKey(const Key('title')), findsOneWidget);
      expect(find.byKey(const Key('form')), findsOneWidget);
    });

    testWidgets('is scrollable', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: AuthTemplate(
            logo: Container(height: 500, color: Colors.red),
            title: const Text('Welcome'),
            form: Container(height: 500, color: Colors.blue),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Should be able to scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump();
    });
  });
}
