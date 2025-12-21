import 'dart:ui';

/// 🎨 Centralized color palette for the Coffee App
/// ------------------------------------------------------
/// This file ensures all colors remain consistent
/// across light, dark, and accent UI elements.
/// ------------------------------------------------------
class MyColors {
  // 🌑 APP BACKGROUNDS
  static const Color scaffoldBackground = Color(0xFF000000); // Pure black
  static const Color backgroundDarkest = Color(0xFF050505); // Near-black base
  static const Color backgroundDarker = Color(0xFF111111); // Ultra dark gray
  static const Color backgroundGray = Color(0xFF242424); // Common dark gray
  static const Color backgroundMediumGray = Color(0xFF2A2A2A); // Slightly lighter gray
  static const Color backgroundMid = Color(0xFF313131); // Used for cards or containers
  static const Color backgroundAccent = Color(0xFFA2A2A2); // Supporting gray tone
  static const Color backgroundLightGray = Color(0xFFD8D8D8); // Light gray for contrast areas
  static const Color backgroundMuted = Color(0xFF909090); // Subtle muted tone
  static const Color backgroundDarkWhite= Color(0xFFEDEDED); //home page

  // ✨ TEXT COLORS
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFA2A2A2); // Subtle gray text
  static const Color textMuted = Color(0xFFD8D8D8); // Muted lighter text
  static const Color textInverse = Color(0xFF000000); // For light backgrounds
  static const Color line = Color(0xFFF9F2ED); // For line


  // ☕ BRAND & ACCENTS
  static const Color brandPrimary = Color(0xFFC67C4E); // Coffee brown (main brand)
  static const Color brandAccent = Color(0xFFED5151); // Red for banners/alerts

  // 🧱 UI ELEMENTS
  static const Color cardColor = Color(0xFF2A2A2A); // Elevated card surfaces
  static const Color borderColor = Color(0xFFE3E3E3); // Light gray border
  static const Color dividerColor = Color(0xFFE3E3E3); // Divider lines
  static const Color iconInactive = Color(0xFF313131); // Muted inactive icon color
  static const Color iconActive = Color(0xFFC67C4E); // Active state icons
  static const Color buttonColor = brandPrimary; // Default button color

  // 🌈 GRADIENTS
  static const Color gradientTransparent = Color(0x00000000); // Fully transparent
  static const Color gradientOverlay = Color.fromRGBO(0, 0, 0, 0.8); // Black overlay gradient
  static const List<Color> darkGradient = [
    Color(0xFF111111),
    Color(0xFF313131),
  ];

  // 💡 UTILITY / STATUS COLORS
  static const Color success = Color(0xFF4CAF50); // Green success tone
  static const Color warning = Color(0xFFFFC107); // Amber warning
  static const Color error = Color(0xFFED5151); // Red error tone
  static const Color info = Color(0xFF2196F3); // Blue info tone
  static const Color backgroundWhite = Color(0xFFF8F6F2); // original beige
  static const Color textDark = Color(0xFF242424); // for text on light background
  static const Color textLight = Color(0xFFFFFFFF); // for text on dark background

  static const Color shadow = Color(0x33000000); // 20% black shadow

}
