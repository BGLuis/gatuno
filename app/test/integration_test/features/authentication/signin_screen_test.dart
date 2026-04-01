import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/presentation/views/signin_screen.dart';
import 'package:gatuno/shared/components/organisms/signin_form.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_injection.dart';

void main() {
  late MockAuthService mockAuthService;

  setUp(() async {
    mockAuthService = MockAuthService();
    await initTestDI(authService: mockAuthService);
  });

  testWidgets('SignInPage renders correctly', (WidgetTester tester) async {
    await tester.pumpApp(const SignInPage());

    expect(find.text('Gatuno'), findsOneWidget);
    expect(find.byType(SignInForm), findsOneWidget);
  });

  testWidgets('SignInPage redirects to home on successful signIn', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.signIn('test@example.com', 'password'),
    ).thenAnswer((_) async => true);

    await tester.pumpApp(const SignInPage());

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'password',
    );

    await tester.tap(find.text('SIGN IN'));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('SignInPage shows SnackBar on failed signIn', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.signIn('test@example.com', 'wrong'),
    ).thenThrow(Exception('Invalid credentials'));

    await tester.pumpApp(const SignInPage());

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'test@example.com',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'wrong');

    await tester.tap(find.text('SIGN IN'));
    await tester.pump(); // Start signIn
    await tester.pump(); // Show snackbar

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Exception: Invalid credentials'), findsOneWidget);
  });
}
