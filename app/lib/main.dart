import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/theme.dart';
import 'core/di/injection.dart';
import 'features/authentication/domain/use_cases/auth_service.dart';
import 'features/settings/domain/use_cases/settings_service.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();

  final settingsService = sl<SettingsService>();
  final initialLocation = settingsService.apiUrl == null ? '/welcome' : '/home';
  final router = createAppRouter(initialLocation);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<AuthService>()),
        ChangeNotifierProvider.value(value: settingsService),
      ],
      child: App(router: router),
    ),
  );
}

class App extends StatelessWidget {
  final GoRouter router;
  const App({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gatuno',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('pt')],
    );
  }
}
