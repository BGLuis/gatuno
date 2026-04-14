import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/users/presentation/components/molecules/user_profile_header.dart';
import 'package:gatuno/features/home/presentation/components/molecules/user_profile_icon.dart';

void main() {
  group('Molecules', () {
    testWidgets('UserProfileHeader renders name and email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserProfileHeader(
              displayName: 'John Doe',
              email: 'john@example.com',
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('UserProfileIcon renders avatar or skeleton', (tester) async {
      // Test with name
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileIcon(
              displayName: 'John Doe',
              tooltip: 'Profile',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.text('J'), findsOneWidget);

      // Test skeleton (null name)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileIcon(
              displayName: null,
              tooltip: 'Profile',
              onPressed: () {},
            ),
          ),
        ),
      );
      // Should find the skeleton Container
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
