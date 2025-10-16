import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sse_service.dart';
import '../services/notification_display_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/entities/user_entity.dart';

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
  StreamSubscription? _sseConnectionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSSE();
  }

  @override
  void dispose() {
    _sseMessageSubscription?.cancel();
    _sseConversationSubscription?.cancel();
    _sseConnectionSubscription?.cancel();
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

    // Escuchar estado de conexión SSE
    _sseConnectionSubscription = ref.read(sseServiceProvider).connectionStatusStream.listen((connected) {
      NotificationDisplayService.showConnectionNotification(
        connected: connected,
        message: connected 
            ? 'Conectado a notificaciones en tiempo real' 
            : 'Desconectado del servidor',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AsyncValue<UserEntity?>>(currentUserProvider, (previous, next) {
      final sseService = ref.read(sseServiceProvider);
      
      next.when(
        data: (user) {
          if (user != null) {
            // Usuario autenticado, conectar SSE
            sseService.setAuthenticated(true);
            print('🔐 Usuario autenticado, conectando SSE...');
          } else {
            // Usuario no autenticado, desconectar SSE
            sseService.setAuthenticated(false);
            print('🔓 Usuario no autenticado, desconectando SSE...');
          }
        },
        loading: () {
          // En proceso de carga, no hacer nada
        },
        error: (error, stack) {
          // Error, desconectar SSE
          sseService.setAuthenticated(false);
          print('❌ Error de autenticación, desconectando SSE...');
        },
      );
    });

    return widget.child;
  }
}
