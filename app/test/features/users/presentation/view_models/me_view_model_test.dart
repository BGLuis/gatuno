import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/users/presentation/view_models/me_view_model.dart';
import 'package:gatuno/features/users/domain/use_cases/user_service.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  late MeViewModel viewModel;
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
    viewModel = MeViewModel(mockUserService);
  });

  group('MeViewModel', () {
    test('initial state should be loading', () {
      expect(viewModel.isLoading, isTrue);
      expect(viewModel.user, isNull);
    });

    test('init should load user and settings', () async {
      final user = UserModel(
        id: '1',
        email: 'test@example.com',
        roles: ['user'],
        maxWeightSensitiveContent: 5,
      );

      when(
        () => mockUserService.getCurrentUser(),
      ).thenAnswer((_) async => user);
      when(
        () => mockUserService.isSensitiveContentEnabled(),
      ).thenAnswer((_) async => true);

      await viewModel.init();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.user, equals(user));
      expect(viewModel.isSensitiveContentEnabled, isTrue);
    });

    test(
      'toggleSensitiveContent should update state and call service',
      () async {
        when(
          () => mockUserService.setSensitiveContentEnabled(any()),
        ).thenAnswer((_) async {});

        await viewModel.toggleSensitiveContent(true);

        expect(viewModel.isSensitiveContentEnabled, isTrue);
        verify(
          () => mockUserService.setSensitiveContentEnabled(true),
        ).called(1);
      },
    );

    test('logout should call service', () async {
      when(() => mockUserService.logout()).thenAnswer((_) async {});

      await viewModel.logout();

      verify(() => mockUserService.logout()).called(1);
    });
  });
}
