// TODO: rename?
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static Future<void> loadSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static late SharedPreferences _preferences;
  // TODO: make private what shouldn't be exposed / has getter
  static const prefTheme = "theme";
  static const prefApiUsername = "api_username";
  static const prefApiPassword = "api_password";
  static const prefApiEndpoint = "api_endpoint";
  static const prefApiAuth = "api_auth";

  static String getString(String key, String defaultValue) =>
      _preferences.getString(key) ?? defaultValue;

  static void setString(String key, String value) =>
      _preferences.setString(key, value);

  static bool getBool(String key, bool defaultValue) =>
      _preferences.getBool(key) ?? defaultValue;

  static void setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  static set theme(String value) => setString(prefTheme, value);
  static String get theme => getString(prefTheme, "system");

  static set username(String value) => setString(prefApiUsername, value);
  static String get username => getString(prefApiUsername, "");

  static set password(String value) => setString(prefApiPassword, value);
  static String get password => getString(prefApiPassword, "");

  static set endpoint(String value) => setString(prefApiEndpoint, value);
  static String get endpoint => getString(prefApiEndpoint, "");

  static set authenticated(bool value) => setBool(prefApiAuth, value);
  static bool get authenticated => getBool(prefApiAuth, false);
}

