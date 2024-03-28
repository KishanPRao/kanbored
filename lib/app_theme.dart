import 'package:flutter/material.dart';
import 'app_colors_extension.dart';
import 'theme_reader.dart';

class AppTheme with ChangeNotifier {
  static final lightAppColors = ThemeReader.readTheme('assets/lightTheme.json');
  static final darkAppColors = ThemeReader.readTheme('assets/darkTheme.json');
  static final light = ThemeData.light().copyWith(extensions: [lightAppColors]);
  static final dark = ThemeData.dark().copyWith(extensions: [darkAppColors]);

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme.lightAppColors;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
