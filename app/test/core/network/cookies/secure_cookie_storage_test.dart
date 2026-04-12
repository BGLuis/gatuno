import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/network/cookies/secure_cookie_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  late SecureCookieStorage storage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = SecureCookieStorage();
  });

  group('SecureCookieStorage', () {
    test('write and read should persist values', () async {
      await storage.write('test_key', 'test_value');
      final value = await storage.read('test_key');
      expect(value, 'test_value');
    });

    test('delete should remove value', () async {
      await storage.write('test_key', 'test_value');
      await storage.delete('test_key');
      final value = await storage.read('test_key');
      expect(value, isNull);
    });

    test('deleteAll should remove multiple values', () async {
      await storage.write('key1', 'val1');
      await storage.write('key2', 'val2');

      await storage.deleteAll(['key1', 'key2']);

      expect(await storage.read('key1'), isNull);
      expect(await storage.read('key2'), isNull);
    });

    test('init should not throw', () async {
      expect(() => storage.init(true, false), returnsNormally);
    });
  });
}
