import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnimatedSplashPage extends StatefulWidget {
  const AnimatedSplashPage({super.key});

  @override
  State<AnimatedSplashPage> createState() => _AnimatedSplashPageState();
}

class _AnimatedSplashPageState extends State<AnimatedSplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeOutFull;
  late final Animation<double> _fadeInM;
  late final Animation<double> _scaleM;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _fadeOutFull = CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.65, curve: Curves.easeOut));
    _fadeInM = CurvedAnimation(parent: _controller, curve: const Interval(0.55, 1.0, curve: Curves.easeOut));
    _scaleM = Tween<double>(begin: 0.9, end: 1.25).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.55, 1.0, curve: Curves.easeInOut)));

    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(milliseconds: 150));
    await _controller.forward();
    if (!mounted) return;
    
    // Verificar si hay sesión de Supabase
    final session = Supabase.instance.client.auth.currentSession;
    final user = Supabase.instance.client.auth.currentUser;
    
    print('🔍 Splash: Verificando autenticación...');
    print('   Sesión: ${session != null ? 'existe' : 'null'}');
    print('   Usuario: ${user != null ? user.id : 'null'}');
    
    // Navegar según el estado de autenticación
    if (session != null && user != null && session.accessToken.isNotEmpty) {
      print('✅ Splash: Usuario autenticado, navegando a /main-app');
      Navigator.of(context).pushReplacementNamed('/main-app');
    } else {
      print('🔓 Splash: Usuario no autenticado, navegando a /login');
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF0F0A2A);
    const brandPrimary = Color(0xFF41068e); // color de marca solicitado
    const white = Colors.white;
    const green = Color(0xFF22C55E); // verde amable para "magneto"
    return Scaffold(
      backgroundColor: background,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo en texto centrado: "magneto empleos"
            FadeTransition(
              opacity: ReverseAnimation(_fadeOutFull),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    children: const [
                      TextSpan(text: 'm', style: TextStyle(color: green)),
                      TextSpan(text: 'agneto', style: TextStyle(color: white)),
                      TextSpan(text: ' '),
                      TextSpan(text: 'empleos', style: TextStyle(color: brandPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
            ScaleTransition(
              scale: _scaleM,
              child: FadeTransition(
                opacity: _fadeInM,
                child: const Center(
                  child: Text(
                    'm',
                    style: TextStyle(
                      fontSize: 92,
                      fontWeight: FontWeight.w900,
                      color: green,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
