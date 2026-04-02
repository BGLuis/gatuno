import 'package:get_it/get_it.dart';
import '../authentication/domain/use_cases/auth_service.dart';
import '../users/domain/use_cases/user_service.dart';
import 'presentation/view_models/home_view_model.dart';

void initHomeInjection(GetIt sl) {
  // View Models
  sl.registerFactory<HomeViewModel>(
    () => HomeViewModel(sl<AuthService>(), sl<UserService>()),
  );
}
