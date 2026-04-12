import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:gatuno/features/settings/domain/use_cases/settings_service.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';

class MockSettingsService extends Mock implements SettingsService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late SettingsViewModel viewModel;
  late MockSettingsService mockSettingsService;
  late MockAuthService mockAuthService;

  setUp(() {
    mockSettingsService = MockSettingsService();
    mockAuthService = MockAuthService();

    // When listening, we need to stub addListener/removeListener
    when(() => mockSettingsService.addListener(any())).thenAnswer((_) {});
    when(() => mockSettingsService.removeListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.addListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.removeListener(any())).thenAnswer((_) {});

    viewModel = SettingsViewModel(
      settingsService: mockSettingsService,
      authService: mockAuthService,
    );
  });

  group('SettingsViewModel', () {
    test('should expose values from services', () {
      final user = UserModel(
        id: '1',
        email: 'test@test.com',
        roles: ['user'],
        maxWeightSensitiveContent: 0,
      );

      when(() => mockSettingsService.apiUrl).thenReturn('http://test.com');
      when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(true);
      when(() => mockAuthService.authenticated).thenReturn(true);
      when(() => mockAuthService.currentUser).thenReturn(user);

      expect(viewModel.apiUrl, 'http://test.com');
      expect(viewModel.sensitiveContentEnabled, isTrue);
      expect(viewModel.isAuthenticated, isTrue);
      expect(viewModel.user, equals(user));
    });

    test('setSensitiveContentEnabled should call service', () async {
      when(
        () => mockSettingsService.setSensitiveContentEnabled(any()),
      ).thenAnswer((_) async {});

      await viewModel.setSensitiveContentEnabled(false);

      verify(
        () => mockSettingsService.setSensitiveContentEnabled(false),
      ).called(1);
    });

    test('updateApiUrl should validate and update if valid', () async {
      when(
        () => mockSettingsService.validateApiUrl(any()),
      ).thenAnswer((_) async => true);
      when(() => mockSettingsService.setApiUrl(any())).thenAnswer((_) async {});

      final result = await viewModel.updateApiUrl('http://valid.com');

      expect(result, isTrue);
      verify(
        () => mockSettingsService.validateApiUrl('http://valid.com'),
      ).called(1);
      verify(() => mockSettingsService.setApiUrl('http://valid.com')).called(1);
    });

    test('updateApiUrl should return false if invalid', () async {
      when(
        () => mockSettingsService.validateApiUrl(any()),
      ).thenAnswer((_) async => false);

      final result = await viewModel.updateApiUrl('http://invalid.com');

      expect(result, isFalse);
      verify(
        () => mockSettingsService.validateApiUrl('http://invalid.com'),
      ).called(1);
      verifyNever(() => mockSettingsService.setApiUrl(any()));
    });
  });
}
