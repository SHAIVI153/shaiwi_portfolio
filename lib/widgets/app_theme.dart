import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background  = Color(0xFF050A0F);
  static const Color surface     = Color(0xFF0D1520);
  static const Color card        = Color(0xFF0F1C2E);
  static const Color primary     = Color(0xFF00D4FF);
  static const Color secondary   = Color(0xFF7B2FFF);
  static const Color accent      = Color(0xFF00FF88);
  static const Color textPrimary = Color(0xFFEEF2FF);
  static const Color textSecondary = Color(0xFF8899BB);
  static const Color border      = Color(0xFF1A2D45);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme,
      ),
      // Remove all scroll glow / overscroll effects
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.border),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),
    );
  }
}