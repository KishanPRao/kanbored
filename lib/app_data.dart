// TODO: rename?
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class AppData {
  static Future<void> initializeAppData() async {
    _preferences = await SharedPreferences.getInstance();
    // decryptedPassword = getString(prefApiPassword, "");
    _decryptedPassword =
        await const FlutterSecureStorage().read(key: prefApiPassword) ?? "";
  }

  static late SharedPreferences _preferences;

  // TODO: make private what shouldn't be exposed / has getter

  static String getString(String key, String defaultValue) =>
      _preferences.getString(key) ?? defaultValue;

  static void setString(String key, String value) =>
      _preferences.setString(key, value);

  static bool getBool(String key, bool defaultValue) =>
      _preferences.getBool(key) ?? defaultValue;

  static void setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  static int getInt(String key, int defaultValue) =>
      _preferences.getInt(key) ?? defaultValue;

  static void setInt(String key, int value) =>
      _preferences.setInt(key, value);

  static set theme(String value) => setString(prefTheme, value);

  static String get theme => getString(prefTheme, "system");

  static set username(String value) => setString(prefApiUsername, value);

  static String get username => getString(prefApiUsername, "");

  static void _setPassword(String value) async {
    await const FlutterSecureStorage()
        .write(key: prefApiPassword, value: value)
        .then((value) => print("Finished writing"))
        .catchError((e, st) {
      print("Failed to write! $e, $st");
    });
  }

  static set password(String value) {
    _decryptedPassword = value;
    _setPassword(value);
    // setString(prefApiPassword, value);
  }

  static late String _decryptedPassword;

  static String get password => _decryptedPassword;

  static set url(String value) => setString(prefApiUrl, value);

  static String get url => getString(prefApiUrl, "");

  static set endpoint(String value) => setString(prefApiEndpoint, value);

  static String get endpoint => getString(prefApiEndpoint, "");

  static set userId(int value) => setInt(prefApiUserid, value);

  static int get userId => getInt(prefApiUserid, 0);

  static set appRole(String value) => setString(prefApiRole, value);

  static String get appRole => getString(prefApiRole, "");

  static set authenticated(bool value) => setBool(prefApiAuth, value);

  static bool get authenticated => getBool(prefApiAuth, false);
}
