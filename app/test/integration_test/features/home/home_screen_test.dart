import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/organisms/navigation_shell.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../helpers/test_injection.dart';
import 'package:gatuno/shared/components/atoms/app_avatar.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockHomeViewModel mockHomeViewModel;
  late MockNavigationViewModel mockNavigationViewModel;

  setUp(() async {
    mockAuthService = MockAuthService();
    mockHomeViewModel = MockHomeViewModel();
    mockNavigationViewModel = MockNavigationViewModel();

    await initTestDI(
      authService: mockAuthService,
      homeViewModel: mockHomeViewModel,
      navigationViewModel: mockNavigationViewModel,
    );

    when(() => mockHomeViewModel.isAuthenticated).thenReturn(true);
    when(() => mockHomeViewModel.isInitialized).thenReturn(true);
    when(() => mockHomeViewModel.displayName).thenReturn('Test User');

    when(() => mockNavigationViewModel.isAuthenticated).thenReturn(true);
    when(() => mockNavigationViewModel.user).thenReturn(null);

    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);
  });

  Future<void> pumpNavigationShell(WidgetTester tester) async {
    FlutterSecureStorage.setMockInitialValues({});

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavigationShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const Text('Home Content'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/books',
                  builder: (context, state) => const Text('Books Content'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const Text('Profile Content'),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/auth/signin',
          builder: (context, state) => const Text('Signin Page'),
        ),
      ],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('NavigationShell renders bottom navigation items', (
    WidgetTester tester,
  ) async {
    when(() => mockNavigationViewModel.isAuthenticated).thenReturn(false);
    await pumpNavigationShell(tester);

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.book), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.text('Home Content'), findsOneWidget);
  });

  testWidgets('NavigationShell shows avatar when authenticated', (
    WidgetTester tester,
  ) async {
    when(() => mockNavigationViewModel.isAuthenticated).thenReturn(true);
    when(() => mockNavigationViewModel.user).thenReturn(
      UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        roles: ['user'],
        maxWeightSensitiveContent: 0,
      ),
    );

    await pumpNavigationShell(tester);

    expect(find.byType(AppAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsNothing);
  });

  testWidgets('NavigationShell navigates between branches', (
    WidgetTester tester,
  ) async {
    when(() => mockNavigationViewModel.isAuthenticated).thenReturn(false);
    await pumpNavigationShell(tester);

    // Tap Books
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();
    expect(find.text('Books Content'), findsOneWidget);

    // Tap Home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Home Content'), findsOneWidget);
  });

  testWidgets(
    'NavigationShell redirects to signin for unauthenticated profile access',
    (WidgetTester tester) async {
      when(() => mockNavigationViewModel.isAuthenticated).thenReturn(false);
      await pumpNavigationShell(tester);

      // Tap Profile (unauthenticated)
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.text('Signin Page'), findsOneWidget);
    },
  );
}
