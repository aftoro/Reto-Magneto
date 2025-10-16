// Configuración de entorno para desarrollo y producción
class EnvConfig {
  // Configuración de Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'TU_SUPABASE_URL_AQUI',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'TU_SUPABASE_ANON_KEY_AQUI',
  );
  
  // Configuración de la aplicación
  static const String appName = 'magneto empleos';
  static const String appVersion = '1.0.0';
  
  // Configuración de desarrollo
  static const bool isDevelopment = bool.fromEnvironment('dart.vm.product') == false;
  static const bool enableLogging = isDevelopment;
  
  // URLs de la aplicación
  static const String privacyPolicyUrl = 'https://magnetoempleos.com/privacy';
  static const String termsOfServiceUrl = 'https://magnetoempleos.com/terms';
  static const String supportEmail = 'soporte@magnetoempleos.com';
  
  // Configuración de la API
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Configuración de caché
  static const Duration cacheDuration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
}
