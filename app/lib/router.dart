import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/views/signin_screen.dart';
import 'features/authentication/presentation/views/signup_screen.dart';
import 'features/users/presentation/views/me_screen.dart';
import 'features/users/presentation/view_models/me_view_model.dart';
import 'features/home/presentation/views/home_screen.dart';
import 'features/home/presentation/view_models/home_view_model.dart';
import 'features/books/presentation/views/books_screen.dart';
import 'features/books/presentation/view_models/books_view_model.dart';
import 'shared/presentation/error_screen.dart';
import 'shared/components/organisms/navigation_shell.dart';
import 'core/logging/logger.dart';
import 'core/di/injection.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _booksNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => sl<HomeViewModel>(),
                child: const HomePage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _booksNavigatorKey,
          routes: [
            GoRoute(
              path: '/books',
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => sl<BooksViewModel>(),
                child: const BooksPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/users/me',
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => sl<MeViewModel>(),
                child: const MePage(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/auth/signin',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/auth/signup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignUpPage(),
    ),
  ],
  errorBuilder: (context, state) {
    AppLogger.e('Router Error: ${state.uri}', state.error, null, 'ROUTER');
    return ErrorScreen(error: state.error);
  },
);
