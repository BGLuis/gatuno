import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gatuno/features/users/data/data_sources/user_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UserStorage userStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    userStorage = UserStorage();
  });

  group('UserStorage', () {
    test('setSensitiveContentEnabled and isSensitiveContentEnabled', () async {
      await userStorage.setSensitiveContentEnabled(true);
      expect(await userStorage.isSensitiveContentEnabled(), isTrue);

      await userStorage.setSensitiveContentEnabled(false);
      expect(await userStorage.isSensitiveContentEnabled(), isFalse);
    });

    test('isSensitiveContentEnabled should return false if not set', () async {
      expect(await userStorage.isSensitiveContentEnabled(), isFalse);
    });
  });
}
