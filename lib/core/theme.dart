import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppGradients {
  static const LinearGradient metallicGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF3E2B3),
      Color(0xFFD4AF37),
      Color(0xFFAA7E25),
      Color(0xFFE5C885),
    ],
    stops: [0.0, 0.4, 0.8, 1.0],
  );

  static const LinearGradient glassBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white54,
      Colors.white10,
      Colors.transparent,
      Colors.white24,
    ],
    stops: [0.0, 0.3, 0.8, 1.0],
  );
}

class AppTheme {
  static const Color colorBackground = Color(0xFF0F201D);
  static const Color colorBackgroundLight = Color(0xFF1D3E38);
  static const Color colorSurface = Color(0xFFE8DFC8);
  static const Color colorOnSurface = Color(0xFF0F201D);
  static const Color colorOnBackground = Color(0xFFFFFFFF);
  static const Color colorAccent = Color(0xFFD4C381);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorBackground,
      colorScheme: const ColorScheme.dark( 
        primary: colorAccent,
        secondary: colorSurface,
        surface: colorBackground,
        onSurface: colorOnBackground,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          color: colorOnBackground,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
        titleLarge: GoogleFonts.dmSans(
          color: colorOnBackground,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
        titleMedium: GoogleFonts.dmSans(
          color: colorOnBackground,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
        titleSmall: GoogleFonts.dmSans(
          color: colorOnBackground,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.8,
        ),
        bodyLarge: GoogleFonts.dmSans(
          color: colorOnBackground.withValues(alpha: 0.9),
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: GoogleFonts.dmSans(
          color: colorOnBackground.withValues(alpha: 0.8),
          fontWeight: FontWeight.w300,
        ),
        bodySmall: GoogleFonts.dmSans(
          color: colorOnBackground.withValues(alpha: 0.7),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
