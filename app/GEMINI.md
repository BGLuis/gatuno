# Gatuno Development Log

## Branding & Identity
- **App Icons:**
  - Configured platform-specific icon sets using `flutter_launcher_icons`.
  - Generated 1024x1024 raster assets from SVG via ImageMagick for compatibility.
  - Configured adaptive background color `#F18522` and removed iOS alpha channels.
- **Typography:**
  - Configured `Inknut Antiqua` as the default font family for the app in `AppTheme`.
  - Added all available weights (300 to 900) to `pubspec.yaml`.
- **Logging:**
  - Introduced a centralized `AppLogger` utility in `core/logging/logger.dart` using `dart:developer`.
  - Integrated comprehensive logging across the `auth` feature (Repository, Service, ViewModels).
- **Project Renaming:**
  - Rebranded package/bundle identifier to `com.gatuno.app` across Android (build.gradle, MainActivity) and iOS (project.pbxproj).

## Features
- **Authentication - Signup:**
  - Integrated `/auth/signup` endpoint with DTO-compliant validation (8+ chars, uppercase, digit, symbol).
  - Implemented `SignUpViewModel` and `SignUpForm` with automatic post-registration signIn.
  - Updated `GoRouter` navigation to handle the new signup flow and redirection.
- **Autofill Support:**
  - Enabled password manager autofill (e.g., Bitwarden, iCloud Keychain) for SignIn and SignUp forms.
  - Implemented `AutofillGroup` and `autofillHints` in `SignInForm` and `SignUpForm`.
  - Updated `AppTextField` to pass `autofillHints` to the underlying `TextFormField`.
  - Added explicit `TextInput.finishAutofillContext(shouldSave: true)` calls on successful authentication to prompt credential saving.

## Infrastructure & Quality
- **Routing:**
  - Removed global `redirect` from `GoRouter` in `router.dart`.
  - The app is now accessible without mandatory signIn, allowing direct access to `/home`.
  - Updated `HomePage` to handle dynamic authentication states, showing an `IconButton` for "Sign In" (guest) or "Profile" (authenticated).
  - Added a "Go Back" button to `AuthTemplate` (shared by `SignInPage` and `SignUpPage`) to allow easy navigation back to `/home`.
- **Environment Variables:**
  - Introduced `API_BASE_URL` environment variable using `String.fromEnvironment`.
  - Configured `http://localhost:3000` as the default value in `ApiConstants`.
  - This allows setting the API endpoint at compile time using `--dart-define=API_BASE_URL=https://your-api.com`.
- **Internationalization (i18n):**
  - Enabled multi-language support (EN, PT) using `flutter_localizations` and `intl`.
  - Established a feature-prefixed ARB key structure (`authSignInTitle`, `authEmailLabel`) for better translation organization.
  - Localized all existing authentication UI components.
- **Testing & Coverage:**
  - Resolved `intl` versioning conflicts between local dependencies and the Flutter SDK.
  - Enhanced `PumpApp` test helper to support localization context.
  - Implemented comprehensive unit tests for `AuthService`, `AuthRepositoryImpl`, `AuthResponse`, `AuthStorage`, `ApiExceptionHandler`, and `DioClient`.
  - Achieved **85.27%** code coverage with 65 passing tests.
  - Improved `AuthRepositoryImpl` exception handling to ensure `AppExceptions` (like `ValidationException` and `ServerException`) are rethrown instead of being swallowed by generic catch blocks.
- **Testing & Verification:**
  - Updated `HomePage` integration tests to match the current UI implementation (Login icon for guest, Profile icon for authenticated).
  - Stubbed `AuthService.isAuthenticated()` in tests to prevent `Mocktail` failures during `initState`.
