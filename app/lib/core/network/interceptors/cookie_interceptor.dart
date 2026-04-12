import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../dio_client.dart';
import '../cookies/secure_cookie_storage.dart';

/// Configures cookie management for the Dio client.
/// This will automatically store and send cookies (like refreshToken)
/// securely using FlutterSecureStorage.
void setupCookieInterceptor(DioClient dioClient) {
  final cookieJar = PersistCookieJar(
    storage: SecureCookieStorage(),
    // Keep cookies until they expire
    persistSession: true,
    ignoreExpires: false,
  );

  dioClient.dio.interceptors.add(CookieManager(cookieJar));
}
