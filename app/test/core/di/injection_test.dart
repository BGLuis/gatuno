import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/di/injection.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/core/network/dio_client.dart';

void main() {
  group('Injection', () {
    test('initDI registers all dependencies', () async {
      // Ensure GetIt is clean
      await sl.reset();

      await initDI();

      expect(sl.isRegistered<DioClient>(), true);
      expect(sl.isRegistered<AuthService>(), true);
    });
  });
}
