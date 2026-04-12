import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:gatuno/features/settings/domain/use_cases/settings_service.dart';
import 'package:gatuno/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class MockSettingsStorage extends Mock implements SettingsStorage {}

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late SettingsService settingsService;
  late MockSettingsStorage mockStorage;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockStorage = MockSettingsStorage();
    mockDioClient = MockDioClient();
    mockDio = MockDio();

    when(() => mockDioClient.dio).thenReturn(mockDio);
    when(() => mockDio.options).thenReturn(BaseOptions());

    settingsService = SettingsService(mockStorage, mockDioClient);
  });

  group('SettingsService', () {
    test('init should load saved settings', () async {
      when(
        () => mockStorage.getApiUrl(),
      ).thenAnswer((_) async => 'http://test.com');
      when(
        () => mockStorage.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => true);
      when(() => mockDioClient.updateBaseUrl(any())).thenAnswer((_) {});

      await settingsService.init();

      expect(settingsService.apiUrl, 'http://test.com');
      expect(settingsService.sensitiveContentEnabled, isTrue);
      expect(settingsService.isInitialized, isTrue);
      verify(() => mockDioClient.updateBaseUrl('http://test.com')).called(1);
    });

    test('setApiUrl should update storage and dio client', () async {
      when(() => mockStorage.setApiUrl(any())).thenAnswer((_) async {});
      when(() => mockDioClient.updateBaseUrl(any())).thenAnswer((_) {});

      await settingsService.setApiUrl('http://new.com');

      expect(settingsService.apiUrl, 'http://new.com');
      verify(() => mockStorage.setApiUrl('http://new.com')).called(1);
      verify(() => mockDioClient.updateBaseUrl('http://new.com')).called(1);
    });

    test('setSensitiveContentEnabled should update storage', () async {
      when(
        () => mockStorage.setSensitiveContentEnabled(any()),
      ).thenAnswer((_) async {});

      await settingsService.setSensitiveContentEnabled(true);

      expect(settingsService.sensitiveContentEnabled, isTrue);
      verify(() => mockStorage.setSensitiveContentEnabled(true)).called(1);
    });
  });
}
