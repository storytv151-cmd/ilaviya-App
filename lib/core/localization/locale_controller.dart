import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/core/localization/app_translations.dart';
import 'package:my_flutter_app/features/language/services/language_service.dart';

/// Reactive Global Locale Controller for ILAVIYA.
/// 
/// Allows instant live translation updates across the entire application
/// whenever the user selects or switches their language.
class LocaleController extends ChangeNotifier {
  static final LocaleController instance = LocaleController._internal();

  LocaleController._internal() {
    _initLocale();
  }

  String _currentLanguageCode = 'en';

  String get currentLanguageCode => _currentLanguageCode;

  Future<void> _initLocale() async {
    _currentLanguageCode = await LanguageService.getSelectedLanguage();
    notifyListeners();
  }

  /// Changes the active language immediately and persists the choice.
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguageCode == languageCode) return;
    _currentLanguageCode = languageCode;
    notifyListeners();
    await LanguageService.saveLanguage(languageCode);
  }

  /// Translates a given key based on the currently active language.
  String tr(String key) {
    return AppTranslations.translate(key, languageCode: _currentLanguageCode);
  }
}
