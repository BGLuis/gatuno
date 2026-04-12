import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/molecules/settings_profile_card.dart';
import 'package:gatuno/shared/components/atoms/app_avatar.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('SettingsProfileCard', () {
    testWidgets('renders name and email when provided', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SettingsProfileCard(
            name: 'John Doe',
            email: 'john@example.com',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.byType(AppAvatar), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('renders only name when email is null', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SettingsProfileCard(name: 'Guest', onTap: () {}),
        ),
      );

      expect(find.text('Guest'), findsOneWidget);
      expect(find.text('john@example.com'), findsNothing);
      expect(find.byType(AppAvatar), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        Scaffold(
          body: SettingsProfileCard(
            name: 'John Doe',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(SettingsProfileCard));
      expect(tapped, isTrue);
    });
  });
}
