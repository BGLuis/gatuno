abstract class AppExceptions implements Exception {
  final String message;
  final int? statusCode;

  AppExceptions(this.message, {this.statusCode});

  @override
  String toString() => message;
}
