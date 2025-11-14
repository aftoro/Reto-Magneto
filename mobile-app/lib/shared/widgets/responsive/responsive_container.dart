import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

/// Container responsive que limita el ancho máximo en web/desktop
/// y mantiene ancho completo en mobile
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment,
    this.color,
    this.decoration,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.maxContentWidth;
    final effectivePadding = padding ?? context.adaptivePadding;

    return Container(
      width: double.infinity,
      margin: margin,
      alignment: alignment,
      color: color,
      decoration: decoration,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
        ),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Container centrado responsive
class CenteredResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const CenteredResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: maxWidth,
      padding: padding,
      alignment: Alignment.center,
      child: child,
    );
  }
}
