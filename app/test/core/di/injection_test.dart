import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/users/domain/use_cases/user_service.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Injection', () {
    test('initDI registers all dependencies', () async {
      FlutterSecureStorage.setMockInitialValues({});

      // Ensure GetIt is clean
      await sl.reset();

      await initDI();

      expect(sl.isRegistered<DioClient>(), true);
      expect(sl.isRegistered<AuthService>(), true);
      expect(sl.isRegistered<UserService>(), true);
      expect(sl.isRegistered<HomeViewModel>(), true);
    });
  });
}
