import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gatuno/features/users/presentation/views/me_screen.dart';
import 'package:gatuno/features/users/presentation/view_models/me_view_model.dart';
import 'package:gatuno/features/users/domain/use_cases/user_service.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';
import '../../../helpers/pump_app.dart';
import '../../../helpers/test_injection.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  late MockUserService mockUserService;
  late MockAuthService mockAuthService;
  late MeViewModel meViewModel;

  setUp(() async {
    mockUserService = MockUserService();
    mockAuthService = MockAuthService();
    meViewModel = MeViewModel(mockUserService);

    await initTestDI(authService: mockAuthService, meViewModel: meViewModel);

    when(() => mockUserService.getCurrentUser()).thenAnswer(
      (_) async => UserModel(
        id: '1',
        email: 'test@example.com',
        roles: ['user'],
        maxWeightSensitiveContent: 5,
        name: 'Test User',
      ),
    );
    when(
      () => mockUserService.isSensitiveContentEnabled(),
    ).thenAnswer((_) async => false);
  });

  testWidgets('MePage renders correctly and handles logout', (tester) async {
    await tester.pumpApp(const MePage());
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Sensitive Content'), findsOneWidget);

    // Test logout
    when(() => mockUserService.logout()).thenAnswer((_) async {});

    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    verify(() => mockUserService.logout()).called(1);
    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('MePage handles sensitive content toggle', (tester) async {
    await tester.pumpApp(const MePage());
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // Check initial value (false)
    expect(tester.widget<Switch>(switchFinder).value, isFalse);

    // Toggle ON
    when(
      () => mockUserService.setSensitiveContentEnabled(true),
    ).thenAnswer((_) async {});
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    verify(() => mockUserService.setSensitiveContentEnabled(true)).called(1);
    expect(tester.widget<Switch>(switchFinder).value, isTrue);
  });
}
