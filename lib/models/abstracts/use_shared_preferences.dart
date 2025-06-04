import 'package:shared_preferences/shared_preferences.dart';

class UseSharedPreferences {
  static SharedPreferences? pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static void assertBeenInitialized() {
    assert(pref != null, "You need to intialize shared preferences");
  }

  static Future<void> setString(String key, String value) async {
    assertBeenInitialized();
    await pref!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    assertBeenInitialized();
    return pref!.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    assertBeenInitialized();
    await pref!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    assertBeenInitialized();
    return pref!.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    assertBeenInitialized();
    await pref!.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    assertBeenInitialized();
    return pref!.getInt(key);
  }

  static Future<void> setDouble(String key, double value) async {
    assertBeenInitialized();
    await pref!.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    assertBeenInitialized();
    return pref!.getDouble(key);
  }

  static Future<void> setStringList(
    String key,
    List<String> value,
  ) async {
    assertBeenInitialized();
    await pref!.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    assertBeenInitialized();
    return pref!.getStringList(key);
  }

  static Future<void> remove(String key) async {
    assertBeenInitialized();
    await pref!.remove(key);
  }

  static Future<void> clear() async {
    assertBeenInitialized();
    await pref!.clear();
  }

  static Future<bool> containsKey(String key) async {
    assertBeenInitialized();
    return pref!.containsKey(key);
  }
}
