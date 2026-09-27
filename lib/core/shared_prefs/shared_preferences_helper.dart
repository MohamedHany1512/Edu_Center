import 'package:shared_preferences/shared_preferences.dart';

/// Typed, null-safe wrapper around [SharedPreferences].
///
/// The previous implementation exposed a `static late SharedPreferences prefs`
/// that was **never initialised** by `main()`, so the first read threw
/// `LateInitializationError`. Here the store is initialised during bootstrap
/// and every getter is defensive, so an uninitialised or missing value returns
/// a default instead of crashing.
abstract final class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  /// Whether [init] has completed successfully.
  static bool get isInitialized => _prefs != null;

  /// Loads the preference store. Call once from `main()`.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences? get _store => _prefs;

  static String? getString(String key) => _store?.getString(key);

  static Future<bool> setString(String key, String value) async =>
      _store?.setString(key, value) ?? Future.value(false);

  static bool? getBool(String key) => _store?.getBool(key);

  static Future<bool> setBool(String key, bool value) async =>
      _store?.setBool(key, value) ?? Future.value(false);

  static int? getInt(String key) => _store?.getInt(key);

  static Future<bool> setInt(String key, int value) async =>
      _store?.setInt(key, value) ?? Future.value(false);

  static String? getStringOrDefault(String key, String fallback) =>
      _store?.getString(key) ?? fallback;

  static Future<bool> remove(String key) async =>
      _store?.remove(key) ?? Future.value(false);

  /// Clears every stored key.
  static Future<bool> clear() async => _store?.clear() ?? Future.value(false);
}
