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
  String get authDoNotHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get homeTitle => 'Home';

  @override
  String get booksTitle => 'Books';

  @override
  String get booksSearchHint => 'Search books...';

  @override
  String get booksFilterTitle => 'Filters';

  @override
  String get booksApplyFilters => 'Apply Filters';

  @override
  String get booksClearFilters => 'Clear';

  @override
  String get booksPublicationYear => 'Publication Year';

  @override
  String get booksTypes => 'Types';

  @override
  String get booksSensitiveContent => 'Sensitive Content';

  @override
  String get booksTags => 'Tags';

  @override
  String get booksIncludedTags => 'Included Tags';

  @override
  String get booksExcludedTags => 'Excluded Tags';

  @override
  String get booksOperatorBefore => 'Before';

  @override
  String get booksOperatorBeforeEqual => 'Before or Equal to';

  @override
  String get booksOperatorAfter => 'After';

  @override
  String get booksOperatorAfterEqual => 'After or Equal to';

  @override
  String get booksOperatorEqual => 'Equal';

  @override
  String get bookTypeManga => 'Manga';

  @override
  String get bookTypeManhwa => 'Manhwa';

  @override
  String get bookTypeManhua => 'Manhua';

  @override
  String get bookTypeBook => 'Book';

  @override
  String get bookTypeOther => 'Other';

  @override
  String get booksUnknownAuthor => 'Unknown Author';

  @override
  String get booksNoBooksFound => 'No books found';

  @override
  String get booksNoChaptersFound => 'No chapters found';

  @override
  String get booksChapterCount => 'Chapters';

  @override
  String booksChapterLabel(String index) {
    return 'Chapter $index';
  }

  @override
  String get booksSortTitle => 'Sort';

  @override
  String get booksSortMostRecentAdded => 'Most Recent Added';

  @override
  String get booksSortOldestAdded => 'Oldest Added';

  @override
  String get booksSortAlphabeticalAZ => 'Alphabetical A-Z';

  @override
  String get booksSortAlphabeticalZA => 'Alphabetical Z-A';

  @override
  String get booksSortMostRecentUpdate => 'Most Recent Update';

  @override
  String get booksSortOldestUpdate => 'Oldest Update';

  @override
  String get booksSortMostRecentPublished => 'Most Recent Published';

  @override
  String get booksSortOldestPublished => 'Oldest Published';

  @override
  String get scrapingStatusReady => 'Ready';

  @override
  String get scrapingStatusProcess => 'Processing';

  @override
  String get scrapingStatusError => 'Error';

  @override
  String get booksStartReading => 'Start Reading';

  @override
  String get homeWelcome => 'Welcome to Gatuno!';

  @override
  String get homeProfile => 'Profile';

  @override
  String get userMeTitle => 'My Profile';

  @override
  String get userMeSensitiveContent => 'Sensitive Content';

  @override
  String get userMeSensitiveContentDesc => 'Show books with sensitive content';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsApiSection => 'API Configuration';

  @override
  String get settingsApiUrlLabel => 'API Base URL';

  @override
  String get settingsApiUrlHint => 'http://your-api.com/api';

  @override
  String get settingsApiUrlSuccess => 'API URL updated successfully';

  @override
  String get settingsApiUrlError => 'Error updating API URL';

  @override
  String get welcomeTitle => 'Welcome to Gatuno';

  @override
  String get welcomeInstructions =>
      'Please enter your server API URL to continue.';

  @override
  String get welcomeConnect => 'Connect';

  @override
  String get commonLogout => 'Sign Out';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonGuest => 'Guest';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorMessage => 'An unexpected error occurred.';

  @override
  String get errorRetry => 'Retry';

  @override
  String get errorBack => 'Go Back';

  @override
  String get commonPrevious => 'Previous';

  @override
  String get commonNext => 'Next';

  @override
  String commonPage(int page) {
    return 'Page $page';
  }

  @override
  String commonPageOf(int current, int total) {
    return 'Page $current of $total';
  }
}
