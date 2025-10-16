import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/post_model.dart';

class PostService {
  final Dio _dio;

  PostService({Dio? dio}) : _dio = dio ?? Dio();

  Future<CreatePostResponse> createPost(PostModel post) async {
    try {
      // Preparar datos para la nueva API
      final Map<String, dynamic> requestData = {
        'topic': post.topic,
        if (post.style != null) 'style': post.style,
        if (post.targetAudience != null) 'target_audience': post.targetAudience,
      };

      FormData formData;
      
      // Si hay imagen de referencia, usar FormData
      if (post.referenceImagePath != null) {
        formData = FormData.fromMap({
          ...requestData,
          'reference_image': await MultipartFile.fromFile(
            post.referenceImagePath!,
            filename: 'reference_image.jpg',
          ),
        });
      } else {
        // Si no hay imagen, usar JSON
        formData = FormData.fromMap(requestData);
      }

      final response = await _dio.post(
        ApiConfig.createPost,
        data: formData,
        options: Options(
          headers: {
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CreatePostResponse.fromJson(response.data);
      } else {
        return CreatePostResponse(
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

      return CreatePostResponse(
        success: false,
        error: errorMessage,
      );
    } catch (e) {
      return CreatePostResponse(
        success: false,
        error: 'Error inesperado: $e',
      );
    }
  }

  Future<CreateStoryResponse> createStory(StoryModel story) async {
    try {
      // Preparar datos para la nueva API
      final Map<String, dynamic> requestData = {
        'topic': story.topic,
        if (story.style != null) 'style': story.style,
        if (story.targetAudience != null) 'target_audience': story.targetAudience,
      };

      FormData formData;
      
      // Si hay imagen de referencia, usar FormData
      if (story.referenceImagePath != null) {
        formData = FormData.fromMap({
          ...requestData,
          'reference_image': await MultipartFile.fromFile(
            story.referenceImagePath!,
            filename: 'reference_image.jpg',
          ),
        });
      } else {
        // Si no hay imagen, usar JSON
        formData = FormData.fromMap(requestData);
      }

      final response = await _dio.post(
        ApiConfig.createStory,
        data: formData,
        options: Options(
          headers: {
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CreateStoryResponse.fromJson(response.data);
      } else {
        return CreateStoryResponse(
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

      return CreateStoryResponse(
        success: false,
        error: errorMessage,
      );
    } catch (e) {
      return CreateStoryResponse(
        success: false,
        error: 'Error inesperado: $e',
      );
    }
  }
}
