import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/presentation/view_models/signin_view_model.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late SignInViewModel viewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    viewModel = SignInViewModel(mockAuthService);
  });

  group('SignInViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('signIn success updates state correctly', () async {
      when(
        () => mockAuthService.signIn('test@example.com', 'password'),
      ).thenAnswer((_) async => true);

      final success = await viewModel.signIn('test@example.com', 'password');

      expect(success, true);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('signIn failure updates state correctly', () async {
      when(
        () => mockAuthService.signIn('test@example.com', 'wrong'),
      ).thenThrow(Exception('Invalid credentials'));

      final success = await viewModel.signIn('test@example.com', 'wrong');

      expect(success, false);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, 'Exception: Invalid credentials');
    });

    test('clearError resets error message', () {
      when(
        () => mockAuthService.signIn('test@example.com', 'wrong'),
      ).thenThrow(Exception('Error'));

      viewModel.signIn('test@example.com', 'wrong');
      viewModel.clearError();

      expect(viewModel.errorMessage, null);
    });
  });
}
