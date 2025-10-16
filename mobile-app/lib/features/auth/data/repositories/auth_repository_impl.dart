import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );

      if (response.user == null) {
        throw Exception('Error al crear el usuario');
      }

      // Crear perfil en la tabla profiles
      if (response.user != null) {
        try {
          await _supabaseClient.from('profiles').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // Si falla la creación del perfil, no es crítico
          print('Warning: No se pudo crear el perfil: $e');
        }
      }

      return UserEntity(
        id: response.user!.id,
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw Exception(_getErrorMessage(e.message));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Credenciales inválidas');
      }

      // Intentar obtener perfil del usuario
      UserEntity userEntity;
      try {
        final profileData = await _supabaseClient
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();

        userEntity = UserModel.fromJson(profileData).toEntity();
      } catch (e) {
        // Si no hay perfil, crear uno básico
        userEntity = UserEntity(
          id: response.user!.id,
          email: response.user!.email ?? email,
          fullName: response.user!.userMetadata?['full_name'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      return userEntity;
    } on AuthException catch (e) {
      throw Exception(_getErrorMessage(e.message));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      // Intentar obtener perfil del usuario
      try {
        final profileData = await _supabaseClient
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        return UserModel.fromJson(profileData).toEntity();
      } catch (e) {
        // Si no hay perfil, retornar usuario básico
        return UserEntity(
          id: user.id,
          email: user.email ?? '',
          fullName: user.userMetadata?['full_name'],
          isEmailVerified: user.emailConfirmedAt != null,
        );
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _supabaseClient.auth.resend(
        type: OtpType.signup,
        email: _supabaseClient.auth.currentUser?.email ?? '',
      );
    } catch (e) {
      throw Exception('Error al enviar email de verificación: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Error al restablecer contraseña: $e');
    }
  }

  @override
  Future<UserEntity> updateProfile({
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;

      try {
        await _supabaseClient
            .from('profiles')
            .update(updateData)
            .eq('id', user.id);
      } catch (e) {
        // Si la tabla no existe, crear el perfil
        await _supabaseClient.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'full_name': fullName,
          'avatar_url': avatarUrl,
          'phone_number': phoneNumber,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      // Obtener perfil actualizado
      try {
        final profileData = await _supabaseClient
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        return UserModel.fromJson(profileData).toEntity();
      } catch (e) {
        // Retornar usuario básico si no se puede obtener el perfil
        return UserEntity(
          id: user.id,
          email: user.email ?? '',
          fullName: fullName,
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _supabaseClient.auth.currentUser != null;
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      
      // Retornar usuario básico si no hay perfil
      return UserEntity(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'],
        isEmailVerified: user.emailConfirmedAt != null,
      );
    });
  }

  String _getErrorMessage(String message) {
    switch (message.toLowerCase()) {
      case 'invalid login credentials':
        return 'Email o contraseña incorrectos';
      case 'user already registered':
        return 'El usuario ya está registrado';
      case 'email not confirmed':
        return 'Por favor confirma tu email';
      case 'weak password':
        return 'La contraseña es muy débil';
      default:
        return message;
    }
  }
}
