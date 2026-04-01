import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/presentation/view_models/signup_view_model.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late SignUpViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = SignUpViewModel(mockAuthService);
  });

  group('SignUpViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('signUp success updates state correctly', () async {
      when(
        () => mockAuthService.signUp('test@example.com', 'Password123!'),
      ).thenAnswer((_) async => true);

      final success = await viewModel.signUp(
        'test@example.com',
        'Password123!',
      );

      expect(success, true);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('signUp failure updates state correctly', () async {
      when(
        () => mockAuthService.signUp(any(), any()),
      ).thenThrow(Exception('Signup failed'));

      final success = await viewModel.signUp(
        'test@example.com',
        'Password123!',
      );

      expect(success, false);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'Exception: Signup failed');
    });

    test('clearError resets error message', () {
      when(
        () => mockAuthService.signUp(any(), any()),
      ).thenThrow(Exception('Error'));

      viewModel.signUp('test@example.com', 'Password123!');
      viewModel.clearError();

      expect(viewModel.errorMessage, null);
    });
  });
}
