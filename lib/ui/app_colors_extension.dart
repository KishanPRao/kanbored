import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeReader {
  static Future<AppColorsExtension> readTheme(String jsonFile) async {
    var jsonString = await rootBundle.loadString(jsonFile);
    var colors = jsonDecode(jsonString)["colors"];
    return AppColorsExtension(
      colors: (colors as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, _parseColor(value))),
    );
  }

  static Color _parseColor(String value) => Color(int.parse(value));
}

// TODO: Use generics? Simplify repetitive copy
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.colors,
  });

  final Map<String, Color> colors;

  @override
  ThemeExtension<AppColorsExtension> copyWith({Map<String, Color>? colors}) {
    return AppColorsExtension(colors: colors ?? {});
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      colors: colors.map((key, value) =>
          MapEntry(key, Color.lerp(value, other.colors[key], t)!)),
    );
  }
}
