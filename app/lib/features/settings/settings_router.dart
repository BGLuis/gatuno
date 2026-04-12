import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/views/settings_screen.dart';
import 'presentation/view_models/settings_view_model.dart';
import '../authentication/domain/use_cases/auth_service.dart';
import '../settings/domain/use_cases/settings_service.dart';
import '../users/presentation/views/me_screen.dart';
import '../users/presentation/view_models/me_view_model.dart';
import '../../../core/di/injection.dart';

final GlobalKey<NavigatorState> settingsNavigatorKey =
    GlobalKey<NavigatorState>();

final StatefulShellBranch settingsBranch = StatefulShellBranch(
  navigatorKey: settingsNavigatorKey,
  routes: [
    GoRoute(
      path: '/settings',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => SettingsViewModel(
          settingsService: sl<SettingsService>(),
          authService: sl<AuthService>(),
        ),
        child: const SettingsPage(),
      ),
      routes: [
        GoRoute(
          path:
              'profile', // Full path will be /settings/profile or use /users/me
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<MeViewModel>(),
            child: const MePage(),
          ),
        ),
      ],
    ),
  ],
);
