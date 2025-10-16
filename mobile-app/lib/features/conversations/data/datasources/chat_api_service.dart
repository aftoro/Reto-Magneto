import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/conversation_entity.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  // Stream para notificaciones SSE
  StreamController<Map<String, dynamic>>? _sseController;
  EventSource? _eventSource;

  /// Obtener lista de chats con paginación
  Future<ChatsResponse> getChats({
    int page = 1,
    int limit = 20,
    String platform = 'instagram',
    String conversationType = 'dm',
    String? search,
    String status = 'active',
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final queryParams = {
          'page': page,
          'limit': limit,
          'platform': platform,
          'conversation_type': conversationType,
          'status': status,
          if (search != null) 'search': search,
        };

        final response = await _dio.get(
          ApiConfig.chats,
          queryParameters: queryParams,
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return ChatsResponse.fromJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error de conexión, devolver respuesta vacía en lugar de fallar
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('Conexión fallida después de $maxRetries intentos, devolviendo respuesta vacía');
            return ChatsResponse(
              chats: [],
              pagination: PaginationInfo(
                currentPage: 1,
                totalPages: 1,
                totalItems: 0,
                itemsPerPage: limit,
                hasNext: false,
                hasPrev: false,
              ),
              filters: {},
            );
          }
          throw Exception('Error al obtener chats después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener chats: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener chats');
  }

  /// Obtener conversación específica con mensajes
  Future<ConversationWithMessages> getConversation(String conversationId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.conversations}/$conversationId',
        options: Options(
          headers: ApiConfig.defaultHeaders,
        ),
      );

      return ConversationWithMessages.fromApiJson(response.data['conversation']);
    } catch (e) {
      throw Exception('Error al obtener conversación: $e');
    }
  }

  /// Obtener mensajes de una conversación
  Future<List<MessageEntity>> getMessages(
    String conversationId, {
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.conversations}/$conversationId/messages',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(
          headers: ApiConfig.defaultHeaders,
        ),
      );

      return (response.data['messages'] as List)
          .map((msg) => MessageEntity.fromApiJson(msg))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mensajes: $e');
    }
  }

  /// Conectar a notificaciones SSE
  Stream<Map<String, dynamic>> connectToNotifications() {
    if (_sseController != null && !_sseController!.isClosed) {
      return _sseController!.stream;
    }

    _sseController = StreamController<Map<String, dynamic>>.broadcast();
    _startSSEConnection();
    
    return _sseController!.stream;
  }

  /// Iniciar conexión SSE
  void _startSSEConnection() {
    try {
      _eventSource = EventSource(ApiConfig.notifications);
      
      _eventSource!.setOnMessage((event) {
        try {
          final data = json.decode(event);
          _sseController?.add(data);
        } catch (e) {
          print('Error al procesar mensaje SSE: $e');
        }
      });

      _eventSource!.setOnError((error) {
        print('Error en conexión SSE: $error');
        // Intentar reconectar después de 5 segundos
        Timer(Duration(seconds: 5), () {
          if (_sseController != null && !_sseController!.isClosed) {
            _startSSEConnection();
          }
        });
      });
    } catch (e) {
      print('Error al iniciar SSE: $e');
    }
  }

  /// Desconectar de notificaciones
  void disconnectFromNotifications() {
    _eventSource?.close();
    _sseController?.close();
    _sseController = null;
    _eventSource = null;
  }

  /// Verificar si está conectado
  bool get isConnected => _eventSource != null && _sseController != null && !_sseController!.isClosed;
}

/// Clase para manejar EventSource (Server-Sent Events)
class EventSource {
  late StreamSubscription _subscription;
  late StreamController<String> _controller;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  EventSource(String url) {
    _controller = StreamController<String>.broadcast();
    _connect(url);
  }

  void _connect(String url) {
    try {
      // Simular conexión SSE usando polling
      _subscription = Stream.periodic(Duration(seconds: 2))
          .asyncMap((_) => _fetchSSEData(url))
          .listen(
        (data) {
          if (data != null) {
            _controller.add(data);
          }
        },
        onError: (error) {
          print('Error en SSE: $error');
          _handleReconnect(url);
        },
      );
    } catch (e) {
      print('Error al conectar SSE: $e');
      _handleReconnect(url);
    }
  }

  Future<String?> _fetchSSEData(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            ...ApiConfig.defaultHeaders,
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  void _handleReconnect(String url) {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      _reconnectTimer = Timer(Duration(seconds: 5), () {
        _connect(url);
      });
    }
  }

  void setOnMessage(Function(String) callback) {
    _controller.stream.listen(callback);
  }

  void setOnError(Function(dynamic) callback) {
    _controller.stream.listen(
      (_) {},
      onError: callback,
    );
  }

  void close() {
    _subscription.cancel();
    _controller.close();
    _reconnectTimer?.cancel();
  }
}

/// Modelo para respuesta de chats con paginación
class ChatsResponse {
  final List<ConversationWithMessages> chats;
  final PaginationInfo pagination;
  final Map<String, dynamic> filters;

  ChatsResponse({
    required this.chats,
    required this.pagination,
    required this.filters,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Manejar la nueva estructura de la API con validación de null
      final chatsList = json['chats'] as List? ?? [];
      final chats = <ConversationWithMessages>[];
      
      for (final chatData in chatsList) {
        if (chatData != null && chatData is Map<String, dynamic>) {
          try {
            final chat = ConversationWithMessages.fromApiJson(chatData);
            chats.add(chat);
          } catch (e) {
            print('Error al procesar chat individual: $e');
            // Continuar con el siguiente chat en lugar de fallar completamente
          }
        }
      }

      // Crear información de paginación basada en la nueva estructura
      final pagination = PaginationInfo(
        currentPage: 1, // La API no proporciona página actual en la nueva estructura
        totalPages: 1, // Calcular basado en total y limit
        totalItems: json['total'] ?? 0,
        itemsPerPage: json['limit'] ?? 20,
        hasNext: json['has_more'] ?? false,
        hasPrev: false, // No hay información de página anterior
      );

      return ChatsResponse(
        chats: chats,
        pagination: pagination,
        filters: {}, // La nueva API no incluye filtros en la respuesta
      );
    } catch (e) {
      print('Error al procesar respuesta de chats: $e');
      // Retornar respuesta vacía en caso de error
      return ChatsResponse(
        chats: [],
        pagination: PaginationInfo(
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          itemsPerPage: 20,
          hasNext: false,
          hasPrev: false,
        ),
        filters: {},
      );
    }
  }
}

/// Modelo para información de paginación
class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNext;
  final bool hasPrev;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      itemsPerPage: json['items_per_page'] ?? 20,
      hasNext: json['has_next'] ?? false,
      hasPrev: json['has_prev'] ?? false,
    );
  }
}
