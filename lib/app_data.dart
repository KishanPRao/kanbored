// TODO: rename?
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static Future<void> loadSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static late SharedPreferences _preferences;
  static const prefTheme = "theme";
  static const prefApiToken = "api_token";
  static const prefApiEndpoint = "api_endpoint";

  static String getString(String key, String defaultValue) =>
      _preferences.getString(key) ?? defaultValue;

  static void setString(String key, String value) =>
      _preferences.setString(key, value);
}
