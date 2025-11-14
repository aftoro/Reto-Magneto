import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Utilidades para diseño responsive
/// Proporciona helpers para detectar plataforma y breakpoints
class Responsive {
  // Breakpoints estándar
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  /// Detecta si la app está corriendo en web
  static bool get isWeb => kIsWeb;

  /// Detecta si la app está corriendo en mobile (no web)
  static bool get isMobile => !kIsWeb;

  /// Obtiene el ancho de la pantalla
  static double screenWidth(BuildContext context) {
    try {
      final mediaQuery = MediaQuery.maybeOf(context);
      if (mediaQuery != null) {
        return mediaQuery.size.width;
      }
      // Fallback para web cuando MediaQuery no está disponible
      return kIsWeb ? 1200.0 : 375.0;
    } catch (e) {
      return kIsWeb ? 1200.0 : 375.0;
    }
  }

  /// Obtiene la altura de la pantalla
  static double screenHeight(BuildContext context) {
    try {
      final mediaQuery = MediaQuery.maybeOf(context);
      if (mediaQuery != null) {
        return mediaQuery.size.height;
      }
      // Fallback para web cuando MediaQuery no está disponible
      return kIsWeb ? 800.0 : 667.0;
    } catch (e) {
      return kIsWeb ? 800.0 : 667.0;
    }
  }

  /// Detecta si es mobile (< 600px)
  static bool isMobileSize(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Detecta si es tablet (600px - 1200px)
  static bool isTabletSize(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Detecta si es desktop (> 1200px)
  static bool isDesktopSize(BuildContext context) {
    return screenWidth(context) >= tabletBreakpoint;
  }

  /// Retorna el tipo de dispositivo según el tamaño
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobileSize(context)) return DeviceType.mobile;
    if (isTabletSize(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Obtiene el número de columnas según el breakpoint
  static int getColumnCount(BuildContext context) {
    if (isMobileSize(context)) return 1;
    if (isTabletSize(context)) return 2;
    return 3;
  }

  /// Obtiene el ancho máximo del contenido según la plataforma
  static double getMaxContentWidth(BuildContext context) {
    if (isMobileSize(context)) return double.infinity;
    if (isTabletSize(context)) return 900;
    return 1200;
  }

  /// Obtiene padding horizontal adaptativo
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isMobileSize(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    if (isTabletSize(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 48);
  }

  /// Obtiene padding vertical adaptativo
  static EdgeInsets getVerticalPadding(BuildContext context) {
    if (isMobileSize(context)) {
      return const EdgeInsets.symmetric(vertical: 16);
    }
    return const EdgeInsets.symmetric(vertical: 24);
  }

  /// Obtiene padding completo adaptativo
  static EdgeInsets getPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: isMobileSize(context)
          ? 16
          : (isTabletSize(context) ? 32 : 48),
      vertical: isMobileSize(context) ? 16 : 24,
    );
  }

  /// Obtiene el ancho del sidebar para web
  static double getSidebarWidth(BuildContext context) {
    if (isMobileSize(context)) return 0;
    if (isTabletSize(context)) return 240;
    return 280;
  }

  /// Widget builder responsive que retorna diferentes widgets según el tamaño
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktopSize(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTabletSize(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Obtiene el tamaño de fuente adaptativo
  static double getAdaptiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktopSize(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTabletSize(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Obtiene el tamaño de ícono adaptativo
  static double getAdaptiveIconSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktopSize(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isTabletSize(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

/// Tipo de dispositivo
enum DeviceType { mobile, tablet, desktop }

/// Extensiones para facilitar el uso
extension ResponsiveExtension on BuildContext {
  bool get isMobile {
    try {
      return Responsive.isMobileSize(this);
    } catch (e) {
      return false;
    }
  }

  bool get isTablet {
    try {
      return Responsive.isTabletSize(this);
    } catch (e) {
      return false;
    }
  }

  bool get isDesktop {
    try {
      return Responsive.isDesktopSize(this);
    } catch (e) {
      return false;
    }
  }

  DeviceType get deviceType {
    try {
      return Responsive.getDeviceType(this);
    } catch (e) {
      return DeviceType.mobile;
    }
  }

  double get screenWidth => Responsive.screenWidth(this);
  double get screenHeight => Responsive.screenHeight(this);
  double get maxContentWidth => Responsive.getMaxContentWidth(this);
  EdgeInsets get horizontalPadding => Responsive.getHorizontalPadding(this);
  EdgeInsets get verticalPadding => Responsive.getVerticalPadding(this);
  EdgeInsets get adaptivePadding => Responsive.getPadding(this);
  double get sidebarWidth => Responsive.getSidebarWidth(this);
  int get columnCount => Responsive.getColumnCount(this);
}
