import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gradient_button.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';

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
    
    // Verificar si hay un mensaje de bienvenida (por ejemplo, después del registro)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForWelcomeMessage();
    });
  }

  void _checkForWelcomeMessage() {
    // Simular que el usuario viene del registro
    // En producción, esto vendría de los parámetros de navegación
    if (mounted) {
      setState(() {
        _showWelcomeMessage = true;
        _welcomeMessage = '¡Bienvenido! Tu cuenta ha sido creada exitosamente.';
      });
      
      // Ocultar el mensaje después de 4 segundos
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showWelcomeMessage = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Método alternativo de navegación usando el contexto global
  void _navigateToHome() {
    print('🔄 Intentando navegación alternativa...');
    
    // Usar el contexto actual si está disponible
    if (mounted) {
      print('✅ Contexto disponible, navegando...');
      try {
        Navigator.pushReplacementNamed(context, '/home');
        print('✅ Navegación alternativa exitosa');
      } catch (e) {
        print('❌ Error en navegación alternativa: $e');
      }
    } else {
      print('❌ Widget no está montado para navegación alternativa');
    }
  }

  void _handleLogin() async {
    print('🔑 Iniciando login...');
    
    if (!_formKey.currentState!.validate()) {
      print('❌ Validación del formulario falló');
      return;
    }

    try {
      print('📧 Email: ${_emailController.text.trim()}');
      print('🔒 Contraseña: ${_passwordController.text.length} caracteres');
      
      // Llamar al login
      await ref.read(signInProvider.notifier).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('✅ Login exitoso, esperando actualización de estado...');
      
      // Esperar un poco para que el estado se actualice completamente
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Verificar que el usuario esté autenticado
      final currentUser = await ref.read(currentUserProvider.future);
      print('👤 Usuario actual después del login: $currentUser');
      
      if (currentUser == null) {
        print('⚠️ Usuario no encontrado después del login');
        return;
      }
      
      print('✅ Usuario confirmado, navegando al dashboard...');
      
      // Usar addPostFrameCallback para asegurar que el contexto sea válido
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            print('🚀 Navegando usando addPostFrameCallback...');
            try {
              Navigator.pushReplacementNamed(context, '/home');
              print('✅ Navegación exitosa con addPostFrameCallback');
            } catch (e) {
              print('⚠️ Error con addPostFrameCallback: $e');
              // Intentar navegación alternativa
              _navigateToHome();
            }
          }
        });
      } else {
        print('❌ Widget no está montado, no se puede navegar');
      }
      
    } catch (e) {
      print('⚠️ Error en login: $e');
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
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(signInProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.brandGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            const SizedBox(height: AppConstants.spacingXXL),
                            
                            // Logo y título
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusXL,
                                ),
                                boxShadow: AppConstants.elevatedShadow,
                              ),
                              child: const Icon(
                                Icons.flutter_dash,
                                size: 60,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            
                            const SizedBox(height: AppConstants.spacingL),
                            
                            Text(
                              '¡Bienvenido de vuelta!',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: AppConstants.spacingM),
                            
                            Text(
                              'Inicia sesión en tu cuenta',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: AppConstants.spacingXXL),
                            
                            // Formulario
                            Container(
                              padding: const EdgeInsets.all(AppConstants.spacingL),
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
                                                ref.read(signInProvider.notifier).clearError();
                                              },
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
                                          return 'Por favor ingresa tu contraseña';
                                        }
                                        if (value.length < 6) {
                                          return 'Por favor ingresa tu contraseña';
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
                                          // TODO: Implementar recuperación de contraseña
                                        },
                                        child: Text(
                                          '¿Olvidaste tu contraseña?',
                                          style: TextStyle(
                                            color: AppConstants.primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingL),
                                    
                                    // Botón de login
                                    SizedBox(
                                      width: double.infinity,
                                      child: GradientButton(
                                        onPressed: !authState.isLoading ? _handleLogin : null,
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
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
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
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _navigateToRegister,
                                  child: const Text(
                                    'Regístrate',
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
          
          // Mensaje de bienvenida
          if (_showWelcomeMessage)
            Positioned(
              top: AppConstants.spacingL,
              left: AppConstants.spacingL,
              right: AppConstants.spacingL,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                decoration: BoxDecoration(
                  color: AppConstants.successColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  boxShadow: AppConstants.cardShadow,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Expanded(
                      child: Text(
                        _welcomeMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showWelcomeMessage = false;
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
