import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/story_entity.dart';

class StoriesApiService {
  final Dio _dio;

  StoriesApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  /// Obtener lista de stories
  Future<StoriesResponse> getStories({
    int limit = 20,
    int offset = 0,
    String status = 'created',
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/stories',
          queryParameters: {
            'limit': limit,
            'offset': offset,
            'status': status,
          },
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return StoriesResponse.fromApiJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló para stories: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error 404 o de conexión, devolver respuesta vacía
          if (e.response?.statusCode == 404 ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('API de stories no disponible después de $maxRetries intentos, devolviendo respuesta vacía');
            return StoriesResponse(
              stories: [],
              total: 0,
              limit: limit,
              offset: offset,
            );
          }
          throw Exception('Error al obtener stories después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener stories: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener stories');
  }

  /// Obtener stories por estado específico
  Future<StoriesResponse> getStoriesByStatus({
    required String status,
    int limit = 20,
    int offset = 0,
  }) async {
    return getStories(
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  /// Obtener stories publicadas
  Future<StoriesResponse> getPublishedStories({
    int limit = 20,
    int offset = 0,
  }) async {
    return getStoriesByStatus(
      status: 'published',
      limit: limit,
      offset: offset,
    );
  }

  /// Obtener stories pendientes
  Future<StoriesResponse> getPendingStories({
    int limit = 20,
    int offset = 0,
  }) async {
    return getStoriesByStatus(
      status: 'pending',
      limit: limit,
      offset: offset,
    );
  }

  /// Obtener stories fallidas
  Future<StoriesResponse> getFailedStories({
    int limit = 20,
    int offset = 0,
  }) async {
    return getStoriesByStatus(
      status: 'failed',
      limit: limit,
      offset: offset,
    );
  }
}
