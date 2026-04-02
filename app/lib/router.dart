import 'package:go_router/go_router.dart';
import 'features/authentication/presentation/views/signin_screen.dart';
import 'features/authentication/presentation/views/signup_screen.dart';
import 'features/home/presentation/views/home_screen.dart';
import 'shared/presentation/error_screen.dart';
import 'core/logging/logger.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/auth/signin',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
  errorBuilder: (context, state) {
    AppLogger.e('Router Error: ${state.uri}', state.error, null, 'ROUTER');
    return ErrorScreen(error: state.error);
  },
);
