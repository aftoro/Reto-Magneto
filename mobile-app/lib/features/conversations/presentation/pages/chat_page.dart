import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sse_service.dart';
import '../../../../shared/widgets/chat_input_field.dart';
import '../../../messages/presentation/providers/message_provider.dart';
import '../../../messages/data/models/message_model.dart';
import '../../data/models/conversation_entity.dart';
import '../../data/datasources/chat_api_service.dart';
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
    _loadMessages();
  }

  /// Cargar mensajes de la conversación
  Future<void> _loadMessages() async {
    try {
      final conversationId = widget.conversation.conversation.id;
      print('🔄 [ChatPage] Iniciando carga de mensajes');
      print('   📋 Conversation ID: $conversationId');
      print('   📋 Tipo de Conversation ID: ${conversationId.runtimeType}');
      print('   📋 Longitud: ${conversationId.length}');
      print('   📋 Conversación completa: ${widget.conversation.conversation.toString()}');
      
      final chatApiService = ChatApiService();
      final messages = await chatApiService.getMessages(
        conversationId,
        limit: 100,
        offset: 0,
      );
      
      print('✅ Mensajes cargados exitosamente: ${messages.length}');
      
      if (mounted) {
        setState(() {
          _messages = messages;
        });
        _scrollToBottom();
        
        // Mostrar mensaje si no hay mensajes
        if (messages.isEmpty && _messages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No hay mensajes en esta conversación'),
              backgroundColor: AppConstants.textSecondary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error al cargar mensajes: $e');
      
      // Si falla, usar los mensajes que vienen en la conversación
      if (mounted) {
        if (widget.conversation.messages != null && widget.conversation.messages!.isNotEmpty) {
          setState(() {
            _messages = List.from(widget.conversation.messages!);
          });
          print('📦 Usando mensajes de la conversación inicial: ${_messages.length}');
        }
        
        // Mostrar error al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar mensajes: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: () => _loadMessages(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _newMessageSubscription?.cancel();
    super.dispose();
  }

  /// Restaurar el tab de conversaciones en MainAppPage
  void _restoreConversationsTab() {
    // Este método se llama cuando se hace pop para asegurar que el tab correcto esté activo
    // La lógica real está en MainAppPage usando .then() después de Navigator.push
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
        conversationId: widget.conversation.conversation.id,
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

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // Asegurar que el tab de conversaciones esté activo al volver
          // Buscar el MainAppPage en el árbol de widgets y restaurar el tab
          _restoreConversationsTab();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 40, // Reducir ancho del leading para más espacio
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppConstants.textTertiary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppConstants.textPrimary, size: 20), // Icono iOS
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.only(left: 8), // Padding ajustado
          ),
        title: Row(
          children: [
            // Avatar con halo emocional - más pegado
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.textTertiary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  _getEmotionImagePath(widget.conversation.conversation.userCurrentEmotion),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Nombre y estado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.conversation.userFullName ?? 
                    widget.conversation.conversation.username ?? 
                    widget.conversation.conversation.userId.substring(0, 8),
                    style: GoogleFonts.poppins(
                      color: AppConstants.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.conversation.conversation.status == 'active') ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppConstants.successColor, // Verde Magneto
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        widget.conversation.conversation.status == 'active' 
                            ? 'En línea' 
                            : 'Desconectado',
                        style: GoogleFonts.manrope(
                          color: AppConstants.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        titleSpacing: 0, // Eliminar espaciado extra del título
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: AppConstants.textSecondary),
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
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para light mode
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(), // Bouncing scroll
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, // Margen lateral mejorado
                        vertical: AppConstants.spacingM,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _MessageBubble(message: message);
                      },
                    ),
            ),
            
            // Message Input - Estilo Instagram
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), // Padding como Instagram
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppConstants.textTertiary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No hay mensajes',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Envía el primer mensaje para\niniciar la conversación',
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: AppConstants.textSecondary,
              height: 1.5,
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
    final isHumanAgent = message.authorType == 'human_agent';
    
    // Debug temporal para ver los valores
    print('Message Debug: isIncoming=$isIncoming, isAiGenerated=$isAiGenerated, isHumanAgent=$isHumanAgent, authorType=${message.authorType}');

    // Función para obtener el color correcto según el tipo de mensaje
    Color _getMessageColor() {
      if (isIncoming) {
        return const Color(0xFFF3F4F6); // Gris claro para mensajes entrantes en light mode
      } else {
        // Para mensajes salientes (de nosotros)
        if (isHumanAgent) {
          return AppConstants.successColor; // Verde para agentes humanos de nosotros
        } else if (isAiGenerated) {
          // Púrpura Magneto para IA con opacidad reducida para no saturar
          return AppConstants.primaryColor.withOpacity(0.85);
        } else {
          return AppConstants.primaryColor; // Púrpura por defecto para otros mensajes de nosotros
        }
      }
    }

    return Align(
      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Espaciado vertical aumentado de 2 a 8
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Burbuja principal
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: _getMessageColor(), // Color dinámico según el tipo de mensaje
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isIncoming ? const Radius.circular(4) : const Radius.circular(18),
                  bottomRight: isIncoming ? const Radius.circular(18) : const Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Contenido del mensaje
                  Padding(
                    padding: const EdgeInsets.only(right: 45),
                    child: MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary // Texto negro para mensajes entrantes
                              : Colors.white, // Texto blanco para mensajes salientes
                          fontSize: 16,
                          height: 1.5, // Mejor interlineado para legibilidad
                        ),
                        strong: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary // Negro para texto en negrita
                              : Colors.white, // Blanco para texto en negrita
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        em: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                        listBullet: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          fontSize: 16,
                        ),
                        h1: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        h2: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        h3: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        code: TextStyle(
                          color: isIncoming 
                              ? AppConstants.textPrimary 
                              : Colors.white,
                          backgroundColor: isIncoming
                              ? Colors.black.withOpacity(0.05)
                              : Colors.white.withOpacity(0.2),
                          fontSize: 14,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: isIncoming
                              ? Colors.black.withOpacity(0.05)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      selectable: true,
                    ),
                  ),
                  // Timestamp y estado en la esquina inferior derecha
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: TextStyle(
                            color: isIncoming 
                                ? AppConstants.textSecondary // Gris para timestamps en mensajes entrantes
                                : Colors.white70, // Blanco con opacidad para timestamps en mensajes salientes
                            fontSize: 11,
                          ),
                        ),
                        // Indicadores solo para mensajes salientes (de nosotros)
                        if (!isIncoming) ...[
                          const SizedBox(width: 4),
                          if (isAiGenerated)
                            Icon(
                              Icons.smart_toy,
                              size: 12,
                              color: Colors.white70,
                            )
                          else if (isHumanAgent)
                            Icon(
                              Icons.support_agent,
                              size: 12,
                              color: Colors.white70,
                            )
                          else
                            Icon(
                              Icons.person,
                              size: 12,
                              color: Colors.white70,
                            ),
                        ],
                        // Indicador de estado de envío
                        if (!isIncoming && message.deliveryStatus == 'sending') ...[
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                            ),
                          ),
                        ],
                        // Indicador de mensaje enviado
                        if (!isIncoming && message.deliveryStatus == 'sent') ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white70,
                          ),
                        ],
                        // Indicador de mensaje fallido
                        if (!isIncoming && message.deliveryStatus == 'failed') ...[
                          const SizedBox(width: 4),
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
                                const SizedBox(width: 2),
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
                  ),
                ],
              ),
            ),
            // Colita de WhatsApp - estilo real
            Positioned(
              bottom: 0,
              left: isIncoming ? -6 : null,
              right: isIncoming ? null : -6,
              child: CustomPaint(
                size: const Size(12, 20),
                painter: _WhatsAppTailPainter(
                  color: _getMessageColor(), // Color dinámico según el tipo de mensaje
                  isIncoming: isIncoming,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

      String _formatTime(DateTime? time) {
        if (time == null) return '';
        
        final now = DateTime.now();
        final difference = now.difference(time);

        // Si es del mismo día, mostrar hora en formato HH:mm
        if (time.year == now.year && time.month == now.month && time.day == now.day) {
          final hour = time.hour.toString().padLeft(2, '0');
          final minute = time.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        
        // Si es de ayer, mostrar "Ayer"
        final yesterday = now.subtract(const Duration(days: 1));
        if (time.year == yesterday.year && 
            time.month == yesterday.month && 
            time.day == yesterday.day) {
          return 'Ayer';
        }
        
        // Si es de esta semana, mostrar el día de la semana
        if (difference.inDays < 7) {
          final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
          return weekdays[time.weekday - 1];
        }
        
        // Si es más antiguo, mostrar fecha corta DD/MM
        final day = time.day.toString().padLeft(2, '0');
        final month = time.month.toString().padLeft(2, '0');
        return '$day/$month';
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

// Clase para dibujar la colita de WhatsApp
class _WhatsAppTailPainter extends CustomPainter {
  final Color color;
  final bool isIncoming;

  _WhatsAppTailPainter({
    required this.color,
    required this.isIncoming,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isIncoming) {
      // Colita para mensajes entrantes (izquierda) - punta puntiaguda como WhatsApp
      path.moveTo(size.width, 0); // Punto de anclaje superior derecho (en la burbuja)
      path.lineTo(size.width, size.height * 0.7); // Baja por el borde derecho
      path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.9, // Punto de control para la curva
        0, size.height, // Punta de la colilla (inferior izquierda)
      );
      path.close();
    } else {
      // Colita para mensajes salientes (derecha) - punta puntiaguda como WhatsApp
      path.moveTo(0, 0); // Punto de anclaje superior izquierdo (en la burbuja)
      path.lineTo(0, size.height * 0.7); // Baja por el borde izquierdo
      path.quadraticBezierTo(
        size.width * 0.2, size.height * 0.9, // Punto de control para la curva
        size.width, size.height, // Punta de la colilla (inferior derecha)
      );
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

  // Métodos para manejar emociones
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

  String _getEmotionImagePath(String? emotion) {
    switch (emotion?.toLowerCase()) {
      // POSITIVAS
      case 'happy':
      case 'feliz':
        return 'assets/images/emotions/happy.png';
      case 'excited':
      case 'emocionado':
        return 'assets/images/emotions/excited.png';
      case 'hopeful':
        return 'assets/images/emotions/hopeful.png';
      case 'grateful':
        return 'assets/images/emotions/grateful.png';
      case 'calm':
      case 'tranquilo':
        return 'assets/images/emotions/calm.png';
      // NEGATIVAS
      case 'sad':
      case 'triste':
        return 'assets/images/emotions/sad.png';
      case 'angry':
      case 'enojado':
        return 'assets/images/emotions/angry.png';
      case 'stressed':
        return 'assets/images/emotions/stressed.png';
      case 'disappointed':
        return 'assets/images/emotions/disappointed.png';
      // NEUTRAS
      case 'confused':
      case 'confundido':
        return 'assets/images/emotions/confused.png';
      case 'curious':
        return 'assets/images/emotions/curious.png';
      case 'neutral':
        return 'assets/images/emotions/neutral.png';
      default:
        return 'assets/images/emotions/neutral.png';
    }
  }


