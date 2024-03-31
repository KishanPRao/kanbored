import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors_extension.dart';

class ThemeReader {
  static Future<AppColorsExtension> readTheme(String jsonFile) async {
    var jsonString = await rootBundle.loadString(jsonFile);
    var colors = jsonDecode(jsonString)["colors"][0];
    return AppColorsExtension(
      primary: _parseColor(colors, "primary"),
      pageBg: _parseColor(colors, "pageBg"),
      cardBg: _parseColor(colors, "cardBg"),
    );
  }

  static Color _parseColor(dynamic colors, String name) =>
      Color(int.parse(colors[name] ?? "0xFF000000"));
}
