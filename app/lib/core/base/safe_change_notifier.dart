import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that safely handles [notifyListeners] calls after disposal.
abstract class SafeChangeNotifier extends ChangeNotifier {
  bool _isDisposed = false;

  /// Returns true if the object has been disposed.
  bool get isDisposed => _isDisposed;

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  @mustCallSuper
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
