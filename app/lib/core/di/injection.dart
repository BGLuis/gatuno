import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/cache_interceptor.dart';
import '../network/interceptors/cookie_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../../features/authentication/authentication_injection.dart';
import '../../features/authentication/domain/use_cases/auth_service.dart';
import '../../features/users/users_injection.dart';
import '../../features/home/home_injection.dart';
import '../../features/books/books_injection.dart';
import '../../features/settings/data/data_sources/settings_local_data_source.dart';
import '../../features/settings/domain/use_cases/settings_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<SettingsStorage>(() => SettingsStorage());
  sl.registerLazySingleton<SettingsService>(
    () => SettingsService(sl<SettingsStorage>(), sl<DioClient>()),
  );

  // Initialize settings (including base URL)
  await sl<SettingsService>().init();

  // Features
  initAuthenticationInjection(sl);
  initUsersInjection(sl);
  initHomeInjection(sl);
  initBooksInjection(sl);

  // Set up interceptors (AuthService is registered in initAuthenticationInjection)
  setupCookieInterceptor(sl<DioClient>());
  await setupCacheInterceptor(sl<DioClient>());
  setupAuthInterceptor(sl<DioClient>(), sl<AuthService>());
  setupLoggingInterceptor(sl<DioClient>());
}
