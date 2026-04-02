import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/home/presentation/views/home_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_injection.dart';

import 'package:gatuno/shared/components/molecules/login_icon.dart';
import 'package:gatuno/shared/components/molecules/user_profile_icon.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockHomeViewModel mockHomeViewModel;

  setUp(() async {
    mockAuthService = MockAuthService();
    mockHomeViewModel = MockHomeViewModel();

    await initTestDI(
      authService: mockAuthService,
      homeViewModel: mockHomeViewModel,
    );

    when(() => mockAuthService.authenticated).thenReturn(false);
    when(() => mockAuthService.isInitialized).thenReturn(true);
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);

    when(() => mockHomeViewModel.isAuthenticated).thenReturn(false);
    when(() => mockHomeViewModel.isInitialized).thenReturn(true);
    when(() => mockHomeViewModel.displayName).thenReturn(null);
  });

  testWidgets('HomePage renders correctly as guest', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(const HomePage());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Gatuno!'), findsOneWidget);
    expect(find.byType(LoginIcon), findsOneWidget);
    expect(find.byType(UserProfileIcon), findsNothing);
  });

  testWidgets('HomePage renders correctly as authenticated', (
    WidgetTester tester,
  ) async {
    when(() => mockHomeViewModel.isAuthenticated).thenReturn(true);
    when(() => mockHomeViewModel.displayName).thenReturn('Test');

    await tester.pumpApp(const HomePage());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome to Gatuno!'), findsOneWidget);
    expect(find.byType(UserProfileIcon), findsOneWidget);
    expect(find.byType(LoginIcon), findsNothing);
  });

  testWidgets('HomePage login button navigates to signin', (
    WidgetTester tester,
  ) async {
    await tester.pumpApp(const HomePage());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(LoginIcon));
    await tester.pumpAndSettle();

    expect(find.text('Signin Page'), findsOneWidget);
  });
}
