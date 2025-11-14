import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? icon;
  final Widget child;

  const AnalyticsCard({
    super.key,
    required this.title,
    this.iconPath,
    this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Borde gris claro
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Sombra suave para light mode
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconPath != null
                  ? SvgPicture.asset(
                      iconPath!,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppConstants.primaryColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon ?? Icons.analytics,
                      color: AppConstants.primaryColor, // Púrpura Magneto
                      size: 24,
                    ),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                title,
                style: const TextStyle(
                  color: AppConstants.textPrimary, // Texto negro para light mode
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          child,
        ],
      ),
    );
  }
}
