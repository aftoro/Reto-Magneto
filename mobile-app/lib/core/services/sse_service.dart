import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/api_config.dart';

class SSEService {
  http.Client? _client;
  StreamSubscription? _sseSubscription;
  StreamSubscription? _responseStreamSubscription;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  bool _isAuthenticated = false;

  // Streams públicos
  final _newMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _newConversationController = StreamController<Map<String, dynamic>>.broadcast();
  final _newCommentController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get newMessageStream => _newMessageController.stream;
  Stream<Map<String, dynamic>> get newConversationStream => _newConversationController.stream;
  Stream<Map<String, dynamic>> get newCommentStream => _newCommentController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  
  bool get isConnected => _isConnected;
  bool get isAuthenticated => _isAuthenticated;

  /// Establecer estado de autenticación
  void setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    if (authenticated && !_isConnected) {
      _connect();
    } else if (!authenticated && _isConnected) {
      _disconnect();
    }
  }

  /// Conectar a SSE real
  void _connect() {
    if (!_isAuthenticated || _isConnected) return;

    try {
      _client = http.Client();
      final uri = Uri.parse(ApiConfig.notifications);
      
      print('🔗 Estableciendo conexión SSE a: $uri');
      
      final request = http.Request('GET', uri);
      request.headers.addAll(ApiConfig.defaultHeaders);
      
      // Agregar token de autenticación de Supabase si está disponible
      try {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null && session.accessToken.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer ${session.accessToken}';
          print('🔐 Token de autenticación agregado al header SSE');
        } else {
          print('⚠️ No hay sesión de Supabase disponible para SSE');
        }
      } catch (e) {
        print('⚠️ Error al obtener token de Supabase para SSE: $e');
      }
      
      _sseSubscription = _client!.send(request).asStream().listen(
        (response) async {
          if (response.statusCode == 200) {
            _isConnected = true;
            _connectionStatusController.add(true);
            print('✅ Conectado a SSE exitosamente (${response.statusCode})');
            
            // Procesar stream de datos línea por línea
            String buffer = '';
            _responseStreamSubscription = response.stream.listen(
              (chunk) {
                try {
                  buffer += utf8.decode(chunk);
                  final lines = buffer.split('\n');
                  // Mantener la última línea incompleta en el buffer
                  if (lines.isNotEmpty) {
                    buffer = lines.removeLast();
                  }
                  
                  for (final line in lines) {
                    if (line.trim().isEmpty) continue;
                    _processSSELine(line.trim());
                  }
                } catch (e) {
                  print('❌ Error al procesar chunk SSE: $e');
                }
              },
              onError: (error) {
                print('❌ Error en stream SSE: $error');
                _handleConnectionError();
              },
              onDone: () {
                print('🔌 Conexión SSE cerrada por el servidor');
                // Procesar cualquier dato restante en el buffer
                if (buffer.trim().isNotEmpty) {
                  _processSSELine(buffer.trim());
                }
                _handleConnectionError();
              },
              cancelOnError: false,
            );
          } else {
            print('❌ Error HTTP en SSE: ${response.statusCode}');
            final errorBody = await response.stream.bytesToString();
            print('   Respuesta del servidor: $errorBody');
            _handleConnectionError();
          }
        },
        onError: (error) {
          print('❌ Error al conectar SSE: $error');
          _handleConnectionError();
        },
        cancelOnError: false,
      );
    } catch (e) {
      print('❌ Error al conectar SSE: $e');
      _handleConnectionError();
    }
  }

  /// Procesar línea SSE individual
  void _processSSELine(String line) {
    if (line.startsWith('data: ')) {
      final jsonData = line.substring(6).trim(); // Remover 'data: '
      if (jsonData.isNotEmpty) {
        try {
          final eventData = json.decode(jsonData) as Map<String, dynamic>;
          _processSSEMessage(eventData);
        } catch (e) {
          print('❌ Error al parsear JSON SSE: $e');
          print('   Datos recibidos: $jsonData');
        }
      }
    } else if (line.startsWith('event: ')) {
      // Procesar tipo de evento si es necesario
      final eventType = line.substring(7).trim();
      print('📡 Evento SSE recibido: $eventType');
    } else if (line.startsWith('id: ')) {
      // Procesar ID del evento si es necesario
      final eventId = line.substring(4).trim();
      print('🆔 ID de evento SSE: $eventId');
    }
  }

  /// Manejar error de conexión
  void _handleConnectionError() {
    _isConnected = false;
    _connectionStatusController.add(false);
    
    // Intentar reconectar después de 5 segundos
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      if (_isAuthenticated) {
        print('🔄 Intentando reconectar SSE...');
        _connect();
      }
    });
  }

  /// Desconectar de SSE
  void _disconnect() {
    _sseSubscription?.cancel();
    _sseSubscription = null;
    _responseStreamSubscription?.cancel();
    _responseStreamSubscription = null;
    _client?.close();
    _client = null;
    _reconnectTimer?.cancel();
    _isConnected = false;
    _connectionStatusController.add(false);
    print('❌ Desconectado de SSE');
  }

  /// Procesar mensajes SSE
  void _processSSEMessage(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    if (type == null) {
      print('⚠️ Mensaje SSE sin tipo: $data');
      return;
    }

    switch (type) {
      case 'new_message':
        final payload = data['data'];
        if (payload != null && payload is Map<String, dynamic>) {
          _newMessageController.add(payload);
          print('📨 Nuevo mensaje recibido via SSE');
        } else {
          print('⚠️ Mensaje SSE sin payload válido: $data');
        }
        break;
      case 'new_conversation':
        final payload = data['data'];
        if (payload != null && payload is Map<String, dynamic>) {
          _newConversationController.add(payload);
          print('💬 Nueva conversación recibida via SSE');
        } else {
          print('⚠️ Conversación SSE sin payload válido: $data');
        }
        break;
      case 'new_comment':
        final payload = data['data'];
        if (payload != null && payload is Map<String, dynamic>) {
          _newCommentController.add(payload);
          print('💬 Nuevo comentario recibido via SSE');
        } else {
          print('⚠️ Comentario SSE sin payload válido: $data');
        }
        break;
      case 'connected':
        print('🔗 Conectado a notificaciones en tiempo real: ${data['message'] ?? 'Conectado'}');
        print('   Autenticado: ${data['authenticated'] ?? false}');
        print('   Usuario ID: ${data['userId'] ?? 'N/A'}');
        break;
      case 'ping':
        // Mantener conexión viva - no hacer nada
        break;
      default:
        print('❓ Tipo de notificación desconocido: $type');
        print('   Datos completos: $data');
    }
  }

  /// Reconectar manualmente
  void reconnect() {
    if (_isAuthenticated) {
      _disconnect();
      Timer(Duration(milliseconds: 500), () {
        _connect();
      });
    }
  }

  /// Limpiar recursos
  void dispose() {
    _disconnect();
    _newMessageController.close();
    _newConversationController.close();
    _newCommentController.close();
    _connectionStatusController.close();
  }
}

// Provider global para SSE
final sseServiceProvider = Provider<SSEService>((ref) {
  final service = SSEService();
  ref.onDispose(() => service.dispose());
  return service;
});
