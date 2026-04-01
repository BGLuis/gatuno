import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../validators/email.dart';
import '../atoms/app_button.dart';
import '../atoms/app_text_field.dart';

class SignInForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final VoidCallback? onSignUp;
  final bool isLoading;

  const SignInForm({
    super.key,
    required this.onSubmit,
    this.onSignUp,
    this.isLoading = false,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _emailController,
              label: l10n.authEmailLabel,
              prefixIcon: const Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authEmailError;
                }
                if (!EmailValidatorWrapper.validate(value)) {
                  return l10n.authEmailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: l10n.authPasswordLabel,
              prefixIcon: const Icon(Icons.lock_outlined),
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authPasswordError;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              text: l10n.authSignInButton,
              onPressed: _handleSubmit,
              isLoading: widget.isLoading,
            ),
            if (widget.onSignUp != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: widget.onSignUp,
                child: Text(l10n.authDontHaveAccount),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
