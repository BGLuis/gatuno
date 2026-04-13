import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/features/welcome/presentation/views/welcome_screen.dart';
import 'package:gatuno/features/welcome/presentation/view_models/welcome_view_model.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_injection.dart';

void main() {
  late MockSettingsService mockSettingsService;
  late WelcomeViewModel viewModel;

  setUp(() async {
    mockSettingsService = MockSettingsService();
    viewModel = WelcomeViewModel(mockSettingsService);

    await initTestDI(settingsService: mockSettingsService);
  });

  testWidgets('WelcomePage renders correctly', (tester) async {
    await tester.pumpApp(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: const WelcomePage(),
      ),
    );

    expect(find.text('Welcome to Gatuno'), findsOneWidget);
    expect(
      find.text('Please enter your server API URL to continue.'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
  });

  testWidgets('WelcomePage calls validateAndSaveUrl when Connect is pressed', (
    tester,
  ) async {
    when(
      () => mockSettingsService.validateApiUrl(any()),
    ).thenAnswer((_) async => true);
    when(() => mockSettingsService.setApiUrl(any())).thenAnswer((_) async {});

    await tester.pumpApp(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: const WelcomePage(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'http://test.com');
    await tester.tap(find.text('Connect'));
    await tester.pump();

    verify(
      () => mockSettingsService.validateApiUrl('http://test.com'),
    ).called(1);
  });
}
