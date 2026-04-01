import 'dart:developer' as dev;

class AppLogger {
  static void d(String message, [String? name]) {
    dev.log(message, name: name ?? 'DEBUG');
  }

  static void i(String message, [String? name]) {
    dev.log(message, name: name ?? 'INFO');
  }

  static void w(String message, [String? name]) {
    dev.log(message, name: name ?? 'WARNING');
  }

  static void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? name,
  ]) {
    dev.log(
      message,
      error: error,
      stackTrace: stackTrace,
      name: name ?? 'ERROR',
    );
  }
}
