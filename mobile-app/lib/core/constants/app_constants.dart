import 'package:flutter/material.dart';

class AppConstants {
  // ============================================
  // PALETA DE COLORES - IDENTIDAD DE MARCA
  // ============================================
  
  // Colores principales según guía de marca
  static const Color darkPurple = Color(0xFF200054); // Morado oscuro - CMYK: C:100 M:100 Y:32 K:36, RGB: R:32 G:0 B:84
  static const Color purple = Color(0xFF7C00FF); // Púrpura - CMYK: C:80 M:80 Y:0 K:0, RGB: R:124 G:0 B:255
  static const Color mintGreen = Color(0xFF22D3B7); // Verde menta/teal - CMYK: C:66 M:0 Y:40 K:0
  
  // Colores del logotipo (solo para logo)
  static const Color logoGreen = Color(0xFF0CBB4E); // Verde brillante del logo
  static const Color logoLightGreen = Color(0xFF3DC971); // Verde claro del logo
  static const Color logoDarkBlue = Color(0xFF001B38); // Azul muy oscuro del logo
  
  // Colores principales de la app (basados en la paleta de marca)
  static const Color primaryColor = purple; // Púrpura principal
  static const Color primaryVariant = darkPurple; // Morado oscuro
  static const Color secondaryColor = mintGreen; // Verde menta
  static const Color secondaryVariant = Color(0xFF1AB89A); // Variante del verde menta
  
  // Colores de fondo
  static const Color backgroundColor = Color(0xFFFFFFFF); // Fondo principal blanco
  static const Color surfaceColor = Color(0xFFFFFFFF); // Superficies claras
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Colores de texto (modo claro)
  static const Color textPrimary = Color(0xFF1A1A1A); // Casi negro para máximo contraste
  static const Color textSecondary = Color(0xFF6B7280); // Gris medio para texto secundario
  static const Color textTertiary = Color(0xFF9CA3AF); // Gris claro para texto terciario
  
  // Colores de estado
  static const Color successColor = mintGreen; // Usar verde menta para éxito
  static const Color errorColor = Color(0xFFEF4444); // Rojo moderno
  static const Color warningColor = Color(0xFFF59E0B); // Amarillo/naranja
  static const Color infoColor = Color(0xFF3B82F6); // Azul para información
  
  // Colores de gradiente basados en el logo
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente principal de la marca (morado profundo → morado)
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryVariant, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Espaciado
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Bordes redondeados
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Sombras
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
  
  // Duración de animaciones
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
}
