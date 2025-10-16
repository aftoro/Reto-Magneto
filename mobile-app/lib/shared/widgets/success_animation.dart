import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class SuccessAnimation extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onAnimationComplete;
  final Duration duration;

  const SuccessAnimation({
    super.key,
    required this.title,
    required this.message,
    this.onAnimationComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _checkController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    // Secuencia de animaciones
    await _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _checkController.forward();
    
    // Esperar y llamar al callback
    await Future.delayed(widget.duration);
    if (mounted && widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(AppConstants.spacingL),
                padding: const EdgeInsets.all(AppConstants.spacingXL),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  boxShadow: AppConstants.elevatedShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono de éxito animado
                    AnimatedBuilder(
                      animation: _checkController,
                      builder: (context, child) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppConstants.successColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Transform.scale(
                            scale: _checkAnimation.value,
                            child: Icon(
                              Icons.check_circle,
                              color: AppConstants.successColor,
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Título
                    AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppConstants.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingM),
                    
                    // Mensaje
                    AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            widget.message,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppConstants.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingL),
                    
                    // Indicador de progreso
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.successColor,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
