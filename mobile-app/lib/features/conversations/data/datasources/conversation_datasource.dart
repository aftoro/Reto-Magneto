import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation_entity.dart';

class ConversationService {
  final SupabaseClient _supabase;

  ConversationService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<ConversationWithMessages>> getConversations() async {
    try {
      // Obtener conversaciones con sus mensajes relacionados
      final response = await _supabase
          .from('conversaciones')
          .select('''
            *,
            mensajes (
              id,
              conversacion_id,
              platform_message_id,
              content,
              message_type,
              media_context,
              is_ai_generated,
              ai_model,
              created_at,
              sent_at,
              delivery_status
            )
          ''')
          .order('updated_at', ascending: false);

      if (response is List) {
        return response.map((data) {
          final conversation = ConversationEntity.fromSupabase(data);
          
          // Procesar mensajes
          List<MessageEntity> messages = [];
          if (data['mensajes'] != null) {
            messages = (data['mensajes'] as List)
                .map((msg) => MessageEntity.fromSupabase(msg))
                .toList();
          }

          // Ordenar mensajes por fecha de creación
          messages.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });

          // Obtener último mensaje
          MessageEntity? lastMessage;
          if (messages.isNotEmpty) {
            lastMessage = messages.first;
          }

          // Calcular mensajes no leídos (simplificado - puedes ajustar la lógica)
          int unreadCount = 0;
          for (final message in messages) {
            if (message.deliveryStatus == 'delivered' && 
                message.messageType == 'received') {
              unreadCount++;
            }
          }

          return ConversationWithMessages(
            conversation: conversation,
            messages: messages,
            unreadCount: unreadCount,
            lastMessage: lastMessage,
          );
        }).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error al obtener conversaciones: $e');
    }
  }

  Future<ConversationWithMessages?> getConversationById(String id) async {
    try {
      final response = await _supabase
          .from('conversaciones')
          .select('''
            *,
            mensajes (
              id,
              conversacion_id,
              platform_message_id,
              content,
              message_type,
              media_context,
              is_ai_generated,
              ai_model,
              created_at,
              sent_at,
              delivery_status
            )
          ''')
          .eq('id', id)
          .single();

      if (response != null) {
        final conversation = ConversationEntity.fromJson(response);
        
        // Procesar mensajes
        List<MessageEntity> messages = [];
        if (response['mensajes'] != null) {
          messages = (response['mensajes'] as List)
              .map((msg) => MessageEntity.fromSupabase(msg))
              .toList();
        }

        // Ordenar mensajes por fecha de creación
        messages.sort((a, b) {
          final aTime = a.createdAt ?? DateTime(1970);
          final bTime = b.createdAt ?? DateTime(1970);
          return bTime.compareTo(aTime);
        });

        // Obtener último mensaje
        MessageEntity? lastMessage;
        if (messages.isNotEmpty) {
          lastMessage = messages.first;
        }

        // Calcular mensajes no leídos
        int unreadCount = 0;
        for (final message in messages) {
          if (message.deliveryStatus == 'delivered' && 
              message.messageType == 'received') {
            unreadCount++;
          }
        }

        return ConversationWithMessages(
          conversation: conversation,
          messages: messages,
          unreadCount: unreadCount,
          lastMessage: lastMessage,
        );
      }

      return null;
    } catch (e) {
      throw Exception('Error al obtener conversación: $e');
    }
  }

  Future<List<ConversationWithMessages>> getConversationsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('conversaciones')
          .select('''
            *,
            mensajes (
              id,
              conversacion_id,
              platform_message_id,
              content,
              message_type,
              media_context,
              is_ai_generated,
              ai_model,
              created_at,
              sent_at,
              delivery_status
            )
          ''')
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      if (response is List) {
        return response.map((data) {
          final conversation = ConversationEntity.fromSupabase(data);
          
          // Procesar mensajes
          List<MessageEntity> messages = [];
          if (data['mensajes'] != null) {
            messages = (data['mensajes'] as List)
                .map((msg) => MessageEntity.fromSupabase(msg))
                .toList();
          }

          // Ordenar mensajes por fecha de creación
          messages.sort((a, b) {
            final aTime = a.createdAt ?? DateTime(1970);
            final bTime = b.createdAt ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });

          // Obtener último mensaje
          MessageEntity? lastMessage;
          if (messages.isNotEmpty) {
            lastMessage = messages.first;
          }

          // Calcular mensajes no leídos
          int unreadCount = 0;
          for (final message in messages) {
            if (message.deliveryStatus == 'delivered' && 
                message.messageType == 'received') {
              unreadCount++;
            }
          }

          return ConversationWithMessages(
            conversation: conversation,
            messages: messages,
            unreadCount: unreadCount,
            lastMessage: lastMessage,
          );
        }).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error al obtener conversaciones del usuario: $e');
    }
  }

  Future<Map<String, int>> getConversationStats() async {
    try {
      // Obtener estadísticas de conversaciones
      final totalResponse = await _supabase
          .from('conversaciones')
          .select('id')
          .count();

      final activeResponse = await _supabase
          .from('conversaciones')
          .select('id')
          .eq('status', 'active')
          .count();

      final pendingResponse = await _supabase
          .from('conversaciones')
          .select('id')
          .eq('status', 'pending')
          .count();

      return {
        'total': totalResponse.count ?? 0,
        'active': activeResponse.count ?? 0,
        'pending': pendingResponse.count ?? 0,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }
}
