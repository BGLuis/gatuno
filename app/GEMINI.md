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
  - Implemented PII redaction for email addresses in logs using `AppLogger.redactEmail`, which gates full email visibility behind `kDebugMode`.
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
  - Refactored `errorBuilder` in `router.dart` to use a generic, user-friendly `ErrorScreen` while logging detailed exception info via `AppLogger.e`.
  - Localized the `ErrorScreen` with "Something went wrong" messages in both English and Portuguese.
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
  - Achieved **83.8%** code coverage with 105 passing tests.
  - Improved `AuthRepositoryImpl` exception handling to ensure `AppExceptions` (like `ValidationException` and `ServerException`) are rethrown instead of being swallowed by generic catch blocks.
- **Testing & Verification:**
  - Updated `HomePage` integration tests to match the current UI implementation (Login icon for guest, Profile icon for authenticated).
  - Stubbed `AuthService.isAuthenticated()` in tests to prevent `Mocktail` failures during `initState`.

## Features
- **Users - Profile:**
  - Implemented `/users/me` route to display current user profile.
  - Developed a custom `JwtDecoder` utility in `core/utils/jwt_decoder.dart` to extract user info from access tokens.
  - Implemented `MeViewModel` and `MePage` with a mocked initials-based avatar.
  - Added a "Sensitive Content" toggle that persists in `UserStorage` and remains enabled even after logout.
  - Integrated `MePage` with `GoRouter` using `context.push()` to allow easy navigation back to `/home`.

- **Home:**
  - Refactored `HomePage` to follow Atomic Design using `HomeAppBar` (organism) and `HomeTemplate` (template).
  - Implemented `HomeViewModel` to reactively update the UI when authentication state changes.
  - Improved `AppBar` to show "Profile" or "Sign In" icons instantly based on `AuthService` state.

## Design Patterns
- **Atomic Design:**
  - Adopted Atomic Design for UI components in `shared/components/`.
  - **Atoms:** Low-level components like `AppButton`, `AppAvatar`, `AppSwitch`, `AppClickableAction`.
  - **Molecules:** Groups of atoms like `UserProfileHeader`, `UserProfileIcon`, `LoginIcon`.
  - **Organisms:** Complex UI sections like `MeSettingsList`, `SignInForm`, `HomeAppBar`.
  - **Templates:** Page layouts like `ProfileTemplate`, `AuthTemplate`, `HomeTemplate`.
  - **Pages:** Feature-specific views that wire view models to templates, like `MePage` and `HomePage`.

## Infrastructure & Quality
- **Reactive Auth State:**
  - Refactored `AuthService` to extend `ChangeNotifier` and provide synchronous `authenticated` and `isInitialized` properties.
  - Provided `AuthService` globally via `MultiProvider` in `main.dart` to allow the entire app to react to auth state changes.
- **Infrastructure & Quality:**
  - Refactored `DioClient` to remove internal `AuthStorage` instantiation, favoring dependency injection.
  - Extracted authentication interceptor setup into a standalone function `setupAuthInterceptor` in `core/network/interceptors/auth_interceptor.dart`.
  - Improved DI configuration in `initDI` to wire `DioClient`, `AuthService`, and interceptors using `GetIt`.
  - Exposed `getAccessToken` in `AuthService` to provide a clean interface for the authentication interceptor.
  - Enhanced `HomePage` integration tests with interaction verification using `Mocktail`.
- **Authentication - Tokens:**
  - Implemented `AuthInterceptor` with automatic token refresh on 401 errors.
  - Added concurrent refresh request management in `AuthInterceptor` to prevent redundant calls.
  - Implemented request retry mechanism after successful token refresh.
  - Updated `AuthRepository` and `AuthService` to use cookie-based refresh and logout as required by the backend (`GET` request with `Cookie: refreshToken=...`).
  - Added unit tests for the updated authentication repository and service.
