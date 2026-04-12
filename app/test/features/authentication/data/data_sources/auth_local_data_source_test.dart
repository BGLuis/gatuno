import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late AuthStorage authStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    authStorage = AuthStorage();
  });

  group('AuthStorage', () {
    test('saveToken stores access token', () async {
      await authStorage.saveToken('token');
      expect(await authStorage.getToken(), 'token');
    });

    test('clearToken removes stored token', () async {
      await authStorage.saveToken('token');
      await authStorage.clearToken();
      expect(await authStorage.getToken(), isNull);
    });
  });
}
