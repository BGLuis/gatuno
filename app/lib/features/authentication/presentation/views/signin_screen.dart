import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../../shared/icons/icons.dart';
import '../components/organisms/signin_form.dart';
import '../components/templates/auth_template.dart';
import '../../domain/use_cases/auth_service.dart';
import '../view_models/signin_view_model.dart';
import '../../../../core/di/injection.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final SignInViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SignInViewModel(sl<AuthService>());
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      _viewModel.clearError();
    }
  }

  void _handleSignIn(String email, String password) async {
    final success = await _viewModel.signIn(email, password);

    if (success && mounted) {
      TextInput.finishAutofillContext(shouldSave: true);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return AuthTemplate(
          onBack: () => context.pop(),
          logo: AppIcons.logo(height: 80),
          title: Text(
            l10n.authSignInTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          form: SignInForm(
            onSubmit: _handleSignIn,
            onSignUp: () {
              context.go('/auth/signup');
            },
            isLoading: _viewModel.isLoading,
          ),
        );
      },
    );
  }
}
