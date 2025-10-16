import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/conversations/data/models/conversation_entity.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  StreamController<NotificationData>? _notificationController;
  StreamController<MessageEntity>? _newMessageController;
  StreamController<ConversationWithMessages>? _newConversationController;

  /// Stream de notificaciones generales
  Stream<NotificationData> get notificationStream {
    _notificationController ??= StreamController<NotificationData>.broadcast();
    return _notificationController!.stream;
  }

  /// Stream de nuevos mensajes
  Stream<MessageEntity> get newMessageStream {
    _newMessageController ??= StreamController<MessageEntity>.broadcast();
    return _newMessageController!.stream;
  }

  /// Stream de nuevas conversaciones
  Stream<ConversationWithMessages> get newConversationStream {
    _newConversationController ??= StreamController<ConversationWithMessages>.broadcast();
    return _newConversationController!.stream;
  }

  /// Procesar notificación SSE
  void processSSENotification(Map<String, dynamic> data) {
    try {
      final type = data['type'] as String?;
      final notificationData = data['data'] as Map<String, dynamic>?;

      if (type == null || notificationData == null) return;

      switch (type) {
        case 'new_message':
          _handleNewMessage(notificationData);
          break;
        case 'new_conversation':
          _handleNewConversation(notificationData);
          break;
        case 'connected':
          _handleConnected(data);
          break;
        case 'ping':
          // Mantener conexión viva
          break;
        default:
          debugPrint('Tipo de notificación desconocido: $type');
      }
    } catch (e) {
      debugPrint('Error al procesar notificación SSE: $e');
    }
  }

  /// Manejar nuevo mensaje
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      final message = MessageEntity.fromApiJson(data);
      _newMessageController?.add(message);
      
      // Mostrar notificación visual si la app está en segundo plano
      _showMessageNotification(message);
    } catch (e) {
      debugPrint('Error al procesar nuevo mensaje: $e');
    }
  }

  /// Manejar nueva conversación
  void _handleNewConversation(Map<String, dynamic> data) {
    try {
      final conversation = ConversationWithMessages.fromApiJson(data);
      _newConversationController?.add(conversation);
      
      // Mostrar notificación visual
      _showConversationNotification(conversation);
    } catch (e) {
      debugPrint('Error al procesar nueva conversación: $e');
    }
  }

  /// Manejar conexión establecida
  void _handleConnected(Map<String, dynamic> data) {
    final message = data['message'] as String? ?? 'Conectado a notificaciones';
    _notificationController?.add(NotificationData(
      type: NotificationType.connected,
      title: 'Conectado',
      message: message,
      timestamp: DateTime.now(),
    ));
  }

  /// Mostrar notificación de mensaje
  void _showMessageNotification(MessageEntity message) {
    // Solo mostrar si la app está en segundo plano
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      _showLocalNotification(
        title: 'Nuevo mensaje',
        body: message.content.length > 50 
            ? '${message.content.substring(0, 50)}...' 
            : message.content,
        payload: json.encode({
          'type': 'message',
          'conversationId': message.conversacionId,
          'messageId': message.id,
        }),
      );
    }
  }

  /// Mostrar notificación de conversación
  void _showConversationNotification(ConversationWithMessages conversation) {
    _showLocalNotification(
      title: 'Nueva conversación',
      body: 'Mensaje de ${conversation.conversation.username ?? 'Usuario'}',
      payload: json.encode({
        'type': 'conversation',
        'conversationId': conversation.conversation.id,
      }),
    );
  }

  /// Mostrar notificación local
  void _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    // En un entorno real, aquí usarías flutter_local_notifications
    // Por ahora, solo mostramos en consola
    debugPrint('🔔 Notificación: $title - $body');
    
    _notificationController?.add(NotificationData(
      type: NotificationType.message,
      title: title,
      message: body,
      timestamp: DateTime.now(),
      payload: payload,
    ));
  }

  /// Solicitar permisos de notificación
  Future<bool> requestNotificationPermission() async {
    if (kIsWeb) return true; // En web no se necesitan permisos
    
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Verificar si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return true;
    
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Limpiar recursos
  void dispose() {
    _notificationController?.close();
    _newMessageController?.close();
    _newConversationController?.close();
    _notificationController = null;
    _newMessageController = null;
    _newConversationController = null;
  }
}

/// Tipos de notificación
enum NotificationType {
  message,
  conversation,
  connected,
  error,
}

/// Datos de notificación
class NotificationData {
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? payload;

  NotificationData({
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.payload,
  });
}
