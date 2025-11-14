import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/sse_service.dart';
import '../services/notification_display_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/instagram/presentation/providers/instagram_posts_provider.dart';

class SSEInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const SSEInitializer({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<SSEInitializer> createState() => _SSEInitializerState();
}

class _SSEInitializerState extends ConsumerState<SSEInitializer> {
  StreamSubscription? _sseMessageSubscription;
  StreamSubscription? _sseConversationSubscription;
  StreamSubscription? _sseCommentSubscription;
  StreamSubscription? _sseConnectionSubscription;
  StreamSubscription? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSSE();
    _initializeAuthListener();
  }
  
  void _initializeAuthListener() {
    // Escuchar cambios de autenticación directamente desde Supabase
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      final sseService = ref.read(sseServiceProvider);
      
      if (session != null) {
        print('🔐 Cambio de autenticación: Sesión activa detectada');
        sseService.setAuthenticated(true);
      } else {
        print('🔓 Cambio de autenticación: Sesión cerrada');
        sseService.setAuthenticated(false);
      }
    });
    
    // Verificar estado inicial de autenticación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = Supabase.instance.client.auth.currentSession;
      final sseService = ref.read(sseServiceProvider);
      
      if (session != null) {
        print('🔐 Estado inicial: Sesión de Supabase activa, conectando SSE...');
        sseService.setAuthenticated(true);
      } else {
        print('🔓 Estado inicial: No hay sesión de Supabase');
        sseService.setAuthenticated(false);
      }
    });
  }

  @override
  void dispose() {
    _sseMessageSubscription?.cancel();
    _sseConversationSubscription?.cancel();
    _sseCommentSubscription?.cancel();
    _sseConnectionSubscription?.cancel();
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void _initializeSSE() {
    // Escuchar mensajes SSE
    _sseMessageSubscription = ref.read(sseServiceProvider).newMessageStream.listen((data) {
      final senderName = data['author_name'] ?? 'Usuario';
      final message = data['content'] ?? '';
      
      NotificationDisplayService.showNewMessageNotification(
        senderName: senderName,
        message: message,
        onTap: () {
          // TODO: Navegar al chat específico
          print('Navegando al chat del mensaje: ${data['conversacion_id']}');
        },
      );
    });

    // Escuchar nuevas conversaciones SSE
    _sseConversationSubscription = ref.read(sseServiceProvider).newConversationStream.listen((data) {
      final username = data['username'] ?? 'Usuario';
      
      NotificationDisplayService.showNewConversationNotification(
        username: username,
        onTap: () {
          // TODO: Navegar a la lista de conversaciones
          print('Navegando a la lista de conversaciones');
        },
      );
    });

    // Escuchar nuevos comentarios SSE
    _sseCommentSubscription = ref.read(sseServiceProvider).newCommentStream.listen((data) {
      final username = data['username'] ?? 'Usuario';
      final comment = data['comment_text'] ?? '';
      final postId = data['post_id'] ?? '';
      
      NotificationDisplayService.showNewCommentNotification(
        username: username,
        comment: comment,
        postId: postId,
        onTap: () {
          // TODO: Navegar al post específico
          print('Navegando al post: $postId');
        },
      );
      
      // Actualizar la lista de posts cuando hay un nuevo comentario
      try {
        ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
        print('📢 Lista de posts actualizada por nuevo comentario');
      } catch (e) {
        print('⚠️ Error actualizando lista de posts: $e');
      }
    });

    // Escuchar estado de conexión SSE
    _sseConnectionSubscription = ref.read(sseServiceProvider).connectionStatusStream.listen((connected) {
      // Solo mostrar notificación si el contexto está disponible y montado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
      NotificationDisplayService.showConnectionNotification(
        connected: connected,
        message: connected 
            ? 'Conectado a notificaciones en tiempo real' 
            : 'Desconectado del servidor',
      );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar sesión de Supabase directamente en cada build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        final sseService = ref.read(sseServiceProvider);
        
        if (session != null && session.accessToken.isNotEmpty) {
          sseService.setAuthenticated(true);
          print('🔐 Sesión de Supabase activa detectada en build (${session.user.email ?? session.user.id})');
        } else {
          // Solo desconectar si realmente no hay sesión
          final user = Supabase.instance.client.auth.currentUser;
          if (user == null) {
            sseService.setAuthenticated(false);
            print('🔓 No hay sesión ni usuario, desconectando SSE...');
          } else {
            // Hay usuario pero no sesión - puede ser un problema de timing
            print('⚠️ Hay usuario (${user.id}) pero no hay sesión activa');
          }
        }
      } catch (e) {
        print('⚠️ Error al verificar sesión en build: $e');
      }
    });
    
    // También escuchar cambios en el estado de autenticación
    final currentUserAsync = ref.watch(currentUserProvider);
    final sseService = ref.read(sseServiceProvider);
    
    // Manejar el estado inicial y cambios
    currentUserAsync.when(
      data: (user) {
        if (user != null) {
          // Usuario autenticado, verificar sesión también
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null && session.accessToken.isNotEmpty) {
            sseService.setAuthenticated(true);
            print('🔐 Usuario autenticado (${user.email}), conectando SSE...');
          } else {
            print('⚠️ Usuario autenticado pero sin sesión activa');
          }
        } else {
          // Usuario no autenticado, desconectar SSE
          sseService.setAuthenticated(false);
          print('🔓 Usuario no autenticado, desconectando SSE...');
        }
      },
      loading: () {
        // En proceso de carga, verificar sesión de Supabase directamente
        try {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null && session.accessToken.isNotEmpty) {
            print('⏳ Cargando usuario, pero hay sesión de Supabase activa');
            sseService.setAuthenticated(true);
          } else {
            sseService.setAuthenticated(false);
            print('⏳ Cargando usuario, sin sesión de Supabase');
          }
        } catch (e) {
          print('⚠️ Error al verificar sesión durante carga: $e');
        }
      },
      error: (error, stack) {
        // Error, verificar si hay sesión de Supabase antes de desconectar
        try {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null && session.accessToken.isNotEmpty) {
            print('⚠️ Error en currentUserProvider pero hay sesión activa, intentando conectar SSE...');
            sseService.setAuthenticated(true);
          } else {
            sseService.setAuthenticated(false);
            print('❌ Error de autenticación y sin sesión, desconectando SSE...');
          }
        } catch (e) {
          sseService.setAuthenticated(false);
          print('❌ Error de autenticación, desconectando SSE...');
        }
      },
    );

    return widget.child;
  }
}
