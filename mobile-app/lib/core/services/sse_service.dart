import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class SSEService {
  http.Client? _client;
  StreamSubscription? _sseSubscription;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  bool _isAuthenticated = false;

  // Streams públicos
  final _newMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _newConversationController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get newMessageStream => _newMessageController.stream;
  Stream<Map<String, dynamic>> get newConversationStream => _newConversationController.stream;
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
      
      _sseSubscription = _client!.send(request).asStream().listen(
        (response) {
          if (response.statusCode == 200) {
            _isConnected = true;
            _connectionStatusController.add(true);
            print('✅ Conectado a SSE exitosamente');
            
            // Procesar stream de datos
            response.stream.listen(
              (chunk) {
                _processSSEChunk(chunk);
              },
              onError: (error) {
                print('❌ Error en stream SSE: $error');
                _handleConnectionError();
              },
              onDone: () {
                print('🔌 Conexión SSE cerrada');
                _handleConnectionError();
              },
            );
          } else {
            print('❌ Error HTTP en SSE: ${response.statusCode}');
            _handleConnectionError();
          }
        },
        onError: (error) {
          print('❌ Error al conectar SSE: $error');
          _handleConnectionError();
        },
      );
    } catch (e) {
      print('❌ Error al conectar SSE: $e');
      _handleConnectionError();
    }
  }

  /// Procesar chunk de datos SSE
  void _processSSEChunk(List<int> chunk) {
    try {
      final data = utf8.decode(chunk);
      final lines = data.split('\n');
      
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        
        if (line.startsWith('data: ')) {
          final jsonData = line.substring(6); // Remover 'data: '
          if (jsonData.trim().isNotEmpty) {
            try {
              final eventData = json.decode(jsonData);
              _processSSEMessage(eventData);
            } catch (e) {
              print('❌ Error al parsear JSON SSE: $e');
            }
          }
        }
      }
    } catch (e) {
      print('❌ Error al procesar chunk SSE: $e');
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
    _client?.close();
    _client = null;
    _reconnectTimer?.cancel();
    _isConnected = false;
    _connectionStatusController.add(false);
    print('❌ Desconectado de SSE');
  }

  /// Procesar mensajes SSE
  void _processSSEMessage(Map<String, dynamic> data) {
    final type = data['type'];
    final payload = data['data'];

    switch (type) {
      case 'new_message':
        if (payload != null) {
          _newMessageController.add(payload);
          print('📨 Nuevo mensaje recibido via SSE');
        }
        break;
      case 'new_conversation':
        if (payload != null) {
          _newConversationController.add(payload);
          print('💬 Nueva conversación recibida via SSE');
        }
        break;
      case 'connected':
        print('🔗 Conectado a notificaciones en tiempo real: ${data['message']}');
        break;
      case 'ping':
        // Mantener conexión viva
        break;
      default:
        print('❓ Tipo de notificación desconocido: $type');
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
    _connectionStatusController.close();
  }
}

// Provider global para SSE
final sseServiceProvider = Provider<SSEService>((ref) {
  final service = SSEService();
  ref.onDispose(() => service.dispose());
  return service;
});
