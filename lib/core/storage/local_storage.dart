import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service wrapping [SharedPreferences] for simple key-value persistence.
class LocalStorage {
  static SharedPreferences? _prefs;

  /// Initialize the SharedPreferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get a boolean value by [key].
  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Set a boolean value by [key].
  static Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) await init();
    return await _prefs!.setBool(key, value);
  }

  /// Get a string value by [key].
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Set a string value by [key].
  static Future<bool> setString(String key, String value) async {
    if (_prefs == null) await init();
    return await _prefs!.setString(key, value);
  }

  /// Get an integer value by [key].
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Set an integer value by [key].
  static Future<bool> setInt(String key, int value) async {
    if (_prefs == null) await init();
    return await _prefs!.setInt(key, value);
  }

  /// Remove a key from storage.
  static Future<bool> remove(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  /// Clear all stored values.
  static Future<bool> clear() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }
}
