import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/authentication/domain/use_cases/auth_service.dart';
import 'package:gatuno/features/authentication/domain/repositories/auth_repository.dart';
import 'package:gatuno/features/authentication/data/data_sources/auth_local_data_source.dart';
import 'package:gatuno/features/authentication/domain/entities/auth_token.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  late AuthService authService;
  late MockAuthRepository mockAuthRepository;
  late MockAuthStorage mockAuthStorage;

  setUpAll(() {
    registerFallbackValue(AuthToken(token: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthStorage = MockAuthStorage();

    // Default mock behavior for constructor's _initAuth
    when(() => mockAuthStorage.getToken()).thenAnswer((_) async => null);

    authService = AuthService(mockAuthRepository, mockAuthStorage);
  });

  final tToken = AuthToken(token: 'access');

  group('AuthService', () {
    test(
      'signIn calls repository, saves token and notifies listeners',
      () async {
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        when(
          () => mockAuthRepository.signIn(any(), any()),
        ).thenAnswer((_) async => tToken);
        when(
          () => mockAuthStorage.saveToken(any()),
        ).thenAnswer((_) async => {});

        final result = await authService.signIn('test@example.com', 'password');

        expect(result, true);
        expect(authService.authenticated, true);
        expect(notificationCount, greaterThan(0));
        verify(
          () => mockAuthRepository.signIn('test@example.com', 'password'),
        ).called(1);
        verify(() => mockAuthStorage.saveToken('access')).called(1);
      },
    );

    test(
      'logout calls repository, clears tokens and notifies listeners',
      () async {
        var notificationCount = 0;
        authService.addListener(() => notificationCount++);

        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        when(() => mockAuthStorage.clearToken()).thenAnswer((_) async => {});

        await authService.logout();

        expect(authService.authenticated, false);
        expect(notificationCount, greaterThan(0));
        verify(() => mockAuthRepository.logout()).called(1);
        verify(() => mockAuthStorage.clearToken()).called(1);
      },
    );

    test(
      'isAuthenticated returns true when token exists and is not expired',
      () async {
        // token split by . gives 3 parts, middle is base64 payload.
        // We need it to NOT be expired.
        final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
        final payload = base64Url
            .encode(utf8.encode('{"exp": $exp}'))
            .replaceAll('=', '');
        final token = 'header.$payload.signature';

        when(() => mockAuthStorage.getToken()).thenAnswer((_) async => token);

        final result = await authService.isAuthenticated();

        expect(result, true);
        expect(authService.authenticated, true);
      },
    );

    test('performTokenRefresh handles concurrent calls atomically', () async {
      when(() => mockAuthRepository.refreshToken()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return tToken;
      });
      when(() => mockAuthStorage.saveToken(any())).thenAnswer((_) async => {});

      // Fire multiple refresh requests concurrently
      final futures = await Future.wait([
        authService.performTokenRefresh(),
        authService.performTokenRefresh(),
        authService.performTokenRefresh(),
      ]);

      expect(futures.length, 3);
      verify(() => mockAuthRepository.refreshToken()).called(1);
    });
  });
}
