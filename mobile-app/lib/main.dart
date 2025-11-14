import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_router.dart';
import 'core/config/supabase_config.dart';
import 'core/services/notification_display_service.dart';
import 'core/widgets/sse_initializer.dart';
import 'shared/theme/app_theme.dart';
import 'features/navigation/presentation/pages/main_app_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'splash/animated_splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  // NOTA: Por defecto, Supabase Flutter maneja automáticamente:
  // - persistSession: true (la sesión se guarda en almacenamiento seguro)
  // - autoRefreshToken: true (el token se refresca automáticamente antes de expirar)
  // - La sesión persiste entre reinicios de la app
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  // Verificar y recuperar sesión guardada al iniciar
  final supabase = Supabase.instance.client;
  final session = supabase.auth.currentSession;
  if (session != null) {
    print('✅ Sesión recuperada al iniciar la app: ${session.user.email ?? session.user.id}');
    // Verificar si el token necesita ser refrescado
    final expiresAt = session.expiresAt;
    if (expiresAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final timeUntilExpiry = expiresAt - now;
      if (timeUntilExpiry < 3600) { // Menos de 1 hora hasta expirar
        print('🔄 Token próximo a expirar, refrescando automáticamente...');
        try {
          await supabase.auth.refreshSession();
          print('✅ Token refrescado exitosamente');
        } catch (e) {
          print('⚠️ Error al refrescar token al iniciar: $e');
        }
      }
    }
  } else {
    print('ℹ️ No hay sesión guardada al iniciar la app');
  }
  
  // Configurar manejo global de errores de autenticación
  _setupAuthErrorHandling();
  
  runApp(const ProviderScope(child: MyApp()));
}

/// Configura el manejo global de errores de autenticación de Supabase
void _setupAuthErrorHandling() {
  final supabase = Supabase.instance.client;
  
  // Listener para errores de autenticación
  supabase.auth.onAuthStateChange.listen((event) {
    // Manejar errores específicos del refresh token
    if (event.event == AuthChangeEvent.tokenRefreshed) {
      // Token refrescado exitosamente
      print('✅ Token refrescado exitosamente');
    }
  });
  
  // Configurar manejo de errores no capturados relacionados con auth
  // NOTA: Ignorar errores de refresh automático de tokens, no cerrar sesión automáticamente
  FlutterError.onError = (FlutterErrorDetails details) {
    final error = details.exception;
    final errorString = error.toString().toLowerCase();
    
    // Ignorar errores de refresh automático de tokens (son esperados y no críticos)
    // Estos errores ocurren cuando Supabase intenta refrescar el token automáticamente
    if ((errorString.contains('oauth_client_id') || 
         errorString.contains('missing destination name') ||
         errorString.contains('authretryablefetchexception')) &&
        (errorString.contains('_autoRefreshTokenTick') ||
         errorString.contains('_refreshAccessToken') ||
         errorString.contains('_callRefreshToken') ||
         errorString.contains('recoverSession'))) {
      // Estos son errores de refresh automático, ignorarlos silenciosamente
      print('⚠️ Error de refresh automático de token (ignorado): ${error.toString().substring(0, error.toString().length > 100 ? 100 : error.toString().length)}...');
      return; // No mostrar el error al usuario ni cerrar sesión
    }
    
    // Para otros errores de auth, solo loguear sin cerrar sesión automáticamente
    if (errorString.contains('oauth_client_id') || 
        errorString.contains('missing destination name') ||
        errorString.contains('authretryablefetchexception')) {
      print('⚠️ Error de autenticación detectado (no crítico): $error');
      print('   Stack trace: ${details.stack}');
      // NO cerrar sesión automáticamente, solo loguear
      return;
    }
    
    // Usar el handler por defecto para todos los demás errores
    FlutterError.presentError(details);
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SSEInitializer(
      child: MaterialApp(
        title: 'magneto empleos',
        debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light, // Cambiar a modo claro
            initialRoute: '/splash',
            onGenerateRoute: AppRouter.generateRoute,
            routes: {
              '/splash': (_) => const AnimatedSplashPage(),
              '/login': (_) => const LoginPage(),
              '/main-app': (_) => const MainAppPage(),
            },
        scaffoldMessengerKey: NotificationDisplayService.scaffoldKey,
      ),
    );
  }
}
