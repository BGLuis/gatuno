import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

Future<void> initTestDI({AuthService? authService}) async {
  await sl.reset();

  sl.registerLazySingleton<AuthService>(() => authService ?? MockAuthService());
}
