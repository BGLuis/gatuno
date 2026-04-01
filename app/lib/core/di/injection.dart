import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../../features/authentication/authentication_injection.dart';
import '../../features/authentication/domain/use_cases/auth_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Features
  initAuthenticationInjection(sl);

  // Set up interceptors (AuthService is registered in initAuthenticationInjection)
  setupAuthInterceptor(sl<DioClient>(), sl<AuthService>());
}
