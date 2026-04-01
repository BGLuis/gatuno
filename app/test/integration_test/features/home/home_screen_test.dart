import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/home/presentation/views/home_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_injection.dart';

void main() {
  late MockAuthService mockAuthService;

  setUp(() async {
    mockAuthService = MockAuthService();
    await initTestDI(authService: mockAuthService);
    // Default stub to avoid Mocktail failures
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);
  });

  testWidgets('HomePage renders correctly as guest', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);

    await tester.pumpApp(const HomePage());
    await tester.pump(); // Allow initState to finish

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Gatuno!'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);
    expect(find.byIcon(Icons.account_circle_outlined), findsNothing);
  });

  testWidgets('HomePage renders correctly as authenticated', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthService.isAuthenticated()).thenAnswer((_) async => true);

    await tester.pumpApp(const HomePage());
    await tester.pump(); // Allow initState to finish

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Gatuno!'), findsOneWidget);
    expect(find.byIcon(Icons.account_circle_outlined), findsOneWidget);
    expect(find.byIcon(Icons.login), findsNothing);
  });

  testWidgets('HomePage login button navigates to signin', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);

    await tester.pumpApp(const HomePage());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    expect(find.text('Signin Page'), findsOneWidget);
  });
}
