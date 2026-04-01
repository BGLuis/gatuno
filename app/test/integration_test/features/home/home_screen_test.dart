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
  });

  testWidgets('HomePage renders correctly', (WidgetTester tester) async {
    await tester.pumpApp(const HomePage());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Gatuno!'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('HomePage logout button navigates to signin', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthService.logout()).thenAnswer((_) async => {});

    await tester.pumpApp(const HomePage());

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('Signin Page'), findsOneWidget);
    verify(() => mockAuthService.logout()).called(1);
  });
}
