import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///App Themes
class Themes {
  ///Light Mode
  static ThemeData light() {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        titleTextStyle: TextStyle(
          color: Color(0xFF1F2A33),
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFFF5F5F5),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xFF1F2A33),
        secondary: const Color(0xFF008080),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF008080),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        displayColor: const Color(0xFF1F2A33),
        bodyColor: const Color(0xFF1F2A33),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF1F2A33),
      ),
      dialogBackgroundColor: const Color(0xFFF5F5F5),
    );
  }

  ///Dark Mode
  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        titleTextStyle: TextStyle(
          color: Color(0xFFFAFAFA),
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF161B22),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF13161B),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF212121),
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color(0xFFFAFAFA),
        secondary: const Color(0xFFE91E63),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFE91E63),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        displayColor: const Color(0xFFFAFAFA),
        bodyColor: const Color(0xFFFAFAFA),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFFAFAFA),
      ),
      dialogBackgroundColor: const Color(0xFF212121),
    );
  }
}
