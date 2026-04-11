import 'package:go_router/go_router.dart';
import 'presentation/views/signin_screen.dart';
import 'presentation/views/signup_screen.dart';
import '../../../core/router/router_keys.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/auth/signin',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const SignInPage(),
  ),
  GoRoute(
    path: '/auth/signup',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const SignUpPage(),
  ),
];
