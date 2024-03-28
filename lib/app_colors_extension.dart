import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary
  });
  final Color primary;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
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
    );
  }
}