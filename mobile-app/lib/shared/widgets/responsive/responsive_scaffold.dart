import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

/// Scaffold adaptativo que cambia según la plataforma
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget? sidebar; // Sidebar para web
  final int? currentIndex; // Para navegación
  final Function(int)? onNavItemSelected; // Callback para navegación

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.sidebar,
    this.currentIndex,
    this.onNavItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar que MediaQuery esté disponible antes de usar context.isMobile
    final mediaQuery = MediaQuery.maybeOf(context);
    final isMobileSize = mediaQuery != null ? context.isMobile : false;

    // En web con sidebar, usar layout de dos columnas
    if (Responsive.isWeb && !isMobileSize && sidebar != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: Row(
          children: [
            // Sidebar
            sidebar!,
            // Contenido principal
            Expanded(child: body),
          ],
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );
    }

    // En mobile, usar scaffold normal con bottom navigation
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
