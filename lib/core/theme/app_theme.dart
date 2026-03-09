import 'package:flutter/material.dart';

class AppTheme {
  // Garmin Connect Style Palette
  static const Color background =
      Color(0xFF000000); // True black or very deep black
  static const Color surface = Color(0xFF1C1C1E); // Grey card surface
  static const Color primaryBlue = Color(0xFF3399FF); // Garmin Blue

  // Metric Colors
  static const Color hrRed = Color(0xFFFF453A);
  static const Color batteryBlue = Color(0xFF64D2FF);
  static const Color greenStatus = Color(0xFF32D74B);
  static const Color loadOrange = Color(0xFFFF9F0A);
  static const Color sleepPurple = Color(0xFFBF5AF2);

  // Glassmorphism tokens
  static Color get glassCardColor => Colors.white.withValues(alpha: 0.18);
  static Color get glassBorderColor => Colors.white.withValues(alpha: 0.25);

  static BoxDecoration glassDecoration({double radius = 16, bool hasBorder = true}) => 
    BoxDecoration(
      color: glassCardColor,
      borderRadius: BorderRadius.circular(radius),
      border: hasBorder ? Border.all(color: glassBorderColor, width: 1.2) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        surface: const Color(0xFF2C2C2E), // Improved contrast
      ),
      scaffoldBackgroundColor: background,
      cardColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: background,
      ),
    );
  }

  static ThemeData get glassTheme {
    return darkTheme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      cardTheme: CardTheme(
        color: glassCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: glassBorderColor),
        ),
      ),
    );
  }
}
