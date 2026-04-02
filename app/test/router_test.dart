import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/router.dart';
import 'package:gatuno/shared/presentation/error_screen.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/core/di/injection.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  setUpAll(() async {
    final mockAuthService = MockAuthService();
    di.sl.registerSingleton<AuthService>(mockAuthService);
    when(
      () => mockAuthService.isAuthenticated(),
    ).thenAnswer((_) async => false);
  });

  tearDownAll(() async {
    await di.sl.reset();
  });

  testWidgets('appRouter should show ErrorScreen for non-existent route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    appRouter.go('/non-existent');
    await tester.pumpAndSettle();

    expect(find.byType(ErrorScreen), findsOneWidget);
  });
}
