import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthStorage authStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    authStorage = AuthStorage();
  });

  group('AuthStorage', () {
    test('saveTokens and getTokens', () async {
      await authStorage.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );

      expect(await authStorage.getAccessToken(), 'access');
      expect(await authStorage.getRefreshToken(), 'refresh');
    });

    test('clearTokens removes tokens', () async {
      await authStorage.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      await authStorage.clearTokens();

      expect(await authStorage.getAccessToken(), isNull);
      expect(await authStorage.getRefreshToken(), isNull);
    });
  });
}
