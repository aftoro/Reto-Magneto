import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  const SignUpUseCase(this._authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
    String? fullName,
  }) async {
    // Validaciones básicas
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Email inválido');
    }
    
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('La contraseña debe tener al menos 6 caracteres');
    }

    try {
      final user = await _authRepository.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        fullName: fullName?.trim(),
      );
      
      return user;
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
}
