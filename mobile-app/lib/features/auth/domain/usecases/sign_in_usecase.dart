import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  const SignInUseCase(this._authRepository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    // Validaciones básicas
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Email inválido');
    }
    
    if (password.isEmpty) {
      throw ArgumentError('La contraseña no puede estar vacía');
    }

    try {
      final user = await _authRepository.signIn(
        email: email.trim().toLowerCase(),
        password: password,
      );
      
      return user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
