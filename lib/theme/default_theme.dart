import 'package:flutter/material.dart';
import 'package:pp_23/theme/custom_colors.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultTheme {
  static final dark = AppTheme(
    id: 'dark',
    data: ThemeData(
      scaffoldBackgroundColor: darkColors.background,
      colorScheme: darkColors,
      textTheme: textTheme,
      extensions: const [CustomColors.value],
    ),
    description: 'App dark theme',
  );

  static final light = AppTheme(
    id: 'light',
    data: ThemeData(
      scaffoldBackgroundColor: ligthColors.background,
      colorScheme: ligthColors,
      textTheme: textTheme,
      extensions: const [CustomColors.value],
    ),
    description: 'App dark theme',
  );

  static const darkColors = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFD6CBE5),
    onPrimary: Color(0xFF171C21),
    secondary: Color(0xFF5393FF),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.black,
    onBackground: Colors.white,
    surface: Color(0xFF303030),
    onSurface: Colors.white,
    primaryContainer: Color(0xFF303030),
    onPrimaryContainer: Colors.white,
  );

  static const ligthColors = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD6CBE5),
    onPrimary: Color(0xFF171C21),
    secondary: Color(0xFF5393FF),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Color(0xFFC9C9C9),
    onSurface: Colors.black,
    primaryContainer: Colors.white,
    onPrimaryContainer: Colors.black,
  );

  static final textTheme = TextTheme(
    displayLarge: GoogleFonts.syne(
      fontSize: 50,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: GoogleFonts.syne(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: GoogleFonts.syne(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.workSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.workSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.workSans(
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.workSans(
      fontSize: 25,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: GoogleFonts.workSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: GoogleFonts.workSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}
