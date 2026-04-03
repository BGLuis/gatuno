import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/organisms/signin_form.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';
import 'package:gatuno/shared/components/atoms/app_text_field.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('SignInForm', () {
    testWidgets('renders all fields and buttons', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SignInForm(onSubmit: (email, password) {}, onSignUp: () {}),
        ),
      );

      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Scaffold(body: SignInForm(onSubmit: (email, password) {})),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('calls onSubmit when form is valid', (
      WidgetTester tester,
    ) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpApp(
        Scaffold(
          body: SignInForm(
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
        'password123',
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(submittedEmail, 'test@example.com');
      expect(submittedPassword, 'password123');
    });

    testWidgets('calls onSignUp when sign up text button is pressed', (
      WidgetTester tester,
    ) async {
      bool signUpPressed = false;

      await tester.pumpApp(
        Scaffold(
          body: SignInForm(
            onSubmit: (email, password) {},
            onSignUp: () => signUpPressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Don\'t have an account? Sign Up'));
      expect(signUpPressed, true);
    });

    testWidgets('shows loading state on button', (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SignInForm(onSubmit: (email, password) {}, isLoading: true),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
