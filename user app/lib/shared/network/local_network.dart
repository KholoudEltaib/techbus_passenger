import 'package:shared_preferences/shared_preferences.dart';

class CashNetwork {
  static late SharedPreferences sharedPref;

  static Future<void> cashInitialization() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> saveCacheData({
    required String key,
    required String value,
  }) async {
    return await sharedPref.setString(key, value);
  }

  static String getCacheData({required String key}) {
    return sharedPref.getString(key) ?? "";
  }

  static Future<bool> deleteCacheItem({required String key}) async {
    return await sharedPref.remove(key);
  }
}
