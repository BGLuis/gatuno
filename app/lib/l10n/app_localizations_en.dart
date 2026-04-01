// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authSignInTitle => 'Gatuno';

  @override
  String get authSignInSubtitle =>
      'Gatuno is a system developed to organize and share a personal collection of e-books on a local network.';

  @override
  String get authSignUpTitle => 'Join Gatuno';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailError => 'Please enter your email';

  @override
  String get authEmailInvalid => 'Please enter a valid email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordError => 'Please enter your password';

  @override
  String get authPasswordTooShort =>
      'Password must be at least 8 characters long';

  @override
  String get authPasswordNoUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get authPasswordNoNumber =>
      'Password must contain at least one number';

  @override
  String get authPasswordNoSymbol =>
      'Password must contain at least one symbol';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordError => 'Please confirm your password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authSignInButton => 'SIGN IN';

  @override
  String get authSignUpButton => 'SIGN UP';

  @override
  String get authCreateAccountButton => 'CREATE ACCOUNT';

  @override
  String get authDontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome to Gatuno!';

  @override
  String get homeProfile => 'Profile';

  @override
  String get commonLogout => 'Sign Out';

  @override
  String get commonLoading => 'Loading...';
}
