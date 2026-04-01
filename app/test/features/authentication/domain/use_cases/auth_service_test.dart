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
    authService = AuthService(mockAuthRepository, mockAuthStorage);
  });

  final tTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');

  group('AuthService', () {
    test('signIn calls repository and saves tokens', () async {
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
      verify(
        () => mockAuthRepository.signIn('test@example.com', 'password'),
      ).called(1);
      verify(
        () => mockAuthStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('signUp calls repository and then signIn', () async {
      when(
        () => mockAuthRepository.signUp(any(), any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockAuthRepository.signIn(any(), any()),
      ).thenAnswer((_) async => tTokens);
      when(
        () => mockAuthStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async => {});

      final result = await authService.signUp('test@example.com', 'password');

      expect(result, true);
      verify(
        () => mockAuthRepository.signUp('test@example.com', 'password'),
      ).called(1);
      verify(
        () => mockAuthRepository.signIn('test@example.com', 'password'),
      ).called(1);
    });

    test('logout clears tokens', () async {
      when(() => mockAuthStorage.clearTokens()).thenAnswer((_) async => {});

      await authService.logout();

      verify(() => mockAuthStorage.clearTokens()).called(1);
    });

    test('isAuthenticated returns true when token exists', () async {
      when(
        () => mockAuthStorage.getAccessToken(),
      ).thenAnswer((_) async => 'token');

      final result = await authService.isAuthenticated();

      expect(result, true);
    });

    test('isAuthenticated returns false when token is null or empty', () async {
      when(
        () => mockAuthStorage.getAccessToken(),
      ).thenAnswer((_) async => null);
      expect(await authService.isAuthenticated(), false);

      when(() => mockAuthStorage.getAccessToken()).thenAnswer((_) async => '');
      expect(await authService.isAuthenticated(), false);
    });

    test('performTokenRefresh updates tokens on success', () async {
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

      verify(() => mockAuthRepository.refreshToken('old_refresh')).called(1);
      verify(
        () => mockAuthStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('performTokenRefresh logouts on failure', () async {
      when(
        () => mockAuthStorage.getRefreshToken(),
      ).thenAnswer((_) async => 'old_refresh');
      when(() => mockAuthRepository.refreshToken(any())).thenThrow(Exception());
      when(() => mockAuthStorage.clearTokens()).thenAnswer((_) async => {});

      try {
        await authService.performTokenRefresh();
      } catch (_) {}

      verify(() => mockAuthStorage.clearTokens()).called(1);
    });

    test('performTokenRefresh throws when no refresh token', () async {
      when(
        () => mockAuthStorage.getRefreshToken(),
      ).thenAnswer((_) async => null);

      expect(() => authService.performTokenRefresh(), throwsException);
    });
  });
}
