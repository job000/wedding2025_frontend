import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._(); // Private konstruktør for å forhindre instansiering

  // Hovedfarger - Oppdatert til mer elegante toner
  static const Color primary = Color(0xFF94A5C8);      // Elegant sølvblå
  static const Color secondary = Color(0xFFE5B6A4);    // Varm fersken
  static const Color tertiary = Color(0xFFB3C5A3);     // Myk salvie

  // Nøytrale farger - Rene og sofistikerte
  static const Color neutral50 = Color(0xFFFAFAFA);    // Nesten hvit
  static const Color neutral100 = Color(0xFFF5F5F5);   // Off-white
  static const Color neutral200 = Color(0xFFEEEEEE);   // Veldig lys grå
  static const Color neutral300 = Color(0xFFE0E0E0);   // Lys grå
  static const Color neutral400 = Color(0xFFBDBDBD);   // Middels lys grå
  static const Color neutral500 = Color(0xFF9E9E9E);   // Medium grå
  static const Color neutral600 = Color(0xFF757575);   // Middels mørk grå
  static const Color neutral700 = Color(0xFF616161);   // Mørk grå
  static const Color neutral800 = Color(0xFF424242);   // Veldig mørk grå
  static const Color neutral900 = Color(0xFF212121);   // Nesten svart

  // Bakgrunnsfarger - Beholder eksisterende med noen justeringer
  static const Color background = Color(0xFFFCFCFC);   // Lysere, renere hvit
  static const Color darkBackground = Color(0xFF1A1B1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF2C2D30);

  // Tekstfarger - Forbedret lesbarhet
  static const Color textPrimary = Color(0xFF2C2C2C);  // Mykere svart
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFF8F9FC);
  static const Color textDark = Color(0xFF1A1B1E);

  

  // Statusfarger - Mer dempede toner
  static const Color success = Color(0xFF7BA686);      // Dempet grønn
  static const Color error = Color(0xFFCF8B8B);        // Dempet rød
  static const Color warning = Color(0xFFE6C683);      // Dempet gul
  static const Color info = Color(0xFF8BADC5);         // Dempet blå

  // Gradientfarger - Mykere overganger
  static const List<Color> primaryGradient = [
    Color(0xFF94A5C8),                                // Starter med primary
    Color(0xFFB4C5D5),                                // Lysere variant
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFE5B6A4),                                // Starter med secondary
    Color(0xFFE8C4C4),                                // Lysere variant
  ];

  // Overlay farger - Beholder eksisterende
  static const Color overlay = Color(0x801A1B1E);
  static const Color lightOverlay = Color(0x40FFFFFF);

  // Border farger - Beholder eksisterende
  static const Color border = Color(0xFFE5E6E9);
  static const Color darkBorder = Color(0xFF3A3B3E);

  // Skyggefarger - Beholder eksisterende
  static const Color shadow = Color(0x40000000);
  static const Color lightShadow = Color(0x20000000);

  // Spesialfarger for bryllupstema - Oppdatert til mer elegante toner
  static const Color romantic = Color(0xFFF5E6E8);    // Mykere rosa
  static const Color gold = Color(0xFFD4B686);        // Champagne gull
  static const Color champagne = Color(0xFFF7E8D0);   // Varmere champagne
  static const Color blush = Color(0xFFE8C4C4);       // Mykere blush
  static const Color sage = Color(0xFFD7E4D4);        // Dempet salvie
  static const Color dustyRose = Color(0xFFE5B6A4);   // Varmere dusty rose
  static const Color navy = Color(0xFF2F4F4F);        // Mykere navy
  static const Color burgundy = Color(0xFF8B4513);    // Varmere burgundy

  // Animasjonsfarger - Beholder eksisterende
  static const List<Color> shimmerGradient = [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ];

  // Genererer Material Color - Beholder eksisterende funksjon
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

  // Opacity variants - Beholder eksisterende
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Brightness sjekk - Beholder eksisterende
  static bool isDark(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  }

  // Kontrast farge - Beholder eksisterende
  static Color contrastColor(Color backgroundColor) {
    return isDark(backgroundColor) ? Colors.white : Colors.black;
  }

  // Fargepaletter for forskjellige seksjoner - Oppdatert med nye farger
  static const colorPalettes = {
    'welcome': [
      Color(0xFF94A5C8),    // Primary
      Color(0xFFE5B6A4),    // Secondary
      Color(0xFFB3C5A3),    // Tertiary
    ],
    'ceremony': [
      Color(0xFFF5E6E8),    // Romantic
      Color(0xFFD4B686),    // Gold
      Color(0xFFF7E8D0),    // Champagne
    ],
    'party': [
      Color(0xFFE8C4C4),    // Blush
      Color(0xFFD7E4D4),    // Sage
      Color(0xFFE5B6A4),    // DustyRose
    ],
    'dinner': [
      Color(0xFF2F4F4F),    // Navy
      Color(0xFF8B4513),    // Burgundy
      Color(0xFFD4B686),    // Gold
    ],
  };

  // Nye hjelpemetoder for fargehåndtering
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}