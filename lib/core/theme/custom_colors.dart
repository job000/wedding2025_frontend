import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._(); // Private konstruktør for å forhindre instansiering

  // Hovedfarger
  static const Color primary = Color(0xFF6B4EFF);
  static const Color secondary = Color(0xFFFF4E8C);
  static const Color tertiary = Color(0xFF4EFFB5);

  // Bakgrunnsfarger
  static const Color background = Color(0xFFF8F9FC);
  static const Color darkBackground = Color(0xFF1A1B1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF2C2D30);

  // Tekstfarger
  static const Color textPrimary = Color(0xFF1A1B1E);
  static const Color textSecondary = Color(0xFF6B6C6E);
  static const Color textLight = Color(0xFFF8F9FC);
  static const Color textDark = Color(0xFF1A1B1E);

  // Statusfarger
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF4E4E);
  static const Color warning = Color(0xFFFFB84E);
  static const Color info = Color(0xFF4E9FFF);

  // Gradientfarger
  static const List<Color> primaryGradient = [
    Color(0xFF6B4EFF),
    Color(0xFF9747FF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF4E8C),
    Color(0xFFFF47B8),
  ];

  // Overlay farger
  static const Color overlay = Color(0x801A1B1E);
  static const Color lightOverlay = Color(0x40FFFFFF);

  // Border farger
  static const Color border = Color(0xFFE5E6E9);
  static const Color darkBorder = Color(0xFF3A3B3E);

  // Skyggefarger
  static const Color shadow = Color(0x40000000);
  static const Color lightShadow = Color(0x20000000);

  // Spesialfarger for bryllupstema
  static const Color romantic = Color(0xFFFFF0F5);
  static const Color gold = Color(0xFFFFD700);
  static const Color champagne = Color(0xFFF7E7CE);
  static const Color blush = Color(0xFFFFB6C1);
  static const Color sage = Color(0xFFBCDBBE);
  static const Color dustyRose = Color(0xFFDC8B9D);
  static const Color navy = Color(0xFF000080);
  static const Color burgundy = Color(0xFF800020);

  // Animasjonsfarger
  static const List<Color> shimmerGradient = [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ];

  // Genererer Material Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // Opacity variants
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Brightness sjekk
  static bool isDark(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  }

  // Kontrast farge
  static Color contrastColor(Color backgroundColor) {
    return isDark(backgroundColor) ? Colors.white : Colors.black;
  }

  // Fargepaletter for forskjellige seksjoner
  static const colorPalettes = {
    'welcome': [
      Color(0xFF6B4EFF),
      Color(0xFFFF4E8C),
      Color(0xFF4EFFB5),
    ],
    'ceremony': [
      Color(0xFFFFF0F5),
      Color(0xFFFFD700),
      Color(0xFFF7E7CE),
    ],
    'party': [
      Color(0xFFFFB6C1),
      Color(0xFFBCDBBE),
      Color(0xFFDC8B9D),
    ],
    'dinner': [
      Color(0xFF000080),
      Color(0xFF800020),
      Color(0xFFFFD700),
    ],
  };
}