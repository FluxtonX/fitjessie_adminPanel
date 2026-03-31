import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_colors.dart';

class AdminTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AdminColors.backgroundBlack,
    primaryColor: AdminColors.primaryTeal,
    colorScheme: const ColorScheme.dark(
      primary: AdminColors.primaryTeal,
      secondary: AdminColors.secondaryCyan,
      surface: AdminColors.surfaceDark,
      error: AdminColors.errorRed,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineMedium: const TextStyle(
        color: AdminColors.textHigh,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: const TextStyle(color: AdminColors.textMedium),
    ),
    cardTheme: CardThemeData(
      color: AdminColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
      ),
    ),
  );
}
