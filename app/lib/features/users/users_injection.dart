import 'package:get_it/get_it.dart';
import '../authentication/domain/use_cases/auth_service.dart';
import 'data/data_sources/user_local_data_source.dart';
import 'domain/use_cases/user_service.dart';
import 'presentation/view_models/me_view_model.dart';

void initUsersInjection(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<UserStorage>(() => UserStorage());

  // Use Cases
  sl.registerLazySingleton<UserService>(
    () => UserService(sl<AuthService>(), sl<UserStorage>()),
  );

  // View Models
  sl.registerFactory<MeViewModel>(() => MeViewModel(sl<UserService>()));
}
