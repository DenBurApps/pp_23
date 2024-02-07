import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color green;
  final Color red;

  const CustomColors({
    required this.green,
    required this.red,
  });

  @override
  CustomColors copyWith({
    Color? green,
    Color? red,
  }) {
    return CustomColors(
      green: green ?? this.green,
      red: red ?? this.red,
    );
  }

  static const value = CustomColors(
    green: Color(0xFFB5FFB4),
    red: Color(0xFFEE8787),
  );

  @override
  ThemeExtension<CustomColors> lerp(
      covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      green: Color.lerp(green, other.green, t)!,
      red: Color.lerp(red, other.red, t)!,
    );
  }
}
