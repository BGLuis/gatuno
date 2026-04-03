import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/shared/presentation/error_screen.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('renders error title and message', (tester) async {
      await tester.pumpApp(const ErrorScreen());

      final l10n = AppLocalizations.of(
        tester.element(find.byType(ErrorScreen)),
      )!;

      expect(
        find.text(l10n.errorTitle),
        findsNWidgets(2),
      ); // One in AppBar, one in body
      expect(find.text(l10n.errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('back button navigates to home', (tester) async {
      final router = GoRouter(
        initialLocation: '/error',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Text('Home'),
          ),
          GoRoute(
            path: '/error',
            builder: (context, state) => const ErrorScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(ErrorScreen)),
      )!;

      await tester.tap(find.text(l10n.errorBack));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}
