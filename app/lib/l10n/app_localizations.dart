import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Gatuno'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gatuno is a system developed to organize and share a personal collection of e-books on a local network.'**
  String get authSignInSubtitle;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Gatuno'**
  String get authSignUpTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authEmailError;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authPasswordError;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get authPasswordTooShort;

  /// No description provided for @authPasswordNoUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get authPasswordNoUppercase;

  /// No description provided for @authPasswordNoNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get authPasswordNoNumber;

  /// No description provided for @authPasswordNoSymbol.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one symbol'**
  String get authPasswordNoSymbol;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordError;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get authSignInButton;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get authSignUpButton;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get authCreateAccountButton;

  /// No description provided for @authDoNotHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get authDoNotHaveAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get authAlreadyHaveAccount;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @booksTitle.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get booksTitle;

  /// No description provided for @booksSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get booksSearchHint;

  /// No description provided for @booksFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get booksFilterTitle;

  /// No description provided for @booksApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get booksApplyFilters;

  /// No description provided for @booksClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get booksClearFilters;

  /// No description provided for @booksPublicationYear.
  ///
  /// In en, this message translates to:
  /// **'Publication Year'**
  String get booksPublicationYear;

  /// No description provided for @booksTypes.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get booksTypes;

  /// No description provided for @booksSensitiveContent.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Content'**
  String get booksSensitiveContent;

  /// No description provided for @booksTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get booksTags;

  /// No description provided for @booksIncludedTags.
  ///
  /// In en, this message translates to:
  /// **'Included Tags'**
  String get booksIncludedTags;

  /// No description provided for @booksExcludedTags.
  ///
  /// In en, this message translates to:
  /// **'Excluded Tags'**
  String get booksExcludedTags;

  /// No description provided for @booksOperatorBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get booksOperatorBefore;

  /// No description provided for @booksOperatorBeforeEqual.
  ///
  /// In en, this message translates to:
  /// **'Before or Equal to'**
  String get booksOperatorBeforeEqual;

  /// No description provided for @booksOperatorAfter.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get booksOperatorAfter;

  /// No description provided for @booksOperatorAfterEqual.
  ///
  /// In en, this message translates to:
  /// **'After or Equal to'**
  String get booksOperatorAfterEqual;

  /// No description provided for @booksOperatorEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get booksOperatorEqual;

  /// No description provided for @bookTypeManga.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get bookTypeManga;

  /// No description provided for @bookTypeManhwa.
  ///
  /// In en, this message translates to:
  /// **'Manhwa'**
  String get bookTypeManhwa;

  /// No description provided for @bookTypeManhua.
  ///
  /// In en, this message translates to:
  /// **'Manhua'**
  String get bookTypeManhua;

  /// No description provided for @bookTypeBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookTypeBook;

  /// No description provided for @bookTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get bookTypeOther;

  /// No description provided for @booksUnknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Author'**
  String get booksUnknownAuthor;

  /// No description provided for @booksNoBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get booksNoBooksFound;

  /// No description provided for @booksNoChaptersFound.
  ///
  /// In en, this message translates to:
  /// **'No chapters found'**
  String get booksNoChaptersFound;

  /// No description provided for @booksChapterCount.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get booksChapterCount;

  /// No description provided for @booksChapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter {index}'**
  String booksChapterLabel(String index);

  /// No description provided for @booksSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get booksSortTitle;

  /// No description provided for @booksSortMostRecentAdded.
  ///
  /// In en, this message translates to:
  /// **'Most Recent Added'**
  String get booksSortMostRecentAdded;

  /// No description provided for @booksSortOldestAdded.
  ///
  /// In en, this message translates to:
  /// **'Oldest Added'**
  String get booksSortOldestAdded;

  /// No description provided for @booksSortAlphabeticalAZ.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical A-Z'**
  String get booksSortAlphabeticalAZ;

  /// No description provided for @booksSortAlphabeticalZA.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical Z-A'**
  String get booksSortAlphabeticalZA;

  /// No description provided for @booksSortMostRecentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Most Recent Update'**
  String get booksSortMostRecentUpdate;

  /// No description provided for @booksSortOldestUpdate.
  ///
  /// In en, this message translates to:
  /// **'Oldest Update'**
  String get booksSortOldestUpdate;

  /// No description provided for @booksSortMostRecentPublished.
  ///
  /// In en, this message translates to:
  /// **'Most Recent Published'**
  String get booksSortMostRecentPublished;

  /// No description provided for @booksSortOldestPublished.
  ///
  /// In en, this message translates to:
  /// **'Oldest Published'**
  String get booksSortOldestPublished;

  /// No description provided for @scrapingStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get scrapingStatusReady;

  /// No description provided for @scrapingStatusProcess.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get scrapingStatusProcess;

  /// No description provided for @scrapingStatusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get scrapingStatusError;

  /// No description provided for @booksStartReading.
  ///
  /// In en, this message translates to:
  /// **'Start Reading'**
  String get booksStartReading;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gatuno!'**
  String get homeWelcome;

  /// No description provided for @homeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeProfile;

  /// No description provided for @userMeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get userMeTitle;

  /// No description provided for @userMeSensitiveContent.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Content'**
  String get userMeSensitiveContent;

  /// No description provided for @userMeSensitiveContentDesc.
  ///
  /// In en, this message translates to:
  /// **'Show books with sensitive content'**
  String get userMeSensitiveContentDesc;

  /// No description provided for @commonLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get commonLogout;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get commonGuest;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorMessage;

  /// No description provided for @errorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetry;

  /// No description provided for @errorBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get errorBack;

  /// No description provided for @commonPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get commonPrevious;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String commonPage(int page);

  /// No description provided for @commonPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String commonPageOf(int current, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
