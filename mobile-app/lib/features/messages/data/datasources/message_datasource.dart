import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/api_config.dart';
import '../models/message_model.dart';

class MessageService {
  final Dio _dio;

  MessageService({Dio? dio}) : _dio = dio ?? Dio();

  /// Obtener headers con autenticación
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    try {
      // Obtener sesión actual directamente
      final session = Supabase.instance.client.auth.currentSession;
      
      // Verificar y agregar token
      if (session != null && session.accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${session.accessToken}';
        print('🔐 [MessageService] Token de autenticación agregado a headers');
      } else {
        print('⚠️ [MessageService] No hay sesión de Supabase disponible');
      }
    } catch (e) {
      print('⚠️ [MessageService] Error al obtener token de Supabase: $e');
    }
    
    return headers;
  }

  Future<SendMessageResponse> sendMessage(MessageModel message) async {
    try {
      // Obtener headers con autenticación
      final headers = await _getAuthHeaders();

      // El backend espera conversationId y content, no recipient_id y message
      // Usar recipientId como conversationId si conversationId no está disponible
      final conversationId = message.conversationId ?? message.recipientId;
      if (conversationId == null) {
        return SendMessageResponse(
          success: false,
          error: 'Se requiere conversationId o recipientId',
        );
      }

      final requestData = {
        'conversationId': conversationId,
        'content': message.message,
        'messageType': 'outgoing', // Cambiar a 'outgoing' para que se envíe a Instagram
      };

      print('📤 [MessageService] Enviando mensaje:');
      print('   Conversation ID: ${requestData['conversationId']}');
      print('   Content: ${requestData['content']}');
      print('   Headers con auth: ${headers.containsKey('Authorization')}');

      final response = await _dio.post(
        ApiConfig.sendDm,
        data: requestData,
        options: Options(
          headers: headers,
        ),
      );

      print('✅ [MessageService] Respuesta recibida:');
      print('   Status Code: ${response.statusCode}');
      print('   Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // El backend devuelve { success: true, message: '...', data: {...} }
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          return SendMessageResponse(
            success: data['success'] ?? true,
            message: data['message'] ?? 'Mensaje enviado exitosamente',
            error: data['error'],
          );
        }
        return SendMessageResponse.fromJson(response.data);
      } else {
        return SendMessageResponse(
          success: false,
          error: 'Error del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ [MessageService] DioException:');
      print('   Tipo: ${e.type}');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Response Data: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      
      if (e.response?.statusCode == 401) {
        errorMessage = 'No autorizado. Por favor, inicia sesión nuevamente.';
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData['message'] != null) {
          errorMessage = errorData['message'];
        } else {
          errorMessage = 'Error en la solicitud: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Tiempo de espera agotado';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión a internet';
      } else if (e.response != null) {
        errorMessage = 'Error del servidor: ${e.response?.statusCode}';
      }

      return SendMessageResponse(
        success: false,
        error: errorMessage,
      );
    } catch (e) {
      print('❌ [MessageService] Error inesperado: $e');
      return SendMessageResponse(
        success: false,
        error: 'Error inesperado: $e',
      );
    }
  }
}
