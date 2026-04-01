class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  // Auth Routes
  static const String signIn = '/auth/signin';
  static const String signUp = '/auth/signup';
  static const String refreshToken = '/auth/refresh';
}
