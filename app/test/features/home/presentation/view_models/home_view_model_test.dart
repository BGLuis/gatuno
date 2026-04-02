import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/home/presentation/view_models/home_view_model.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/users/domain/use_cases/user_service.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserService extends Mock implements UserService {}

void main() {
  late HomeViewModel viewModel;
  late MockAuthService mockAuthService;
  late MockUserService mockUserService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserService = MockUserService();

    when(() => mockAuthService.addListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.removeListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.authenticated).thenReturn(false);
    when(() => mockAuthService.isInitialized).thenReturn(true);

    viewModel = HomeViewModel(mockAuthService, mockUserService);
  });

  group('HomeViewModel', () {
    test('should reflect auth status from service', () {
      expect(viewModel.isAuthenticated, isFalse);
      expect(viewModel.isInitialized, isTrue);
    });

    test('should load user when authenticated', () async {
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        roles: ['user'],
        maxWeightSensitiveContent: 5,
        name: 'Test',
      );

      when(() => mockAuthService.authenticated).thenReturn(true);
      when(
        () => mockUserService.getCurrentUser(),
      ).thenAnswer((_) async => user);

      // Re-initialize to trigger _loadUser
      viewModel = HomeViewModel(mockAuthService, mockUserService);

      // Wait for async load
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.isAuthenticated, isTrue);
      expect(viewModel.displayName, equals('Test'));
    });

    test('displayName should be null when not authenticated', () {
      expect(viewModel.displayName, isNull);
    });
  });
}
