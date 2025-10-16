import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/instagram_post_entity.dart';

class InstagramApiService {
  final Dio _dio;

  InstagramApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  /// Obtener lista de posts de Instagram
  Future<InstagramPostsResponse> getPosts({
    int page = 1,
    int limit = 20,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/instagram/posts',
          queryParameters: {
            'page': page,
            'limit': limit,
          },
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return InstagramPostsResponse.fromApiJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error 404 o de conexión, devolver respuesta vacía
          if (e.response?.statusCode == 404 ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('API no disponible después de $maxRetries intentos, devolviendo respuesta vacía');
            return InstagramPostsResponse(
              success: false,
              data: [],
              pagination: InstagramPagination(
                page: page,
                limit: limit,
                total: 0,
              ),
            );
          }
          throw Exception('Error al obtener posts después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener posts de Instagram: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener posts de Instagram');
  }

  /// Obtener post específico
  Future<InstagramPostEntity> getPost(String postId) async {
    try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/instagram/posts/$postId',
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

      return InstagramPostEntity.fromApiJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al obtener post: $e');
    }
  }

  /// Obtener comentarios de un post
  Future<InstagramCommentsResponse> getPostComments(
    String postId, {
    bool includeReplies = true,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/instagram/posts/$postId/comments',
          queryParameters: {
            'includeReplies': includeReplies,
          },
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return InstagramCommentsResponse.fromApiJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló para comentarios: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error 404 o de conexión, devolver respuesta vacía
          if (e.response?.statusCode == 404 ||
              e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('API de comentarios no disponible después de $maxRetries intentos, devolviendo respuesta vacía');
            return InstagramCommentsResponse(
              success: false,
              data: [],
              count: 0,
            );
          }
          throw Exception('Error al obtener comentarios después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener comentarios de Instagram: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener comentarios de Instagram');
  }

  /// Obtener estadísticas de un post
  Future<Map<String, dynamic>> getPostStats(String postId) async {
    try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/instagram/posts/$postId/stats',
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

      return response.data;
    } catch (e) {
      throw Exception('Error al obtener estadísticas del post: $e');
    }
  }

  /// Buscar posts
  Future<InstagramPostsResponse> searchPosts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
        final response = await _dio.get(
          '${ApiConfig.baseUrl}/instagram/posts/search',
          queryParameters: {
            'q': query,
            'page': page,
            'limit': limit,
          },
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

      return InstagramPostsResponse.fromApiJson(response.data);
    } catch (e) {
      throw Exception('Error al buscar posts: $e');
    }
  }
}
