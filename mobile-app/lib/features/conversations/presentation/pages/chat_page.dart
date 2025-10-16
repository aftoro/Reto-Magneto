import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../shared/widgets/chat_input_field.dart';
import '../../../messages/presentation/providers/message_provider.dart';
import '../../../messages/data/models/message_model.dart';
import '../../data/models/conversation_entity.dart';
import 'chat_info_page.dart';

class ChatPage extends ConsumerStatefulWidget {
  final ConversationWithMessages conversation;

  const ChatPage({
    super.key,
    required this.conversation,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late List<MessageEntity> _messages;
  StreamSubscription? _newMessageSubscription;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages ?? []);
    _initializeRealTimeMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _newMessageSubscription?.cancel();
    super.dispose();
  }

  /// Inicializar mensajes en tiempo real
  void _initializeRealTimeMessages() {
    // Escuchar nuevos mensajes desde el servicio SSE global
    _newMessageSubscription = ref.read(sseServiceProvider).newMessageStream.listen((data) {
      final message = MessageEntity.fromApiJson(data);
      // Solo procesar mensajes de esta conversación
      if (message.conversacionId == widget.conversation.conversation.id) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
      }
    });
  }

  /// Scroll al final de la lista
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      
      // Crear mensaje optimista
      final optimisticMessage = MessageEntity(
        id: UniqueKey().toString(),
        conversacionId: widget.conversation.conversation.id,
        content: messageText,
        messageType: 'outgoing',
        authorName: 'Usuario',
        authorType: 'user',
        createdAt: DateTime.now(),
        deliveryStatus: 'sending',
        isAiGenerated: false,
      );

      // Agregar mensaje optimista inmediatamente
      setState(() {
        _messages.add(optimisticMessage);
      });
      
      // Scroll al final
      _scrollToBottom();
      
      // Limpiar el campo de texto
      _messageController.clear();

      // Enviar mensaje al servidor
      final message = MessageModel(
        message: messageText,
        recipientId: widget.conversation.conversation.userId,
        senderName: 'Usuario',
      );

      ref.read(messageNotifierProvider.notifier).sendMessage(message);
    }
  }



  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageNotifierProvider);

    ref.listen<MessageState>(messageNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (message) {
          // Actualizar el mensaje optimista con el ID real del servidor
          setState(() {
            final optimisticIndex = _messages.indexWhere(
              (m) => m.deliveryStatus == 'sending' && m.content == message,
            );
            if (optimisticIndex != -1) {
              _messages[optimisticIndex] = _messages[optimisticIndex].copyWith(
                id: UniqueKey().toString(), // En un caso real, usarías el ID del servidor
                deliveryStatus: 'sent',
              );
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mensaje enviado exitosamente'),
              backgroundColor: AppConstants.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        },
        error: (error) {
          // Marcar mensaje como fallido
          setState(() {
            final optimisticIndex = _messages.indexWhere(
              (m) => m.deliveryStatus == 'sending',
            );
            if (optimisticIndex != -1) {
              _messages[optimisticIndex] = _messages[optimisticIndex].copyWith(
                deliveryStatus: 'failed',
              );
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al enviar mensaje: $error'),
              backgroundColor: AppConstants.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Circle Avatar a la izquierda
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getEmotionGradient(widget.conversation.conversation.userCurrentEmotion),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getEmotionColor(widget.conversation.conversation.userCurrentEmotion).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getEmotionEmoji(widget.conversation.conversation.userCurrentEmotion),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nombre y estado pegados al avatar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.conversation.userFullName ?? 
                    widget.conversation.conversation.username ?? 
                    widget.conversation.conversation.userId.substring(0, 8),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.conversation.conversation.status == 'active' 
                        ? 'En línea' 
                        : 'Desconectado',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2937), Color(0xFF374151)], // Dark mode gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatInfoPage(
                    conversation: widget.conversation.conversation,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F), // Dark background
              Color(0xFF1A1A1A), // Darker background
            ],
          ),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppConstants.spacingM),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _MessageBubble(message: message);
                      },
                    ),
            ),
            
            // Message Input
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF2D2D2D),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ChatInputField(
                controller: _messageController,
                hintText: 'Escribe tu mensaje...',
                onSend: messageState.maybeWhen(
                  loading: () => null,
                  orElse: () => _sendMessage,
                ),
                isLoading: messageState.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay mensajes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Envía el primer mensaje para iniciar la conversación',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isIncoming = message.messageType == 'incoming';
    final isAiGenerated = message.isAiGenerated ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        mainAxisAlignment: isIncoming 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isIncoming) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF374151), // Dark gray for user avatar
              child: Icon(
                Icons.person,
                size: 16,
                color: const Color(0xFFE5E7EB), // Light icon
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingS,
              ),
              decoration: BoxDecoration(
                color: isIncoming 
                    ? const Color(0xFF374151) // Dark gray for incoming messages
                    : const Color(0xFF1F2937), // Darker gray for outgoing messages
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppConstants.radiusM),
                  topRight: const Radius.circular(AppConstants.radiusM),
                  bottomLeft: Radius.circular(isIncoming ? 4 : AppConstants.radiusM),
                  bottomRight: Radius.circular(isIncoming ? AppConstants.radiusM : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // Información del autor (solo para mensajes salientes)
                      if (!isIncoming && message.authorName != null) ...[
                        Text(
                          message.authorName!,
                          style: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFF64748B) 
                                : const Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      
                      // Contenido del mensaje con Markdown
                      MarkdownBody(
                        data: message.content,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFE5E7EB) // Light text for incoming messages
                                : const Color(0xFFF1F5F9), // Light text for outgoing messages
                            fontSize: 14,
                            height: 1.4,
                          ),
                          strong: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFFFFFFF) // White for bold text
                                : const Color(0xFFFFFFFF), // White for bold text
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                          em: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFE5E7EB) 
                                : const Color(0xFFF1F5F9),
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                          listBullet: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFE5E7EB) 
                                : const Color(0xFFF1F5F9),
                            fontSize: 14,
                          ),
                          h1: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFFFFFFF) 
                                : const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          h2: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFFFFFFF) 
                                : const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          h3: TextStyle(
                            color: isIncoming 
                                ? const Color(0xFFFFFFFF) 
                                : const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                    ),
                    selectable: true,
                  ),
                  const SizedBox(height: AppConstants.spacingXS),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.createdAt),
                            style: TextStyle(
                              color: isIncoming 
                                  ? const Color(0xFF64748B) // Gris medio para timestamps del usuario
                                  : const Color(0xFF94A3B8), // Gris claro para timestamps de IA
                              fontSize: 10,
                            ),
                          ),
                          if (isAiGenerated) ...[
                            const SizedBox(width: AppConstants.spacingXS),
                            Icon(
                              Icons.smart_toy,
                              size: 12,
                              color: isIncoming 
                                  ? const Color(0xFF64748B) 
                                  : const Color(0xFF94A3B8),
                            ),
                          ],
                          // Indicador de estado de envío
                          if (!isIncoming && message.deliveryStatus == 'sending') ...[
                            const SizedBox(width: AppConstants.spacingXS),
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isIncoming 
                                      ? const Color(0xFF64748B) 
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                          // Indicador de mensaje enviado
                          if (!isIncoming && message.deliveryStatus == 'sent') ...[
                            const SizedBox(width: AppConstants.spacingXS),
                            Icon(
                              Icons.check,
                              size: 12,
                              color: isIncoming 
                                  ? const Color(0xFF64748B) 
                                  : const Color(0xFF94A3B8),
                            ),
                          ],
                          // Indicador de mensaje fallido con botón de reintento
                          if (!isIncoming && message.deliveryStatus == 'failed') ...[
                            const SizedBox(width: AppConstants.spacingXS),
                            GestureDetector(
                              onTap: () => _retryMessage(message),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 12,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.refresh,
                                    size: 10,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                ],
              ),
            ),
          ),
              if (!isIncoming) ...[
                const SizedBox(width: AppConstants.spacingS),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _getAuthorColor(message.authorType),
                  child: Icon(
                    _getAuthorIcon(message.authorType, isAiGenerated),
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
        ],
      ),
    );
  }

      String _formatTime(DateTime? time) {
        if (time == null) return '';
        
        final now = DateTime.now();
        final difference = now.difference(time);

        if (difference.inMinutes < 1) {
          return 'Ahora';
        } else if (difference.inMinutes < 60) {
          return '${difference.inMinutes}m';
        } else if (difference.inHours < 24) {
          return '${difference.inHours}h';
        } else {
          return '${difference.inDays}d';
        }
      }

      Color _getAuthorColor(String? authorType) {
        switch (authorType) {
          case 'ai':
            return const Color(0xFF3B82F6); // Azul para IA
          case 'human_agent':
            return const Color(0xFF10B981); // Verde para agente humano
          default:
            return const Color(0xFF6B7280); // Gris para otros
        }
      }

      IconData _getAuthorIcon(String? authorType, bool isAiGenerated) {
        switch (authorType) {
          case 'ai':
            return Icons.smart_toy;
          case 'human_agent':
            return Icons.support_agent;
          default:
            return isAiGenerated ? Icons.smart_toy : Icons.business;
        }
      }

      void _retryMessage(MessageEntity message) {
        // Este método debe estar en la clase principal _ChatPageState
        // Por ahora, solo mostramos un mensaje
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Función de reintento no disponible en esta vista'),
        //     backgroundColor: Colors.orange,
        //   ),
        // );
      }
    }

  // Métodos para manejar emociones
  List<Color> _getEmotionGradient(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
      case 'feliz':
        return [const Color(0xFFF59E0B), const Color(0xFFF97316)]; // Amarillo/Naranja
      case 'sad':
      case 'triste':
        return [const Color(0xFF3B82F6), const Color(0xFF1E40AF)]; // Azul
      case 'angry':
      case 'enojado':
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)]; // Rojo
      case 'excited':
      case 'emocionado':
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]; // Púrpura
      case 'calm':
      case 'tranquilo':
        return [const Color(0xFF10B981), const Color(0xFF059669)]; // Verde
      case 'confused':
      case 'confundido':
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)]; // Gris
      default:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)]; // Gris por defecto
    }
  }

  Color _getEmotionColor(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
      case 'feliz':
        return const Color(0xFFF59E0B);
      case 'sad':
      case 'triste':
        return const Color(0xFF3B82F6);
      case 'angry':
      case 'enojado':
        return const Color(0xFFEF4444);
      case 'excited':
      case 'emocionado':
        return const Color(0xFF8B5CF6);
      case 'calm':
      case 'tranquilo':
        return const Color(0xFF10B981);
      case 'confused':
      case 'confundido':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getEmotionEmoji(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
      case 'feliz':
        return '😊';
      case 'sad':
      case 'triste':
        return '😢';
      case 'angry':
      case 'enojado':
        return '😠';
      case 'excited':
      case 'emocionado':
        return '🤩';
      case 'calm':
      case 'tranquilo':
        return '😌';
      case 'confused':
      case 'confundido':
        return '😕';
      default:
        return '😐';
    }
  }
