import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/welcome/presentation/view_models/welcome_view_model.dart';
import 'package:gatuno/features/settings/domain/use_cases/settings_service.dart';

class MockSettingsService extends Mock implements SettingsService {}

void main() {
  late WelcomeViewModel viewModel;
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockSettingsService = MockSettingsService();
    viewModel = WelcomeViewModel(mockSettingsService);
  });

  group('WelcomeViewModel', () {
    test('validateAndSaveUrl should return false for empty url', () async {
      final result = await viewModel.validateAndSaveUrl('');
      expect(result, isFalse);
      expect(viewModel.error, 'Please enter a URL');
    });

    test('validateAndSaveUrl should save if valid', () async {
      when(
        () => mockSettingsService.validateApiUrl(any()),
      ).thenAnswer((_) async => true);
      when(() => mockSettingsService.setApiUrl(any())).thenAnswer((_) async {});

      final result = await viewModel.validateAndSaveUrl('http://test.com/');

      expect(result, isTrue);
      expect(viewModel.error, isNull);
      verify(
        () => mockSettingsService.validateApiUrl('http://test.com/'),
      ).called(1);
      verify(() => mockSettingsService.setApiUrl('http://test.com')).called(1);
    });

    test(
      'validateAndSaveUrl should return false if service validation fails',
      () async {
        when(
          () => mockSettingsService.validateApiUrl(any()),
        ).thenAnswer((_) async => false);

        final result = await viewModel.validateAndSaveUrl('http://invalid.com');

        expect(result, isFalse);
        expect(viewModel.error, contains('Could not connect'));
        verifyNever(() => mockSettingsService.setApiUrl(any()));
      },
    );
  });
}
