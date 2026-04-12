import '../../../../core/base/safe_change_notifier.dart';
import '../../../../core/logging/logger.dart';
import '../../../settings/domain/use_cases/settings_service.dart';

class WelcomeViewModel extends SafeChangeNotifier {
  final SettingsService _settingsService;

  WelcomeViewModel(this._settingsService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<bool> validateAndSaveUrl(String url) async {
    if (url.isEmpty) {
      _error = 'Please enter a URL';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final isValid = await _settingsService.validateApiUrl(url);

      if (isValid) {
        final formattedUrl = url.endsWith('/')
            ? url.substring(0, url.length - 1)
            : url;
        await _settingsService.setApiUrl(formattedUrl);
        return true;
      } else {
        _error =
            'Could not connect to the server. Please check the URL and certificate.';
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.e(
        'Error during validateAndSaveUrl in ViewModel',
        e,
        stackTrace,
        'WelcomeViewModel',
      );
      _error = 'An unexpected error occurred while saving the URL.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
