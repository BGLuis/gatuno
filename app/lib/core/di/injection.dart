import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/authentication/authentication_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initDI() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Features
  initAuthenticationInjection(sl);
}
