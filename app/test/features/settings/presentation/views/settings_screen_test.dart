import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/features/settings/presentation/views/settings_screen.dart';
import 'package:gatuno/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:gatuno/shared/components/molecules/settings_profile_card.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_injection.dart';

void main() {
  late MockSettingsService mockSettingsService;
  late MockAuthService mockAuthService;
  late SettingsViewModel viewModel;

  setUp(() async {
    mockSettingsService = MockSettingsService();
    mockAuthService = MockAuthService();

    when(() => mockSettingsService.addListener(any())).thenAnswer((_) {});
    when(() => mockSettingsService.removeListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.addListener(any())).thenAnswer((_) {});
    when(() => mockAuthService.removeListener(any())).thenAnswer((_) {});

    viewModel = SettingsViewModel(
      settingsService: mockSettingsService,
      authService: mockAuthService,
    );

    await initTestDI(
      settingsService: mockSettingsService,
      authService: mockAuthService,
    );

    when(() => mockSettingsService.apiUrl).thenReturn('http://test.com');
    when(() => mockSettingsService.sensitiveContentEnabled).thenReturn(false);
    when(() => mockAuthService.authenticated).thenReturn(false);
    when(() => mockAuthService.currentUser).thenReturn(null);
  });

  testWidgets('SettingsPage renders correctly for guest', (tester) async {
    await tester.pumpApp(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: const SettingsPage(),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(SettingsProfileCard), findsOneWidget);
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('API Base URL'), findsOneWidget);
  });

  testWidgets('SettingsPage updates sensitive content toggle', (tester) async {
    when(
      () => mockSettingsService.setSensitiveContentEnabled(any()),
    ).thenAnswer((_) async {});

    await tester.pumpApp(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: const SettingsPage(),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();

    verify(
      () => mockSettingsService.setSensitiveContentEnabled(true),
    ).called(1);
  });
}
