import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:gatuno/features/users/data/data_sources/user_local_data_source.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';
import 'package:gatuno/features/users/presentation/view_models/me_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthStorage extends Mock implements AuthStorage {}

class MockUserStorage extends Mock implements UserStorage {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

Future<void> initTestDI({
  AuthService? authService,
  AuthStorage? authStorage,
  UserStorage? userStorage,
  HomeViewModel? homeViewModel,
  MeViewModel? meViewModel,
}) async {
  await sl.reset();

  final storage = authStorage ?? MockAuthStorage();
  if (authStorage == null) {
    when(() => storage.getAccessToken()).thenAnswer((_) async => null);
  }
  sl.registerLazySingleton<AuthStorage>(() => storage);

  sl.registerLazySingleton<UserStorage>(() => userStorage ?? MockUserStorage());

  sl.registerLazySingleton<AuthService>(() => authService ?? MockAuthService());

  if (homeViewModel != null) {
    sl.registerLazySingleton<HomeViewModel>(() => homeViewModel);
  }

  if (meViewModel != null) {
    sl.registerLazySingleton<MeViewModel>(() => meViewModel);
  }
}
