import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  StorageUtils._();
  static StorageUtils? _storageUtils;
  static SharedPreferences? _preferences;

  static Future<StorageUtils?> getInstance() async {
    if (_storageUtils == null) {
      var secureStorage = StorageUtils._();
      await secureStorage._init();
      _storageUtils = secureStorage;
    }
    return _storageUtils;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool>? remove(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }

  Future<bool>? clrAll() {
    var pref = _preferences!;
    return pref.clear();
  }

  Future<bool>? putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  String getString(String key, {defaultValue = ''}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getString(key) ?? defaultValue;
  }

  Future<bool>? putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences!.setInt(key, value);
  }

  int getINt(String key, {defaultValue = 0}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getInt(key) ?? defaultValue;
  }

  Future<bool>? putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }

  bool getBool(String key, {defaultValue = false}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getBool(key) ?? defaultValue;
  }

  Future<bool>? putListString(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences!.setStringList(key, value);
  }

  List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    if (_preferences == null) return [];
    return _preferences!.getStringList(key) ?? defaultValue;
  }
}
