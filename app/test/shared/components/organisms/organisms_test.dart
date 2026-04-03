import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/organisms/me_settings_list.dart';
import 'package:gatuno/shared/components/organisms/home_app_bar.dart';
import 'package:gatuno/shared/components/molecules/user_profile_icon.dart';
import 'package:gatuno/shared/components/molecules/login_icon.dart';

void main() {
  group('Organisms', () {
    testWidgets('MeSettingsList renders switch and logout button', (
      tester,
    ) async {
      var switchToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeSettingsList(
              sensitiveContentTitle: 'Sensitive',
              sensitiveContentSubtitle: 'Desc',
              isSensitiveContentEnabled: false,
              onSensitiveContentChanged: (v) => switchToggled = v,
              logoutButton: const Text('LOGOUT_BTN'),
            ),
          ),
        ),
      );

      expect(find.text('Sensitive'), findsOneWidget);
      expect(find.text('Desc'), findsOneWidget);
      expect(find.text('LOGOUT_BTN'), findsOneWidget);

      await tester.tap(find.byType(SwitchListTile));
      expect(switchToggled, isTrue);
    });

    testWidgets('HomeAppBar renders correct icon based on auth', (
      tester,
    ) async {
      // Authenticated
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: HomeAppBar(
              title: 'Title',
              isAuthenticated: true,
              isLoading: false,
              displayName: 'User',
              onProfilePressed: () {},
              onSignInPressed: () {},
              profileTooltip: 'Profile',
              signInTooltip: 'Sign In',
            ),
          ),
        ),
      );
      expect(find.byType(UserProfileIcon), findsOneWidget);
      expect(find.byType(LoginIcon), findsNothing);

      // Guest
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: HomeAppBar(
              title: 'Title',
              isAuthenticated: false,
              isLoading: false,
              displayName: '',
              onProfilePressed: () {},
              onSignInPressed: () {},
              profileTooltip: 'Profile',
              signInTooltip: 'Sign In',
            ),
          ),
        ),
      );
      expect(find.byType(LoginIcon), findsOneWidget);
      expect(find.byType(UserProfileIcon), findsNothing);
    });
  });
}
