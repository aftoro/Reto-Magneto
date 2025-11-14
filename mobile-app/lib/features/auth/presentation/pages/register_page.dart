import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';
import '../providers/auth_provider.dart';
import '../../../../shared/widgets/success_animation.dart';
import '../../../../shared/widgets/responsive/responsive_container.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showSuccessAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    print('🚀 Iniciando registro...');
    
    if (!_formKey.currentState!.validate()) {
      print('❌ Validación del formulario falló');
      return;
    }

    try {
      print('📧 Email: ${_emailController.text.trim()}');
      print('👤 Nombre: ${_fullNameController.text.trim()}');
      print('🔒 Contraseña: ${_passwordController.text.length} caracteres');
      
      await ref.read(signUpProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
      );

      print('✅ Usuario registrado exitosamente');

      if (mounted) {
        setState(() {
          _showSuccessAnimation = true;
        });
        
        // Después de mostrar la animación de éxito, navegar al login
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
      }
    } catch (e) {
      print('⚠️ Error en registro: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  void _onSuccessAnimationComplete() {
    setState(() {
      _showSuccessAnimation = false;
    });
    
    // Navegar a login
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Validar si el formulario está completo y válido
  bool _isFormValid() {
    return _fullNameController.text.trim().isNotEmpty &&
           _emailController.text.trim().isNotEmpty &&
           _passwordController.text.length >= 8 &&
           _confirmPasswordController.text == _passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(signUpProvider);

    final stackChildren = <Widget>[
      Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.brandGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: CenteredResponsiveContainer(
                  maxWidth: context.isDesktop ? 500 : (context.isTablet ? 450 : double.infinity),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL,
                    vertical: context.isMobile ? AppConstants.spacingL : AppConstants.spacingXXL,
                  ),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL),
                              
                              // Botón de regreso
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: _navigateToLogin,
                                  icon: Container(
                                    padding: const EdgeInsets.all(AppConstants.spacingS),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: context.isMobile ? 20 : 24,
                                    ),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: AppConstants.spacingL),
                              
                              // Logo y título
                              Container(
                                width: context.isMobile ? 100 : 120,
                                height: context.isMobile ? 100 : 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusXL,
                                  ),
                                  boxShadow: AppConstants.elevatedShadow,
                                ),
                                child: Icon(
                                  Icons.person_add_outlined,
                                  size: context.isMobile ? 60 : 70,
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                              
                              SizedBox(height: AppConstants.spacingL),
                              
                              Text(
                                AppStrings.registerTitle,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.getAdaptiveFontSize(
                                    context,
                                    mobile: 28,
                                    tablet: 32,
                                    desktop: 36,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: AppConstants.spacingM),
                              
                              Text(
                                AppStrings.registerSubtitle,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: Responsive.getAdaptiveFontSize(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 18,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: context.isMobile ? AppConstants.spacingXXL : AppConstants.spacingXL),
                              
                              // Formulario
                              Container(
                                padding: EdgeInsets.all(
                                  context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                  boxShadow: AppConstants.elevatedShadow,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                    // Mostrar error si existe
                                    if (authState.error != null)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(AppConstants.spacingM),
                                        margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
                                        decoration: BoxDecoration(
                                          color: AppConstants.errorColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                          border: Border.all(
                                            color: AppConstants.errorColor.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: AppConstants.errorColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: AppConstants.spacingS),
                                            Expanded(
                                              child: Text(
                                                authState.error!,
                                                style: TextStyle(
                                                  color: AppConstants.errorColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                ref.read(signUpProvider.notifier).clearError();
                                              },
                                              icon: const Icon(Icons.close, size: 20),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    AuthTextField(
                                      controller: _fullNameController,
                                      labelText: 'Nombre completo',
                                      hintText: 'Tu nombre completo',
                                      prefixIcon: Icons.person_outlined,
                                      keyboardType: TextInputType.name,
                                      onChanged: (_) => setState(() {}),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu nombre';
                                        }
                                        if (value.trim().split(' ').length < 2) {
                                          return 'Por favor ingresa tu nombre completo';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingM),
                                    
                                    AuthTextField(
                                      controller: _emailController,
                                      labelText: 'Email',
                                      hintText: 'tu@email.com',
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (_) => setState(() {}),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu email';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Por favor ingresa un email válido';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingM),
                                    
                                    AuthTextField(
                                      controller: _passwordController,
                                      labelText: 'Contraseña',
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outlined,
                                      obscureText: _obscurePassword,
                                      onChanged: (_) => setState(() {}),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa una contraseña';
                                        }
                                        if (value.length < 8) {
                                          return 'La contraseña debe tener al menos 8 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingM),
                                    
                                    AuthTextField(
                                      controller: _confirmPasswordController,
                                      labelText: 'Confirmar contraseña',
                                      hintText: '••••••••',
                                      prefixIcon: Icons.lock_outlined,
                                      obscureText: _obscureConfirmPassword,
                                      onChanged: (_) => setState(() {}),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor confirma tu contraseña';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Las contraseñas no coinciden';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingL),
                                    
                                    // Botón de registro
                                    SizedBox(
                                      width: double.infinity,
                                      child: GradientButton(
                                        onPressed: _isFormValid() && !authState.isLoading ? _handleRegister : null,
                                        child: authState.isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                _isFormValid() 
                                                    ? AppStrings.registerTitle 
                                                    : 'Completa el formulario',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                    
                                    // Indicador de fortaleza de contraseña
                                    if (_passwordController.text.isNotEmpty)
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(top: AppConstants.spacingS),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Fortaleza de la contraseña:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppConstants.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value: _passwordController.text.length / 8,
                                              backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                _passwordController.text.length >= 8 
                                                    ? AppConstants.successColor 
                                                    : AppConstants.warningColor,
                                              ),
                                            ),
                                            Text(
                                              '${_passwordController.text.length}/8 caracteres mínimos',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: _passwordController.text.length >= 8 
                                                    ? AppConstants.successColor 
                                                    : AppConstants.warningColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppConstants.spacingL),
                            
                            // Enlace a login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿Ya tienes una cuenta? ',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _navigateToLogin,
                                  child: const Text(
                                    'Inicia sesión',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
    ];

    if (_showSuccessAnimation) {
      stackChildren.add(
        Positioned.fill(
          child: SuccessAnimation(
            title: '¡Cuenta creada exitosamente! 🎉',
            message: 'Bienvenido ${_fullNameController.text.trim().split(' ').first}, tu cuenta ha sido creada. Ahora puedes iniciar sesión.',
            onAnimationComplete: _onSuccessAnimationComplete,
            duration: const Duration(seconds: 3),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: stackChildren,
      ),
    );
  }
}
