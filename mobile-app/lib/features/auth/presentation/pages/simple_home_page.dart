import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/gradient_button.dart';

class SimpleHomePage extends ConsumerWidget {
  const SimpleHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.backgroundColor,
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo y título
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingXL),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    boxShadow: AppConstants.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppConstants.brandGradient,
                          borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingL),
                      Text(
                        'Magneto Empleos',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Plataforma de gestión de empleos',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingXL),
                
                // Botón principal
                GradientButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main-app');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apps,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Acceder a la Aplicación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingL),
                
                // Información adicional
                Text(
                  'Gestiona conversaciones, crea contenido y administra tu plataforma',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
