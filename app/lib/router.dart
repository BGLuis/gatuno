import 'package:go_router/go_router.dart';
import 'features/authentication/auth_router.dart';
import 'features/users/users_router.dart';
import 'features/home/home_router.dart';
import 'features/books/books_router.dart';
import 'shared/presentation/error_screen.dart';
import 'shared/components/organisms/navigation_shell.dart';
import 'core/logging/logger.dart';
import 'core/router/router_keys.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [homeBranch, booksBranch, profileBranch],
    ),
    ...authRoutes,
  ],
  errorBuilder: (context, state) {
    AppLogger.e('Router Error: ${state.uri}', state.error, null, 'ROUTER');
    return ErrorScreen(error: state.error);
  },
);
