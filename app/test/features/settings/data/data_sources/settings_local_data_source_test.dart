import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gatuno/features/settings/data/data_sources/settings_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SettingsStorage settingsStorage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    settingsStorage = SettingsStorage();
  });

  group('SettingsStorage', () {
    test('setApiUrl and getApiUrl', () async {
      await settingsStorage.setApiUrl('http://test.com');
      expect(await settingsStorage.getApiUrl(), 'http://test.com');
    });

    test('setSensitiveContentEnabled and isSensitiveContentEnabled', () async {
      await settingsStorage.setSensitiveContentEnabled(true);
      expect(await settingsStorage.isSensitiveContentEnabled(), isTrue);

      await settingsStorage.setSensitiveContentEnabled(false);
      expect(await settingsStorage.isSensitiveContentEnabled(), isFalse);
    });

    test('isSensitiveContentEnabled should return false if not set', () async {
      expect(await settingsStorage.isSensitiveContentEnabled(), isFalse);
    });
  });
}
