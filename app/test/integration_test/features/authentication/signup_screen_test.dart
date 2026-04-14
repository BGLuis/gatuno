import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/presentation/views/signup_screen.dart';
import 'package:gatuno/features/authentication/presentation/components/organisms/signup_form.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_injection.dart';

void main() {
  late MockAuthService mockAuthService;

  setUp(() async {
    mockAuthService = MockAuthService();
    await initTestDI(authService: mockAuthService);
  });

  testWidgets('SignUpPage renders correctly', (WidgetTester tester) async {
    await tester.pumpApp(const SignUpPage());

    expect(find.text('Join Gatuno'), findsOneWidget);
    expect(find.byType(SignUpForm), findsOneWidget);
  });

  testWidgets('SignUpPage redirects to home on successful signup', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.signUp('test@example.com', 'Password123!'),
    ).thenAnswer((_) async => true);

    await tester.pumpApp(const SignUpPage());

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'Password123!',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Confirm Password'),
      'Password123!',
    );

    await tester.tap(find.text('CREATE ACCOUNT'));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('SignUpPage shows SnackBar on failed signup', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.signUp(any(), any()),
    ).thenThrow(Exception('Signup failed'));

    await tester.pumpApp(const SignUpPage());

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'Password123!',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Confirm Password'),
      'Password123!',
    );

    await tester.tap(find.text('CREATE ACCOUNT'));
    await tester.pump(); // Start signup
    await tester.pump(); // Show snackbar

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Exception: Signup failed'), findsOneWidget);
  });
}
