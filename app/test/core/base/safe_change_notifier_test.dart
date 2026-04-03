import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/core/base/safe_change_notifier.dart';

class TestViewModel extends SafeChangeNotifier {
  void testNotify() {
    notifyListeners();
  }
}

void main() {
  group('SafeChangeNotifier', () {
    test('should track disposed state', () {
      final viewModel = TestViewModel();
      expect(viewModel.isDisposed, isFalse);

      viewModel.dispose();
      expect(viewModel.isDisposed, isTrue);
    });

    test('should not throw when notifyListeners is called after dispose', () {
      final viewModel = TestViewModel();

      viewModel.dispose();

      // This should not throw FlutterError (A HomeViewModel was used after being disposed)
      expect(() => viewModel.testNotify(), returnsNormally);
    });

    test('should notify listeners before dispose', () {
      final viewModel = TestViewModel();
      var notifiedCount = 0;

      viewModel.addListener(() {
        notifiedCount++;
      });

      viewModel.testNotify();
      expect(notifiedCount, equals(1));
    });

    test('should NOT notify listeners after dispose', () {
      final viewModel = TestViewModel();
      var notifiedCount = 0;

      viewModel.addListener(() {
        notifiedCount++;
      });

      viewModel.dispose();

      viewModel.testNotify();
      expect(notifiedCount, equals(0));
    });
  });
}
