import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/views/welcome_screen.dart';
import 'presentation/view_models/welcome_view_model.dart';
import '../settings/domain/use_cases/settings_service.dart';
import '../../../core/di/injection.dart';

final List<RouteBase> welcomeRoutes = [
  GoRoute(
    path: '/welcome',
    builder: (context, state) => ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(sl<SettingsService>()),
      child: const WelcomePage(),
    ),
  ),
];
