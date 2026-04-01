import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../../shared/icons/icons.dart';
import '../../../../shared/components/organisms/signup_form.dart';
import '../../../../shared/components/templates/auth_template.dart';
import '../../domain/use_cases/auth_service.dart';
import '../view_models/signup_view_model.dart';
import '../../../../core/di/injection.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final SignUpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SignUpViewModel(sl<AuthService>());
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

  void _handleSignUp(String email, String password) async {
    final success = await _viewModel.signUp(email, password);

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
          onBack: () => context.go('/home'),
          logo: AppIcons.logo(height: 80),
          title: Text(
            l10n.authSignUpTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          form: SignUpForm(
            onSubmit: _handleSignUp,
            onSignIn: () {
              context.go('/auth/signin');
            },
            isLoading: _viewModel.isLoading,
          ),
        );
      },
    );
  }
}
