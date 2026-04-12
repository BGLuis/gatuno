import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/shared/components/organisms/navigation_shell.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/core/router/router_keys.dart';
import '../../../helpers/test_injection.dart';

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

    when(() => mockAuthService.authenticated).thenReturn(false);
    when(() => mockAuthService.isInitialized).thenReturn(true);
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);

    when(() => mockHomeViewModel.isAuthenticated).thenReturn(false);
    when(() => mockHomeViewModel.isInitialized).thenReturn(true);
    when(() => mockHomeViewModel.displayName).thenReturn(null);
  });

  Future<void> pumpNavigationShell(WidgetTester tester) async {
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
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
                  path: '/settings',
                  builder: (context, state) => const Text('Settings Content'),
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
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.text('Home Content'), findsOneWidget);
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

    // Tap Settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings Content'), findsOneWidget);

    // Tap Home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Home Content'), findsOneWidget);
  });
}
