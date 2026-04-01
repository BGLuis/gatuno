// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get authSignInTitle => 'Gatuno';

  @override
  String get authSignInSubtitle =>
      'O Gatuno é um sistema desenvolvido para organizar e compartilhar uma coleção pessoal de e-books em uma rede local.';

  @override
  String get authSignUpTitle => 'Junte-se ao Gatuno';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailError => 'Por favor, insira seu email';

  @override
  String get authEmailInvalid => 'Por favor, insira um email válido';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authPasswordError => 'Por favor, insira sua senha';

  @override
  String get authPasswordTooShort => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get authPasswordNoUppercase =>
      'A senha deve conter pelo menos uma letra maiúscula';

  @override
  String get authPasswordNoNumber => 'A senha deve conter pelo menos um número';

  @override
  String get authPasswordNoSymbol =>
      'A senha deve conter pelo menos um símbolo';

  @override
  String get authConfirmPasswordLabel => 'Confirmar Senha';

  @override
  String get authConfirmPasswordError => 'Por favor, confirme sua senha';

  @override
  String get authPasswordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get authSignInButton => 'ENTRAR';

  @override
  String get authSignUpButton => 'CADASTRAR';

  @override
  String get authCreateAccountButton => 'CRIAR CONTA';

  @override
  String get authDontHaveAccount => 'Não tem uma conta? Cadastre-se';

  @override
  String get authAlreadyHaveAccount => 'Já tem uma conta? Entrar';

  @override
  String get homeTitle => 'Início';

  @override
  String get homeWelcome => 'Bem-vindo ao Gatuno!';

  @override
  String get homeProfile => 'Perfil';

  @override
  String get commonLogout => 'Sair';

  @override
  String get commonLoading => 'Carregando...';
}
