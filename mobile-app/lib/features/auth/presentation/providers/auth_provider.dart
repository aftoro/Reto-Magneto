import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Provider del cliente Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider del repositorio
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(supabaseClient);
});

// Provider del estado de carga
final authLoadingProvider = StateProvider<bool>((ref) => false);

// Provider del estado de error
final authErrorProvider = StateProvider<String?>((ref) => null);

// Provider del usuario actual
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  try {
    final repository = ref.read(authRepositoryProvider);
    return await repository.getCurrentUser();
  } catch (e) {
    print('Error al obtener usuario actual: $e');
    return null;
  }
});

// Provider para el registro
final signUpProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Provider para el inicio de sesión
final signInProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Provider para cerrar sesión
final signOutProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Estado de autenticación
class AuthState {
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

// Notificador de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState());

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    print('🚀 AuthNotifier.signUp iniciado');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('📞 Llamando al repositorio de registro...');
      final repository = _ref.read(authRepositoryProvider);
      final user = await repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      print('✅ Registro exitoso en AuthNotifier: $user');
      state = state.copyWith(isLoading: false, user: user);
      
      // Invalidar el currentUserProvider para que se actualice
      _ref.invalidate(currentUserProvider);
      print('🔄 currentUserProvider invalidado después del registro');
      
    } catch (e) {
      print('❌ Error en registro AuthNotifier: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    print('🔑 AuthNotifier.signIn iniciado');
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('📞 Llamando al repositorio de login...');
      final repository = _ref.read(authRepositoryProvider);
      final user = await repository.signIn(
        email: email,
        password: password,
      );
      
      print('✅ Login exitoso en AuthNotifier: $user');
      state = state.copyWith(isLoading: false, user: user);
      
      // Invalidar el currentUserProvider para que se actualice
      _ref.invalidate(currentUserProvider);
      print('🔄 currentUserProvider invalidado después del login');
      
      print('🎯 Estado final del AuthNotifier: isLoading=${state.isLoading}, user=${state.user?.email}, error=${state.error}');
      
    } catch (e) {
      print('❌ Error en login AuthNotifier: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    print('🚪 AuthNotifier.signOut iniciado');
    state = state.copyWith(isLoading: true);
    
    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.signOut();
      state = state.copyWith(isLoading: false, user: null);
      
      // Invalidar el currentUserProvider para que se actualice
      _ref.invalidate(currentUserProvider);
      print('🔄 currentUserProvider invalidado después del logout');
      
    } catch (e) {
      print('❌ Error en logout AuthNotifier: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void clearError() {
    print('🧹 Limpiando error en AuthNotifier');
    state = state.copyWith(error: null);
  }
}
