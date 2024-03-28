import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors_extension.dart';

class ThemeReader {
  static AppColorsExtension readTheme(String jsonFile) {
    String jsonString = File(jsonFile).readAsStringSync();
    var colors = jsonDecode(jsonString)["colors"][0];
    return AppColorsExtension(
      primary: parseColor(colors, "primary")
    );
  }

  static Color parseColor(dynamic colors, String name) =>
      Color(int.parse(colors[name] ?? "0xFF000000"));
}
