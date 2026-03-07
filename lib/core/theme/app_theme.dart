import 'package:flutter/material.dart';

class AppTheme {
  // Garmin Connect Style Palette
  static const Color background = Color(0xFF000000);   // True black or very deep black
  static const Color surface = Color(0xFF1C1C1E);      // Grey card surface
  static const Color primaryBlue = Color(0xFF3399FF);  // Garmin Blue
  
  // Metric Colors
  static const Color hrRed = Color(0xFFFF453A);
  static const Color batteryBlue = Color(0xFF64D2FF);
  static const Color greenStatus = Color(0xFF32D74B);
  static const Color loadOrange = Color(0xFFFF9F0A);
  static const Color sleepPurple = Color(0xFFBF5AF2);

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
        surface: surface,
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
}