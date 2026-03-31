import 'package:flutter/material.dart';

class AdminColors {
  // Primary Palette (Premium Dark Theme)
  static const Color primaryTeal = Color(0xFF00BFA5);
  static const Color secondaryCyan = Color(0xFF00E5FF);
  
  static const Color backgroundBlack = Color(0xFF0E1111);
  static const Color surfaceDark = Color(0xFF1C1F21);
  static const Color surfaceLight = Color(0xFF2C2F33);
  
  static const Color textHigh = Color(0xFFFFFFFF);
  static const Color textMedium = Color(0xFFB0B3B8);
  static const Color textLow = Color(0xFF72767D);
  
  static const Color errorRed = Color(0xFFFF5252);
  static const Color successGreen = Color(0xFF69F0AE);
  static const Color warningOrange = Color(0xFFFFAB40);

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryTeal, secondaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
