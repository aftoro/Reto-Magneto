import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/api_config.dart';
import '../models/conversation_entity.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  /// Obtener headers con autenticación
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    try {
      // Obtener sesión actual directamente
      final session = Supabase.instance.client.auth.currentSession;
      
      // Verificar y agregar token
      if (session != null && session.accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${session.accessToken}';
        print('🔐 Token de autenticación agregado a headers (${session.user.email ?? session.user.id})');
      } else {
        // Debug detallado
        final user = Supabase.instance.client.auth.currentUser;
        print('⚠️ No hay sesión de Supabase disponible');
        print('   Usuario actual: ${user != null ? '${user.id} (${user.email})' : 'null'}');
        print('   Sesión: ${session != null ? 'existe pero sin token' : 'null'}');
        if (session != null) {
          print('   Token vacío: ${session.accessToken.isEmpty}');
          print('   Refresh token: ${session.refreshToken?.isNotEmpty ?? false ? 'existe' : 'vacío'}');
        }
      }
    } catch (e, stackTrace) {
      print('⚠️ Error al obtener token de Supabase: $e');
      print('   Stack trace: $stackTrace');
    }
    
    return headers;
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

        // Obtener headers con autenticación
        final headers = await _getAuthHeaders();

        final response = await _dio.get(
          ApiConfig.chats,
          queryParameters: queryParams,
          options: Options(
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          final chatsResponse = ChatsResponse.fromJson(response.data);
          print('📋 [ChatApiService] Conversaciones cargadas: ${chatsResponse.chats.length}');
          for (var idx = 0; idx < chatsResponse.chats.length; idx++) {
            final chat = chatsResponse.chats[idx];
            print('   ${idx + 1}. Conversation ID: ${chat.conversation.id} | Username: ${chat.conversation.username} | User ID: ${chat.conversation.userId}');
          }
          return chatsResponse;
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('⚠️ [ChatApiService] Intento $retryCount/$maxRetries falló: ${e.message}');
        print('   Status code: ${e.response?.statusCode}');
        print('   Error type: ${e.type}');
        
        // Si es un error 401, devolver respuesta vacía en lugar de intentar refrescar
        // El refresh automático puede causar problemas con Supabase y cerrar la sesión
        if (e.response?.statusCode == 401) {
          print('🔐 Error 401 detectado, devolviendo respuesta vacía (no se intentará refrescar la sesión)');
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
        
        if (retryCount >= maxRetries) {
          // Si es un error de conexión o 404, devolver respuesta vacía en lugar de fallar
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError ||
              e.response?.statusCode == 404) {
            print('⚠️ Conexión fallida después de $maxRetries intentos, devolviendo respuesta vacía');
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
          // Para otros errores, lanzar excepción
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
      // Obtener headers con autenticación
      final headers = await _getAuthHeaders();

      final response = await _dio.get(
        '${ApiConfig.conversations}/$conversationId',
        options: Options(
          headers: headers,
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
      // Obtener headers con autenticación
      final headers = await _getAuthHeaders();

      // Construir URL usando buildUrl para asegurar formato correcto
      final url = ApiConfig.buildUrl('/messages/conversation/:id', {'id': conversationId});
      
      print('📨 [ChatApiService] Obteniendo mensajes de conversación');
      print('   📋 Conversation ID recibido: $conversationId');
      print('   📋 Tipo: ${conversationId.runtimeType}');
      print('   📋 Longitud: ${conversationId.length}');
      print('   🔗 URL construida: $url');
      print('   🔐 Headers con auth: ${headers.containsKey('Authorization')}');
      if (headers.containsKey('Authorization')) {
        final token = headers['Authorization'] as String;
        print('   🔐 Token (primeros 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      }

      final response = await _dio.get(
        url,
        queryParameters: {
          'limit': limit,
          'page': (offset / limit).floor() + 1, // Convertir offset a page
          'orderBy': 'created_at',
          'orderDirection': 'asc',
        },
        options: Options(
          headers: headers,
        ),
      );

      print('✅ [ChatApiService] Respuesta recibida');
      print('   Status Code: ${response.statusCode}');
      print('   Tipo de datos: ${response.data.runtimeType}');
      print('   Keys en response.data: ${(response.data as Map<String, dynamic>?)?.keys.toList()}');

      // El backend devuelve: { success: true, data: { messages: [...], total, page, limit } }
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        print('   Success: ${responseMap['success']}');
        print('   Data presente: ${responseMap['data'] != null}');
        
        if (responseMap['success'] == true && responseMap['data'] != null) {
          final data = responseMap['data'] as Map<String, dynamic>;
          print('   Keys en data: ${data.keys.toList()}');
          print('   Total en data: ${data['total']}');
          print('   Page en data: ${data['page']}');
          print('   Limit en data: ${data['limit']}');
          
          final messagesList = data['messages'] as List? ?? [];
          
          print('📬 [ChatApiService] Mensajes encontrados: ${messagesList.length}');
          if (messagesList.isNotEmpty) {
            print('   Primer mensaje: ${messagesList[0]}');
          }
          
          if (messagesList.isEmpty) {
            print('⚠️ No se encontraron mensajes en la conversación');
            return [];
          }
          
          return messagesList
              .map((msg) {
                try {
                  return MessageEntity.fromApiJson(msg);
                } catch (e) {
                  print('⚠️ Error al parsear mensaje: $e');
                  print('   Datos del mensaje: $msg');
                  return null;
                }
              })
              .whereType<MessageEntity>()
              .toList();
        } else if (response.data['messages'] != null) {
          // Formato alternativo: { messages: [...] }
          final messagesList = response.data['messages'] as List? ?? [];
          print('📬 Mensajes encontrados (formato alternativo): ${messagesList.length}');
          return messagesList
              .map((msg) {
                try {
                  return MessageEntity.fromApiJson(msg);
                } catch (e) {
                  print('⚠️ Error al parsear mensaje: $e');
                  return null;
                }
              })
              .whereType<MessageEntity>()
              .toList();
        } else {
          print('⚠️ Respuesta sin formato esperado: ${response.data}');
          return [];
        }
      } else {
        print('⚠️ Respuesta no es un Map: ${response.data.runtimeType}');
        return [];
      }
    } on DioException catch (e) {
      print('❌ Error DioException al obtener mensajes:');
      print('   Tipo: ${e.type}');
      print('   Mensaje: ${e.message}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        throw Exception('No autorizado. Por favor, inicia sesión nuevamente.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Conversación no encontrada.');
      } else {
        throw Exception('Error al obtener mensajes: ${e.message}');
      }
    } catch (e, stackTrace) {
      print('❌ Error inesperado al obtener mensajes: $e');
      print('   Stack trace: $stackTrace');
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
      // El backend devuelve: { success: true, data: { chats: [...], total, page, limit, has_more } }
      // Verificar si la respuesta tiene success: false
      if (json['success'] == false) {
        throw Exception(json['message'] ?? 'Error al obtener conversaciones');
      }

      // Obtener el objeto 'data' que contiene 'chats'
      final dataObj = json['data'] as Map<String, dynamic>?;
      if (dataObj == null) {
        throw Exception('La respuesta no contiene el campo "data"');
      }

      // Obtener la lista de conversaciones desde 'data.chats'
      final chatsList = dataObj['chats'] as List? ?? [];
      final chats = <ConversationWithMessages>[];
      
      for (final chatData in chatsList) {
        if (chatData != null && chatData is Map<String, dynamic>) {
          try {
            final chat = ConversationWithMessages.fromApiJson(chatData);
            chats.add(chat);
          } catch (e) {
            print('Error al procesar chat individual: $e');
            print('Datos del chat: $chatData');
            // Continuar con el siguiente chat en lugar de fallar completamente
          }
        }
      }

      // Obtener información de paginación desde 'data'
      final total = dataObj['total'] as int? ?? 0;
      final currentPage = dataObj['page'] as int? ?? 1;
      final limit = dataObj['limit'] as int? ?? 20;
      final hasMore = dataObj['has_more'] as bool? ?? false;
      final totalPages = (total / limit).ceil();

      final pagination = PaginationInfo(
        currentPage: currentPage,
        totalPages: totalPages > 0 ? totalPages : 1,
        totalItems: total,
        itemsPerPage: limit,
        hasNext: hasMore,
        hasPrev: currentPage > 1,
      );

      // Los filtros no vienen en la respuesta actual del backend
      final filters = <String, dynamic>{};

      return ChatsResponse(
        chats: chats,
        pagination: pagination,
        filters: filters,
      );
    } catch (e) {
      print('Error al procesar respuesta de chats: $e');
      print('Respuesta completa: $json');
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
