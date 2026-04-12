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
  String get authDoNotHaveAccount => 'Não tem uma conta? Cadastre-se';

  @override
  String get authAlreadyHaveAccount => 'Já tem uma conta? Entrar';

  @override
  String get homeTitle => 'Início';

  @override
  String get booksTitle => 'Livros';

  @override
  String get booksSearchHint => 'Pesquisar livros...';

  @override
  String get booksFilterTitle => 'Filtros';

  @override
  String get booksApplyFilters => 'Aplicar Filtros';

  @override
  String get booksClearFilters => 'Limpar';

  @override
  String get booksPublicationYear => 'Ano de publicação';

  @override
  String get booksTypes => 'Tipos';

  @override
  String get booksSensitiveContent => 'Conteúdos sensíveis';

  @override
  String get booksTags => 'Tags';

  @override
  String get booksIncludedTags => 'Selecionadas';

  @override
  String get booksExcludedTags => 'Excluídas';

  @override
  String get booksOperatorBefore => 'Antes de';

  @override
  String get booksOperatorBeforeEqual => 'Antes ou igual a';

  @override
  String get booksOperatorAfter => 'Depois de';

  @override
  String get booksOperatorAfterEqual => 'Depois ou igual a';

  @override
  String get booksOperatorEqual => 'Igual a';

  @override
  String get bookTypeManga => 'Mangá';

  @override
  String get bookTypeManhwa => 'Manhwa';

  @override
  String get bookTypeManhua => 'Manhua';

  @override
  String get bookTypeBook => 'Livro';

  @override
  String get bookTypeOther => 'Outro';

  @override
  String get booksUnknownAuthor => 'Autor Desconhecido';

  @override
  String get booksNoBooksFound => 'Nenhum livro encontrado';

  @override
  String get booksNoChaptersFound => 'Nenhum capítulo encontrado';

  @override
  String get booksChapterCount => 'Capítulos';

  @override
  String booksChapterLabel(String index) {
    return 'Capítulo $index';
  }

  @override
  String get booksSortTitle => 'Ordenar';

  @override
  String get booksSortMostRecentAdded => 'Adicionados recentemente';

  @override
  String get booksSortOldestAdded => 'Mais antigos primeiro';

  @override
  String get booksSortAlphabeticalAZ => 'Alfabética A-Z';

  @override
  String get booksSortAlphabeticalZA => 'Alfabética Z-A';

  @override
  String get booksSortMostRecentUpdate => 'Atualizações recentes';

  @override
  String get booksSortOldestUpdate => 'Atualizações antigas';

  @override
  String get booksSortMostRecentPublished => 'Publicados recentemente';

  @override
  String get booksSortOldestPublished => 'Publicados antigos';

  @override
  String get scrapingStatusReady => 'Pronto';

  @override
  String get scrapingStatusProcess => 'Processando';

  @override
  String get scrapingStatusError => 'Erro';

  @override
  String get booksStartReading => 'Começar a ler';

  @override
  String get homeWelcome => 'Bem-vindo ao Gatuno!';

  @override
  String get homeProfile => 'Perfil';

  @override
  String get userMeTitle => 'Meu Perfil';

  @override
  String get userMeSensitiveContent => 'Conteúdo Sensível';

  @override
  String get userMeSensitiveContentDesc =>
      'Mostrar livros com conteúdo sensível';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsGeneralSection => 'Geral';

  @override
  String get settingsApiSection => 'Configuração da API';

  @override
  String get settingsApiUrlLabel => 'URL Base da API';

  @override
  String get settingsApiUrlHint => 'http://sua-api.com/api';

  @override
  String get settingsApiUrlSuccess => 'URL da API atualizada com sucesso';

  @override
  String get settingsApiUrlError => 'Erro ao atualizar a URL da API';

  @override
  String get welcomeTitle => 'Bem-vindo ao Gatuno';

  @override
  String get welcomeInstructions =>
      'Por favor, insira a URL da API do seu servidor para continuar.';

  @override
  String get welcomeConnect => 'Conectar';

  @override
  String get commonLogout => 'Sair';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonGuest => 'Visitante';

  @override
  String get errorTitle => 'Algo deu errado';

  @override
  String get errorMessage => 'Ocorreu um erro inesperado.';

  @override
  String get errorRetry => 'Tentar novamente';

  @override
  String get errorBack => 'Voltar';

  @override
  String get commonPrevious => 'Anterior';

  @override
  String get commonNext => 'Próximo';

  @override
  String commonPage(int page) {
    return 'Página $page';
  }

  @override
  String commonPageOf(int current, int total) {
    return 'Página $current de $total';
  }
}
