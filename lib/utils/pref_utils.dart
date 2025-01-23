import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  factory PrefUtils() {
    return _singleton;
  }

  PrefUtils._internal();

  static final PrefUtils _singleton = PrefUtils._internal();

  SharedPreferences? _storagePrefs;

  Future initializeSharedPreference() async {
    await SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      _storagePrefs = prefs;
    });
  }

  static String keyThemeData = "keyThemeData";

  String getString(String key) {
    return _storagePrefs?.getString(key) ?? "";
  }

  bool getBool(String key) {
    return _storagePrefs?.getBool(key) ?? false;
  }

  int getInt(String key) {
    return _storagePrefs?.getInt(key) ?? -1;
  }

  double getDouble(String key) {
    return _storagePrefs?.getDouble(key) ?? 0.0;
  }

  Future saveString(String key, String value) async {
    await _storagePrefs?.setString(key, value);
  }

  Future saveBool(String key, bool value) async {
    await _storagePrefs?.setBool(key, value);
  }

  Future saveDouble(String key, double value) async {
    await _storagePrefs?.setDouble(key, value);
  }

  Future saveInt(String key, int value) async {
    await _storagePrefs?.setInt(key, value);
  }

  Future clearPreference() async {
    await _storagePrefs?.clear();
  }

  bool? checkKey(String key) {
    return _storagePrefs?.containsKey(key);
  }

  String getThemeData(key) {
    try {
      if (_storagePrefs!.containsKey(key)) {
        return _storagePrefs!.getString(key)!;
      } else {
        return 'primary';
      }
    } catch (e) {
      return 'primary';
    }
  }

  void clearPreferenceAndDB() {
    _storagePrefs?.clear();
  }
}
