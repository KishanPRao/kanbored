import 'package:flutter/material.dart';

// TODO: Use generics? Simplify repetitive copy
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.pageBg,
    required this.cardBg,
  });
  final Color primary;
  final Color pageBg;
  final Color cardBg;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? pageBg,
    Color? cardBg,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      pageBg: pageBg ?? this.pageBg,
      cardBg: cardBg ?? this.cardBg,
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
    );
  }
}