import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/utils/app_data.dart';
import 'package:kanbored/utils/constants.dart';

import 'app_colors_extension.dart';

class AppTheme with ChangeNotifier {
  static Future<void> initialize() async {
    ThemeReader.readTheme('assets/light_theme.json')
        .then((value) => _lightAppColors = value);
    ThemeReader.readTheme('assets/dark_theme.json')
        .then((value) => _darkAppColors = value);
    ThemeReader.readTheme('assets/amolded_theme.json')
        .then((value) => _amoldedAppColors = value);
  }

  static late AppColorsExtension _lightAppColors;
  static late AppColorsExtension _darkAppColors;
  static late AppColorsExtension _amoldedAppColors;

  // TODO: custom theme possible? Or "Custom dark"/"Custom light" themes, replace existing light/dark theme files
  static final light =
      ThemeData.light().copyWith(extensions: [_lightAppColors]);
  static final dark = ThemeData.dark().copyWith(extensions: [_darkAppColors]);
  static final amolded =
      ThemeData.dark().copyWith(extensions: [_amoldedAppColors]);

  // ThemeMode _themeMode = strToThemeMode(AppData.theme);

  String get themeMode => AppData.theme;

  set themeMode(String themeMode) {
    // _themeMode = strToThemeMode(themeMode);
    AppData.theme = themeMode;
    notifyListeners();
  }

  static ThemeMode strToThemeMode(String string) {
    switch (string) {
      case themeLight:
        return ThemeMode.light;
      case themeDark:
      case themeAmolded:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToStr(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return themeLight;
      case ThemeMode.dark:
        if (AppData.theme == themeAmolded) {
          return themeAmolded;
        }
        return themeDark;
      default:
        return themeSystem;
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

final themeProvider = ChangeNotifierProvider((_) => AppTheme());