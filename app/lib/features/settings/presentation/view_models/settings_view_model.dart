import '../../../../core/base/safe_change_notifier.dart';
import '../../domain/use_cases/settings_service.dart';
import '../../../authentication/domain/use_cases/auth_service.dart';
import '../../../users/data/models/user_model.dart';

class SettingsViewModel extends SafeChangeNotifier {
  final SettingsService _settingsService;
  final AuthService _authService;

  SettingsViewModel({
    required SettingsService settingsService,
    required AuthService authService,
  }) : _settingsService = settingsService,
       _authService = authService {
    _settingsService.addListener(notifyListeners);
    _authService.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _settingsService.removeListener(notifyListeners);
    _authService.removeListener(notifyListeners);
    super.dispose();
  }

  String? get apiUrl => _settingsService.apiUrl;
  bool get sensitiveContentEnabled => _settingsService.sensitiveContentEnabled;
  bool get isAuthenticated => _authService.authenticated;
  UserModel? get user => _authService.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> setSensitiveContentEnabled(bool enabled) async {
    await _settingsService.setSensitiveContentEnabled(enabled);
    notifyListeners();
  }

  Future<bool> updateApiUrl(String url) async {
    _isLoading = true;
    notifyListeners();

    try {
      final isValid = await _settingsService.validateApiUrl(url);
      if (isValid) {
        final formattedUrl = url.endsWith('/')
            ? url.substring(0, url.length - 1)
            : url;
        await _settingsService.setApiUrl(formattedUrl);
        return true;
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
