import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/message_model.dart';

class MessageService {
  final Dio _dio;

  MessageService({Dio? dio}) : _dio = dio ?? Dio();

  Future<SendMessageResponse> sendMessage(MessageModel message) async {
    try {
      final request = SendMessageRequest(
        message: message.message,
        recipient_id: message.recipientId,
        sender_name: message.senderName,
      );

      final response = await _dio.post(
        ApiConfig.sendDm,
        data: request.toJson(),
        options: Options(
          headers: ApiConfig.defaultHeaders,
        ),
      );

      if (response.statusCode == 200) {
        return SendMessageResponse.fromJson(response.data);
      } else {
        return SendMessageResponse(
          success: false,
          error: 'Error del servidor: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Error de conexión';
      
      if (e.type == DioExceptionType.connectionTimeout ||
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
      return SendMessageResponse(
        success: false,
        error: 'Error inesperado: $e',
      );
    }
  }
}
