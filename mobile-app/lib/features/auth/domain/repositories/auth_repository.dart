import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Registra un nuevo usuario con email y contraseña
  Future<UserEntity> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  /// Inicia sesión con email y contraseña
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// Cierra la sesión actual
  Future<void> signOut();

  /// Obtiene el usuario actual
  Future<UserEntity?> getCurrentUser();

  /// Envía un email de verificación
  Future<void> sendEmailVerification();

  /// Restablece la contraseña
  Future<void> resetPassword(String email);

  /// Actualiza el perfil del usuario
  Future<UserEntity> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
  });

  /// Verifica si el usuario está autenticado
  Future<bool> isAuthenticated();

  /// Escucha cambios en el estado de autenticación
  Stream<UserEntity?> get authStateChanges;
}
