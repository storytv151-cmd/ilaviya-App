import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting and retrieving user's selected language.
class LanguageService {
  static const String _keyLanguageCode = 'user_selected_language_code';
  static const String _keyLanguageSelected = 'has_selected_language';

  /// Saves the selected language code and marks selection as complete.
  static Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, code);
    await prefs.setBool(_keyLanguageSelected, true);
  }

  /// Gets the currently saved language code, defaulting to 'en'.
  static Future<String> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguageCode) ?? 'en';
  }

  /// Checks if user has already selected a language previously.
  static Future<bool> hasSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLanguageSelected) ?? false;
  }
}
