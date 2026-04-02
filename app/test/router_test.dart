import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/router.dart';
import 'package:gatuno/shared/presentation/error_screen.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/core/di/injection.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';

import 'package:provider/provider.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';

class MockAuthService extends Mock implements AuthService {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

void main() {
  late MockAuthService mockAuthService;
  late MockHomeViewModel mockHomeViewModel;

  setUp(() async {
    await di.sl.reset();
    mockAuthService = MockAuthService();
    mockHomeViewModel = MockHomeViewModel();

    di.sl.registerSingleton<AuthService>(mockAuthService);
    di.sl.registerSingleton<HomeViewModel>(mockHomeViewModel);

    when(() => mockAuthService.authenticated).thenReturn(false);
    when(() => mockAuthService.isInitialized).thenReturn(true);
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);

    when(() => mockHomeViewModel.isAuthenticated).thenReturn(false);
    when(() => mockHomeViewModel.isInitialized).thenReturn(true);
    when(() => mockHomeViewModel.displayName).thenReturn(null);
  });

  tearDown(() async {
    await di.sl.reset();
  });

  testWidgets('appRouter should show ErrorScreen for non-existent route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ChangeNotifierProvider<HomeViewModel>.value(value: mockHomeViewModel),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    appRouter.go('/non-existent');
    await tester.pumpAndSettle();

    expect(find.byType(ErrorScreen), findsOneWidget);
  });
}
