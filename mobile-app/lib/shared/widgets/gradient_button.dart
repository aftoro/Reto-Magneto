import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? AppConstants.brandGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.radiusM),
        boxShadow: onPressed != null ? AppConstants.elevatedShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.radiusM),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL,
              vertical: AppConstants.spacingM,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
