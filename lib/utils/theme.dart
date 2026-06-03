// lib/utils/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.bgColor,
        colorScheme: const ColorScheme.dark(
          primary: AppConstants.playerColor,
          secondary: AppConstants.voidEdge,
          surface: AppConstants.cardBg,
        ),
        textTheme: GoogleFonts.orbitronTextTheme(
          ThemeData.dark().textTheme,
        ),
      );

  static TextStyle neonText({
    double fontSize = 16,
    Color color = AppConstants.playerColor,
    FontWeight weight = FontWeight.bold,
  }) =>
      GoogleFonts.orbitron(
        fontSize: fontSize,
        fontWeight: weight,
        color: color,
        shadows: [
          Shadow(color: color.withOpacity(0.8), blurRadius: 10),
          Shadow(color: color.withOpacity(0.4), blurRadius: 20),
          Shadow(color: color.withOpacity(0.2), blurRadius: 40),
        ],
      );
}
