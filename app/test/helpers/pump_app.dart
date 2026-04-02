import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';
import 'package:gatuno/features/users/presentation/view_models/me_view_model.dart';
import 'package:gatuno/core/di/injection.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    FlutterSecureStorage.setMockInitialValues({});

    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => widget),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),
        GoRoute(
          path: '/auth/signin',
          builder: (context, state) =>
              const Scaffold(body: Text('Signin Page')),
        ),
      ],
    );

    final providers = [
      if (sl.isRegistered<AuthService>())
        ChangeNotifierProvider.value(value: sl<AuthService>()),
      if (sl.isRegistered<HomeViewModel>())
        ChangeNotifierProvider.value(value: sl<HomeViewModel>()),
      if (sl.isRegistered<MeViewModel>())
        ChangeNotifierProvider.value(value: sl<MeViewModel>()),
    ];

    Widget current = MaterialApp.router(
      routerConfig: testRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('pt')],
    );

    if (providers.isNotEmpty) {
      current = MultiProvider(providers: providers, child: current);
    }

    return pumpWidget(current);
  }
}
