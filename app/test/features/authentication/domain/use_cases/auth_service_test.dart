import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/authentication/domain/repositories/auth_repository.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:gatuno/features/authentication/domain/entities/auth_tokens.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  late AuthService authService;
  late MockAuthRepository mockAuthRepository;
  late MockAuthStorage mockAuthStorage;

  setUpAll(() {
    registerFallbackValue(AuthTokens(accessToken: '', refreshToken: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthStorage = MockAuthStorage();

    // Default mock behavior for constructor's _initAuth
    when(() => mockAuthStorage.getAccessToken()).thenAnswer((_) async => null);

    authService = AuthService(mockAuthRepository, mockAuthStorage);
  });

  final tTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');

  group('AuthService', () {
    test(
      'signIn calls repository, saves tokens and notifies listeners',
      () async {
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        when(
          () => mockAuthRepository.signIn(any(), any()),
        ).thenAnswer((_) async => tTokens);
        when(
          () => mockAuthStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async => {});

        final result = await authService.signIn('test@example.com', 'password');

        expect(result, true);
        expect(authService.authenticated, true);
        expect(notificationCount, greaterThan(0));
        verify(
          () => mockAuthRepository.signIn('test@example.com', 'password'),
        ).called(1);
        verify(
          () => mockAuthStorage.saveTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
          ),
        ).called(1);
      },
    );

    test(
      'logout calls repository, clears tokens and notifies listeners',
      () async {
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        when(
          () => mockAuthStorage.getRefreshToken(),
        ).thenAnswer((_) async => 'refresh_token');
        when(() => mockAuthRepository.logout(any())).thenAnswer((_) async {});
        when(() => mockAuthStorage.clearTokens()).thenAnswer((_) async => {});

        await authService.logout();

        expect(authService.authenticated, false);
        expect(notificationCount, greaterThan(0));
        verify(() => mockAuthRepository.logout('refresh_token')).called(1);
        verify(() => mockAuthStorage.clearTokens()).called(1);
      },
    );

    test('isAuthenticated returns true when token exists', () async {
      when(
        () => mockAuthStorage.getAccessToken(),
      ).thenAnswer((_) async => 'token');

      final result = await authService.isAuthenticated();

      expect(result, true);
      expect(authService.authenticated, true);
    });

    test(
      'performTokenRefresh updates tokens and notifies on success',
      () async {
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        when(
          () => mockAuthStorage.getRefreshToken(),
        ).thenAnswer((_) async => 'old_refresh');
        when(
          () => mockAuthRepository.refreshToken(any()),
        ).thenAnswer((_) async => tTokens);
        when(
          () => mockAuthStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        ).thenAnswer((_) async => {});

        await authService.performTokenRefresh();

        expect(authService.authenticated, true);
        expect(notificationCount, greaterThan(0));
        verify(() => mockAuthRepository.refreshToken('old_refresh')).called(1);
      },
    );
  });
}
