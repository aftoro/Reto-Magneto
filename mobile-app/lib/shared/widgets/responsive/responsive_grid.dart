import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

/// Grid responsive que se adapta según el tamaño de pantalla
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  int _getColumnCount(BuildContext context) {
    if (context.isDesktop && desktopColumns != null) {
      return desktopColumns!;
    }
    if (context.isTablet && tabletColumns != null) {
      return tabletColumns!;
    }
    if (context.isMobile && mobileColumns != null) {
      return mobileColumns!;
    }
    return context.columnCount;
  }

  @override
  Widget build(BuildContext context) {
    final columnCount = _getColumnCount(context);

    if (columnCount == 1) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: runSpacing),
                  child: child,
                ))
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * (columnCount - 1))) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// Grid con aspect ratio para items uniformes
class ResponsiveAspectGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double aspectRatio;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveAspectGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.aspectRatio = 1.0,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  int _getColumnCount(BuildContext context) {
    if (context.isDesktop && desktopColumns != null) {
      return desktopColumns!;
    }
    if (context.isTablet && tabletColumns != null) {
      return tabletColumns!;
    }
    if (context.isMobile && mobileColumns != null) {
      return mobileColumns!;
    }
    return context.columnCount;
  }

  @override
  Widget build(BuildContext context) {
    final columnCount = _getColumnCount(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Verificar que constraints sean válidos
        if (constraints.maxWidth.isInfinite || constraints.maxWidth <= 0) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: WrapAlignment.start,
            children: children,
          );
        }
        
        final itemWidth = (constraints.maxWidth - (spacing * (columnCount - 1))) / columnCount;
        final itemHeight = itemWidth / aspectRatio;

        // Verificar que los tamaños sean válidos
        if (itemWidth <= 0 || itemHeight <= 0) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: WrapAlignment.start,
            children: children,
          );
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
