import 'package:flutter/material.dart';

class AppConstants {
  // Colores principales basados en el logo de magneto empleos
  static const Color primaryColor = Color(0xFF00D4AA); // Verde vibrante del logo
  static const Color primaryVariant = Color(0xFF00B894); // Verde más oscuro
  static const Color secondaryColor = Color(0xFF1E3A8A); // Azul oscuro del fondo
  static const Color secondaryVariant = Color(0xFF1E40AF); // Azul más claro
  
  // Colores de fondo
  static const Color backgroundColor = Color(0xFFF8FAFC); // Gris muy claro
  static const Color surfaceColor = Color(0xFFFFFFFF); // Blanco puro
  static const Color cardColor = Color(0xFFFFFFFF); // Blanco puro
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF1E293B); // Azul muy oscuro
  static const Color textSecondary = Color(0xFF64748B); // Gris azulado
  static const Color textTertiary = Color(0xFF94A3B8); // Gris claro
  
  // Colores de estado
  static const Color successColor = Color(0xFF00D4AA); // Verde del logo
  static const Color errorColor = Color(0xFFEF4444); // Rojo
  static const Color warningColor = Color(0xFFF59E0B); // Amarillo
  static const Color infoColor = Color(0xFF1E3A8A); // Azul del logo
  
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
  
  // Gradiente principal de la marca (azul a verde)
  static const LinearGradient brandGradient = LinearGradient(
    colors: [secondaryColor, primaryColor],
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
