import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

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

  /// Redacts an email address if not in debug mode.
  /// user@example.com -> u***@example.com
  static String redactEmail(String email) {
    if (kDebugMode) return email;
    final parts = email.split('@');
    if (parts.length != 2) return '***';
    final user = parts[0];
    final domain = parts[1];
    if (user.length <= 1) return '*@$domain';
    return '${user[0]}***@$domain';
  }
}
