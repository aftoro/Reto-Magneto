import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/conversation_entity.dart';
import '../../data/datasources/chat_api_service.dart';
import '../../../../core/services/sse_service.dart';

part 'conversation_provider.freezed.dart';

// Provider para el servicio de API
final chatApiServiceProvider = Provider<ChatApiService>((ref) => ChatApiService());

@freezed
class ConversationState with _$ConversationState {
  const factory ConversationState.initial() = _Initial;
  const factory ConversationState.loading() = _Loading;
  const factory ConversationState.loaded({
    required List<ConversationWithMessages> conversations,
    required Map<String, int> stats,
  }) = _Loaded;
  const factory ConversationState.error({required String message}) = _Error;
}

class ConversationNotifier extends StateNotifier<ConversationState> {
  final ChatApiService _chatApiService;
  final SSEService _sseService;
  StreamSubscription? _newMessageSubscription;
  StreamSubscription? _newConversationSubscription;

  ConversationNotifier({
    required ChatApiService chatApiService,
    required SSEService sseService,
  }) : _chatApiService = chatApiService,
       _sseService = sseService,
       super(const ConversationState.initial()) {
    _initializeSSE();
  }

  /// Inicializar conexión SSE
  void _initializeSSE() {
    // Escuchar nuevos mensajes desde SSE
    _newMessageSubscription = _sseService.newMessageStream.listen(
      (data) {
        final message = MessageEntity.fromApiJson(data);
        _handleNewMessage(message);
      },
    );

    // Escuchar nuevas conversaciones desde SSE
    _newConversationSubscription = _sseService.newConversationStream.listen(
      (data) {
        final conversation = ConversationWithMessages.fromApiJson(data);
        _handleNewConversation(conversation);
      },
    );
  }

  /// Cargar conversaciones
  Future<void> loadConversations({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    state = const ConversationState.loading();
    try {
      final response = await _chatApiService.getChats(
        page: page,
        limit: limit,
        search: search,
      );
      
      final stats = _calculateStats(response.chats);
      state = ConversationState.loaded(
        conversations: response.chats,
        stats: stats,
      );
    } catch (e) {
      state = ConversationState.error(message: e.toString());
    }
  }

  /// Refrescar conversaciones
  Future<void> refreshConversations() async {
    await loadConversations();
  }

  /// Manejar nuevo mensaje
  void _handleNewMessage(MessageEntity message) {
    final currentState = state;
    
    currentState.whenOrNull(
      loaded: (conversations, stats) {
        final conversationId = message.conversacionId;
        if (conversationId == null) return;

        // Buscar la conversación existente
        final conversationIndex = conversations.indexWhere(
          (c) => c.conversation.id == conversationId,
        );

        if (conversationIndex != -1) {
          // Actualizar conversación existente
          final existingConversation = conversations[conversationIndex];
          final updatedMessages = [...(existingConversation.messages ?? []), message];
          
          // Reordenar conversaciones (mover al inicio como WhatsApp)
          final updatedConversations = List<ConversationWithMessages>.from(conversations);
          updatedConversations.removeAt(conversationIndex);
          
          final updatedConversation = existingConversation.copyWith(
            messages: updatedMessages.cast<MessageEntity>(),
            lastMessage: message,
            unreadCount: (existingConversation.unreadCount ?? 0) + 
                (message.messageType == 'incoming' ? 1 : 0),
          );
          
          updatedConversations.insert(0, updatedConversation);
          
          final newStats = _calculateStats(updatedConversations);
          state = ConversationState.loaded(
            conversations: updatedConversations,
            stats: newStats,
          );
        }
      },
    );
  }

  /// Manejar nueva conversación
  void _handleNewConversation(ConversationWithMessages conversation) {
    final currentState = state;
    
    currentState.whenOrNull(
      loaded: (conversations, stats) {
        // Agregar al inicio de la lista
        final updatedConversations = [conversation, ...conversations];
        final newStats = _calculateStats(updatedConversations);
        
        state = ConversationState.loaded(
          conversations: updatedConversations,
          stats: newStats,
        );
      },
    );
  }

  /// Calcular estadísticas
  Map<String, int> _calculateStats(List<ConversationWithMessages> conversations) {
    int total = conversations.length;
    int active = conversations.where((c) => c.conversation.status == 'active').length;
    int pending = conversations.where((c) => c.conversation.status == 'pending').length;
    int unread = conversations.fold(0, (sum, c) => sum + (c.unreadCount ?? 0));

    return {
      'total': total,
      'active': active,
      'pending': pending,
      'unread': unread,
    };
  }

  /// Obtener conversación específica
  Future<ConversationWithMessages?> getConversation(String conversationId) async {
    try {
      return await _chatApiService.getConversation(conversationId);
    } catch (e) {
      print('Error al obtener conversación: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _newMessageSubscription?.cancel();
    _newConversationSubscription?.cancel();
    super.dispose();
  }
}

final conversationNotifierProvider = StateNotifierProvider<ConversationNotifier, ConversationState>((ref) {
  return ConversationNotifier(
    chatApiService: ref.watch(chatApiServiceProvider),
    sseService: ref.watch(sseServiceProvider),
  );
});