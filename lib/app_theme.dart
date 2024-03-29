import 'package:flutter/material.dart';
import 'package:kanbored/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors_extension.dart';
import 'theme_reader.dart';

class AppTheme with ChangeNotifier {
  static Future<void> loadAllThemes() async {
    ThemeReader.readTheme('assets/light_theme.json').then((value) => _lightAppColors = value);
    ThemeReader.readTheme('assets/dark_theme.json').then((value) => _darkAppColors = value);
  }
  static late AppColorsExtension _lightAppColors;
  static late AppColorsExtension _darkAppColors;
  // TODO: custom theme possible? Or "Custom dark"/"Custom light" themes, replace existing light/dark theme files
  static final light = ThemeData.light().copyWith(extensions: [_lightAppColors]);
  static final dark = ThemeData.dark().copyWith(extensions: [_darkAppColors]);

  ThemeMode _themeMode = strToThemeMode(AppData.getString(AppData.prefTheme, "system"));
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    AppData.setString(AppData.prefTheme, themeModeToStr(themeMode));
    notifyListeners();
  }

  static ThemeMode strToThemeMode(String string) {
    switch (string) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  static String themeModeToStr(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
