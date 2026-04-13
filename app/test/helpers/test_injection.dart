import 'package:dio/dio.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:gatuno/features/users/data/data_sources/user_local_data_source.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';
import 'package:gatuno/features/users/presentation/view_models/me_view_model.dart';
import 'package:gatuno/shared/presentation/view_models/navigation_view_model.dart';
import 'package:gatuno/features/settings/domain/use_cases/settings_service.dart';
import 'package:gatuno/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthStorage extends Mock implements AuthStorage {}

class MockUserStorage extends Mock implements UserStorage {}

class MockSettingsService extends Mock implements SettingsService {}

class MockSettingsStorage extends Mock implements SettingsStorage {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

class MockNavigationViewModel extends Mock implements NavigationViewModel {}

class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {
  @override
  final Dio dio = MockDio();
}

Future<void> initTestDI({
  AuthService? authService,
  AuthStorage? authStorage,
  UserStorage? userStorage,
  SettingsService? settingsService,
  SettingsStorage? settingsStorage,
  HomeViewModel? homeViewModel,
  MeViewModel? meViewModel,
  NavigationViewModel? navigationViewModel,
  DioClient? dioClient,
}) async {
  await sl.reset();

  final dc = dioClient ?? MockDioClient();
  sl.registerLazySingleton<DioClient>(() => dc);

  final storage = authStorage ?? MockAuthStorage();
  if (authStorage == null) {
    when(() => storage.getToken()).thenAnswer((_) async => null);
  }
  sl.registerLazySingleton<AuthStorage>(() => storage);

  sl.registerLazySingleton<UserStorage>(() => userStorage ?? MockUserStorage());

  final sStorage = settingsStorage ?? MockSettingsStorage();
  sl.registerLazySingleton<SettingsStorage>(() => sStorage);

  final sService = settingsService ?? MockSettingsService();
  if (settingsService == null) {
    when(() => sService.sensitiveContentEnabled).thenReturn(false);
    when(() => sService.apiUrl).thenReturn(null);
  }
  sl.registerLazySingleton<SettingsService>(() => sService);

  sl.registerLazySingleton<AuthService>(() => authService ?? MockAuthService());

  if (homeViewModel != null) {
    sl.registerLazySingleton<HomeViewModel>(() => homeViewModel);
  }

  if (meViewModel != null) {
    sl.registerLazySingleton<MeViewModel>(() => meViewModel);
  }

  final navVM = navigationViewModel ?? MockNavigationViewModel();
  if (navigationViewModel == null) {
    when(() => navVM.isAuthenticated).thenReturn(false);
    when(() => navVM.user).thenReturn(null);
  }
  sl.registerFactory<NavigationViewModel>(() => navVM);
}
