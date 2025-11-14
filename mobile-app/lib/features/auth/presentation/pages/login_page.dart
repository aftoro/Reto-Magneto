import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/auth_text_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _obscurePassword = true;
  bool _showWelcomeMessage = false;
  String _welcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Verificar mensaje de bienvenida después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForWelcomeMessage();
    });
  }

  void _checkForWelcomeMessage() {
    if (!mounted) return;

    setState(() {
      _showWelcomeMessage = true;
      _welcomeMessage = AppStrings.accountCreatedMessage;
    });

    // Ocultar después de 4 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showWelcomeMessage = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (!mounted) return;
    try {
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Error en navegación: $e');
    }
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref.read(signInProvider.notifier).signIn(
            email: email,
            password: password,
          );

      // Pequeña espera para que la sesión se sincronice
      await Future.delayed(const Duration(milliseconds: 300));

      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No se pudo establecer la sesión'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
        return;
      }

      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Usuario no encontrado'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
        return;
      }

      // Navegación segura
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _navigateToHome();
          }
        });
      }
    } catch (e) {
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

  void _navigateToRegister() {
    if (mounted) {
      Navigator.pushNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(signInProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppConstants.primaryVariant,
            ),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL,
                  right: context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL,
                  top: context.isMobile ? AppConstants.spacingXXL : AppConstants.spacingXL,
                  bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.spacingL,
                ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            Container(
                              width: context.isMobile ? 80 : 100,
                              height: context.isMobile ? 80 : 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                boxShadow: AppConstants.elevatedShadow,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/images/logo_m.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.flutter_dash,
                                    size: context.isMobile ? 50 : 60,
                                    color: AppConstants.primaryColor,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: AppConstants.spacingXL),

                            Text(
                              AppStrings.welcomeBack,
                              style: TextStyle(
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

                            const SizedBox(height: AppConstants.spacingS),

                            Text(
                              AppStrings.loginSubtitleAlt,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: Responsive.getAdaptiveFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 18,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: AppConstants.spacingXXL),

                            // Formulario
                            Container(
                              padding: EdgeInsets.all(
                                context.isMobile ? AppConstants.spacingL : AppConstants.spacingXL,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Mensaje de error
                                    if (authState.error != null)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(AppConstants.spacingM),
                                        margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
                                        decoration: BoxDecoration(
                                          color: AppConstants.errorColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                          border: Border.all(
                                            color: AppConstants.errorColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: AppConstants.errorColor, size: 20),
                                            const SizedBox(width: AppConstants.spacingS),
                                            Expanded(
                                              child: Text(
                                                authState.error!,
                                                style: const TextStyle(color: AppConstants.errorColor, fontSize: 14),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => ref.read(signInProvider.notifier).clearError(),
                                              icon: const Icon(Icons.close, size: 20),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),

                                    AuthTextField(
                                      controller: _emailController,
                                      labelText: 'Email',
                                      hintText: 'tu@email.com',
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu email';
                                        }
                                        if (!value.contains('@') || !value.contains('.')) {
                                          return 'Ingresa un email válido';
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
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu contraseña';
                                        }
                                        if (value.length < 6) {
                                          return 'La contraseña debe tener al menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: AppConstants.spacingM),

                                    // Olvidé mi contraseña
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // TODO: Implementar recuperación
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          '¿Olvidaste tu contraseña?',
                                          style: TextStyle(
                                            color: AppConstants.primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppConstants.spacingL),

                                    // Botón de login
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: authState.isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppConstants.primaryColor,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                                        ),
                                        child: authState.isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : const Text(
                                                'Iniciar Sesión',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppConstants.spacingL),

                            // Enlace a registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿No tienes una cuenta? ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: Responsive.getAdaptiveFontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 15,
                                      desktop: 16,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _navigateToRegister,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Regístrate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: Responsive.getAdaptiveFontSize(
                                        context,
                                        mobile: 14,
                                        tablet: 15,
                                        desktop: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Espacio extra para teclado
                            SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? AppConstants.spacingL : 0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Mensaje de bienvenida flotante
          if (_showWelcomeMessage)
            Positioned(
              top: AppConstants.spacingL + MediaQuery.of(context).padding.top,
              left: AppConstants.spacingL,
              right: AppConstants.spacingL,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppConstants.successColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    boxShadow: AppConstants.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                      const SizedBox(width: AppConstants.spacingS),
                      Expanded(
                        child: Text(
                          _welcomeMessage,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _showWelcomeMessage = false),
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}