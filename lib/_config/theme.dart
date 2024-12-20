import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeConfig() {
  late Color primaryColor = Colors.green; // 4CAF50
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.questrial()
        .fontFamily, // questrial, comfortaa, outfit, poiretOne, catamaran, josefinSans, dosis, poppins
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      // brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        // fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}
