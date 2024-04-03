import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeReader {
  static Future<AppColorsExtension> readTheme(String jsonFile) async {
    var jsonString = await rootBundle.loadString(jsonFile);
    var colors = jsonDecode(jsonString)["colors"][0];
    return AppColorsExtension(
      primary: _parseColor(colors, "primary"),
      pageBg: _parseColor(colors, "pageBg"),
      cardBg: _parseColor(colors, "cardBg"),
      descBg: _parseColor(colors, "descBg"),
    );
  }

  static Color _parseColor(dynamic colors, String name) =>
      Color(int.parse(colors[name] ?? "0xFF000000"));
}

// TODO: Use generics? Simplify repetitive copy
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.pageBg,
    required this.cardBg,
    required this.descBg,
  });
  final Color primary;
  final Color pageBg;
  final Color cardBg;
  final Color descBg;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? pageBg,
    Color? cardBg,
    Color? descBg,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      pageBg: pageBg ?? this.pageBg,
      cardBg: cardBg ?? this.cardBg,
      descBg: descBg ?? this.descBg,
    );
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
      primary: Color.lerp(primary, other.primary, t)!,
      pageBg: Color.lerp(pageBg, other.pageBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      descBg: Color.lerp(descBg, other.descBg, t)!,
    );
  }
}