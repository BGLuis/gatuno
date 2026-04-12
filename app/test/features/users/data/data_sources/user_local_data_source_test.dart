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
    // Add tests for other UserStorage methods here when they are implemented
    test('UserStorage exists', () {
      expect(userStorage, isNotNull);
    });
  });
}
