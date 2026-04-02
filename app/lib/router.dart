import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/views/signin_screen.dart';
import 'features/authentication/presentation/views/signup_screen.dart';
import 'features/users/presentation/views/me_screen.dart';
import 'features/users/presentation/view_models/me_view_model.dart';
import 'features/home/presentation/views/home_screen.dart';
import 'features/home/presentation/view_models/home_view_model.dart';
import 'shared/presentation/error_screen.dart';
import 'core/logging/logger.dart';
import 'core/di/injection.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => sl<HomeViewModel>(),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/auth/signin',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/users/me',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => sl<MeViewModel>(),
        child: const MePage(),
      ),
    ),
  ],
  errorBuilder: (context, state) {
    AppLogger.e('Router Error: ${state.uri}', state.error, null, 'ROUTER');
    return ErrorScreen(error: state.error);
  },
);
