import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

/// Padding adaptativo según el tamaño de pantalla
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final EdgeInsets? all;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.all,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets effectivePadding;
    
    if (all != null) {
      effectivePadding = all!;
    } else if (context.isDesktop && desktop != null) {
      effectivePadding = desktop!;
    } else if (context.isTablet && tablet != null) {
      effectivePadding = tablet!;
    } else if (context.isMobile && mobile != null) {
      effectivePadding = mobile!;
    } else {
      effectivePadding = context.adaptivePadding;
    }

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }
}

/// Padding horizontal adaptativo
class ResponsiveHorizontalPadding extends StatelessWidget {
  final Widget child;
  final double? mobile;
  final double? tablet;
  final double? desktop;

  const ResponsiveHorizontalPadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    double padding;
    
    if (context.isDesktop && desktop != null) {
      padding = desktop!;
    } else if (context.isTablet && tablet != null) {
      padding = tablet!;
    } else if (context.isMobile && mobile != null) {
      padding = mobile!;
    } else {
      padding = context.isMobile ? 16 : (context.isTablet ? 32 : 48);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );
  }
}

/// Padding vertical adaptativo
class ResponsiveVerticalPadding extends StatelessWidget {
  final Widget child;
  final double? mobile;
  final double? tablet;
  final double? desktop;

  const ResponsiveVerticalPadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    double padding;
    
    if (context.isDesktop && desktop != null) {
      padding = desktop!;
    } else if (context.isTablet && tablet != null) {
      padding = tablet!;
    } else if (context.isMobile && mobile != null) {
      padding = mobile!;
    } else {
      padding = context.isMobile ? 16 : 24;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: child,
    );
  }
}
