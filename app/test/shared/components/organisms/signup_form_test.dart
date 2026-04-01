import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/organisms/signup_form.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';
import 'package:gatuno/shared/components/atoms/app_text_field.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('SignUpForm', () {
    testWidgets('renders all fields and buttons', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SignUpForm(onSubmit: (email, password) {}, onSignIn: () {}),
        ),
      );

      expect(find.byType(AppTextField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('Already have an account? Sign In'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(body: SignUpForm(onSubmit: (email, password) {})),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('shows strong password validation errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(body: SignUpForm(onSubmit: (email, password) {})),
      );

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Email'),
        'test@example.com',
      );

      // Too short
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'short',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );

      // No uppercase
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'lowercase1!',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(
        find.text('Password must contain at least one uppercase letter'),
        findsOneWidget,
      );

      // No number
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'Uppercase!',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(
        find.text('Password must contain at least one number'),
        findsOneWidget,
      );

      // No symbol
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'Uppercase1',
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(
        find.text('Password must contain at least one symbol'),
        findsOneWidget,
      );
    });

    testWidgets('shows password mismatch error', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(body: SignUpForm(onSubmit: (email, password) {})),
      );

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Confirm Password'),
        'Different123!',
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('calls onSubmit when form is valid', (
      WidgetTester tester,
    ) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpApp(
        Scaffold(
          body: SignUpForm(
            onSubmit: (String email, String password) {
              submittedEmail = email;
              submittedPassword = password;
            },
          ),
        ),
      );

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'Password123!',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Confirm Password'),
        'Password123!',
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(submittedEmail, 'test@example.com');
      expect(submittedPassword, 'Password123!');
    });

    testWidgets('calls onSignIn when sign in text button is pressed', (
      WidgetTester tester,
    ) async {
      bool signInPressed = false;

      await tester.pumpApp(
        Scaffold(
          body: SignUpForm(
            onSubmit: (email, password) {},
            onSignIn: () => signInPressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Already have an account? Sign In'));
      expect(signInPressed, true);
    });
  });
}
