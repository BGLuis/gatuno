import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/atoms/app_avatar.dart';
import 'package:gatuno/shared/components/atoms/app_clickable_action.dart';
import 'package:gatuno/shared/components/atoms/app_switch.dart';

void main() {
  group('Atoms', () {
    testWidgets('AppAvatar renders initials correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppAvatar(name: 'John Doe')),
        ),
      );

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('AppAvatar renders ? for empty name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppAvatar(name: '')),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('AppAvatar renders skeleton for null name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppAvatar(name: null))),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.text('?'), findsNothing);
    });

    testWidgets('AppClickableAction triggers onPressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppClickableAction(
              tooltip: 'Test',
              onPressed: () => pressed = true,
              child: const Text('Click me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Click me'));
      expect(pressed, isTrue);
    });

    testWidgets('AppSwitch renders and toggles', (tester) async {
      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSwitch(
              title: 'Switch',
              subtitle: 'Subtitle',
              value: value,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      );

      expect(find.text('Switch'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);

      await tester.tap(find.byType(SwitchListTile));
      expect(value, isTrue);
    });
  });
}
