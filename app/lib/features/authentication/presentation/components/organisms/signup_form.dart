import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import 'package:gatuno/shared/validators/email.dart';
import 'package:gatuno/shared/components/atoms/app_button.dart';
import 'package:gatuno/shared/components/atoms/app_text_field.dart';

class SignUpForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final VoidCallback? onSignIn;
  final bool isLoading;

  const SignUpForm({
    super.key,
    required this.onSubmit,
    this.onSignIn,
    this.isLoading = false,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authPasswordError;
                }
                if (value.length < 8) {
                  return l10n.authPasswordTooShort;
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return l10n.authPasswordNoUppercase;
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return l10n.authPasswordNoNumber;
                }
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return l10n.authPasswordNoSymbol;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _confirmPasswordController,
              label: l10n.authConfirmPasswordLabel,
              prefixIcon: const Icon(Icons.lock_reset_outlined),
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.authConfirmPasswordError;
                }
                if (value != _passwordController.text) {
                  return l10n.authPasswordsDoNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              text: l10n.authCreateAccountButton,
              onPressed: _handleSubmit,
              isLoading: widget.isLoading,
            ),
            if (widget.onSignIn != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: widget.onSignIn,
                child: Text(l10n.authAlreadyHaveAccount),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
