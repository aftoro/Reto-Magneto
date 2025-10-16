import 'env_config.dart';
import 'local_config.dart';

class SupabaseConfig {
  // URLs y claves de Supabase
  // En desarrollo usa LocalConfig, en producción usa EnvConfig
  static const String supabaseUrl = LocalConfig.supabaseUrl;
  static const String supabaseAnonKey = LocalConfig.supabaseAnonKey;
  
  // Nombres de las tablas
  static const String usersTable = 'users';
  static const String profilesTable = 'profiles';
  static const String jobsTable = 'jobs';
  static const String applicationsTable = 'applications';
  
  // Nombres de los buckets de storage
  static const String avatarsBucket = 'avatars';
  static const String resumesBucket = 'resumes';
  static const String companyLogosBucket = 'company_logos';
  
  // Configuración de autenticación
  static const Duration sessionTimeout = Duration(days: 30);
  static const bool autoRefreshToken = true;
  
  // Configuración de la base de datos
  static const int maxQueryResults = 100;
  static const Duration queryTimeout = Duration(seconds: 10);
  
  // Configuración de RLS (Row Level Security)
  static const bool enableRLS = true;
  
  // Configuración de webhooks
  static const String webhookSecret = 'TU_WEBHOOK_SECRET_AQUI';
  
  // URLs de redirección
  static const String authRedirectUrl = 'io.supabase.flutter://login-callback/';
  static const String deepLinkUrl = 'magnetoempleos://';
}
