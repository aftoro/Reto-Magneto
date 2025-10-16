import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/preview_entity.dart';

class PreviewApiService {
  final Dio _dio = Dio();

  PreviewApiService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.headers = ApiConfig.defaultHeaders;
  }

  /// Crear preview de post
  Future<PreviewResponse> createPostPreview(CreatePreviewRequest request) async {
    try {
      // Preparar datos JSON para el backend
      final jsonData = {
        'topic': request.topic,
        'style': request.style,
        'target_audience': request.targetAudience,
      };

      // Si hay imagen de referencia, usar FormData
      if (request.referenceImage != null) {
        final formData = FormData();
        formData.fields.addAll([
          MapEntry('topic', request.topic),
          MapEntry('style', request.style),
          MapEntry('target_audience', request.targetAudience),
        ]);
        formData.files.add(MapEntry(
          'reference_image',
          await MultipartFile.fromFile(request.referenceImage!),
        ));
        
        final response = await _dio.post('/preview/post', data: formData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request);
      } else {
        // Sin imagen, enviar JSON puro
        final response = await _dio.post('/preview/post', data: jsonData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request);
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('General error: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  /// Crear preview de story
  Future<PreviewResponse> createStoryPreview(CreatePreviewRequest request) async {
    try {
      // Preparar datos JSON para el backend
      final jsonData = {
        'topic': request.topic,
        'style': request.style,
        'target_audience': request.targetAudience,
      };

      // Si hay imagen de referencia, usar FormData
      if (request.referenceImage != null) {
        final formData = FormData();
        formData.fields.addAll([
          MapEntry('topic', request.topic),
          MapEntry('style', request.style),
          MapEntry('target_audience', request.targetAudience),
        ]);
        formData.files.add(MapEntry(
          'reference_image',
          await MultipartFile.fromFile(request.referenceImage!),
        ));
        
        final response = await _dio.post('/preview/story', data: formData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request);
      } else {
        // Sin imagen, enviar JSON puro
        final response = await _dio.post('/preview/story', data: jsonData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request);
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('General error: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  /// Crear preview de reel
  Future<PreviewResponse> createReelPreview(CreateReelRequest request) async {
    try {
      // Preparar datos JSON para el backend con valores por defecto
      final jsonData = {
        'prompt': request.prompt,
        'accent': request.accent ?? 'neutral',
        'style': request.style ?? 'realista',
        'duration': request.duration ?? 8,
        'target_audience': request.targetAudience ?? 'desarrolladores y profesionales tech',
      };

      print('DEBUG: Creating reel with data: $jsonData');
      
      // Los reels no usan imagen de referencia, solo JSON
      final response = await _dio.post('/preview/reel', data: jsonData);
      print('Response data: ${response.data}');
      
      // Convertir CreateReelRequest a CreatePreviewRequest para compatibilidad
      final previewRequest = CreatePreviewRequest(
        topic: request.prompt,
        style: request.style ?? 'realista',
        targetAudience: request.targetAudience ?? 'desarrolladores y profesionales tech',
        referenceImage: null, // Los reels no usan imagen de referencia
      );
      
      return _convertBackendResponse(response.data, previewRequest);
    } on DioException catch (e) {
      print('DioException: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('General error: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  /// Aplicar correcciones a un preview
  Future<PreviewEntity> applyCorrections(
    String previewId,
    ApplyCorrectionsRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/preview/$previewId/corrections',
        data: request.toJson(),
      );
      
      print('DEBUG: Apply corrections response: ${response.data}');
      
      // Si la respuesta tiene un campo 'preview', usarlo
      if (response.data is Map<String, dynamic> && 
          response.data['preview'] != null) {
        return PreviewEntity.fromJson(response.data['preview']);
      }
      
      // Si no, usar la respuesta directamente
      return PreviewEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Publicar preview final
  Future<PreviewEntity> publishPreview(
    String previewId,
    PublishPreviewRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/preview/$previewId/publish',
        data: request.toJson(),
      );
      return PreviewEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener lista de previews
  Future<PreviewsResponse> getPreviews({
    String? status,
    String? type,
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };

      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _dio.get('/previews', queryParameters: queryParams);
      
      print('DEBUG: Get previews response: ${response.data}');
      
      // La API devuelve un formato específico, necesitamos convertirlo
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        
        // Si la respuesta tiene un campo 'previews', usarlo
        if (data['previews'] != null) {
          final previews = (data['previews'] as List).map((preview) {
            // Mapear los campos correctamente
            return PreviewEntity(
              id: preview['id'] ?? '',
              type: preview['type'] ?? 'post',
              topic: preview['topic'] ?? '',
              style: preview['style'] ?? '',
              targetAudience: preview['target_audience'] ?? '',
              referenceImage: preview['reference_image'],
              previewImage: preview['image_url'] ?? '',
              caption: preview['final_caption'] ?? preview['suggested_caption']?['captions']?[0]?['content'] ?? '',
              status: preview['status'] ?? 'draft',
              createdAt: DateTime.tryParse(preview['created_at'] ?? '') ?? DateTime.now(),
              updatedAt: DateTime.tryParse(preview['updated_at'] ?? ''),
              publishedAt: preview['published_at'] != null ? DateTime.tryParse(preview['published_at']) : null,
              corrections: null,
              views: preview['views'] ?? 0,
              likes: preview['likes'] ?? 0,
              comments: preview['comments'] ?? 0,
              metadata: {
                'improve_suggestions': preview['improve_suggestions'],
                'suggested_caption': preview['suggested_caption'],
              },
            );
          }).toList();
          
          return PreviewsResponse(
            previews: previews,
            total: data['pagination']?['total'] ?? previews.length,
            limit: data['pagination']?['limit'] ?? limit,
            offset: data['pagination']?['offset'] ?? offset,
            hasMore: (data['pagination']?['offset'] ?? offset) + previews.length < (data['pagination']?['total'] ?? previews.length),
          );
        }
      }
      
      // Fallback al parsing original
      return PreviewsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener preview específico
  Future<PreviewEntity> getPreview(String previewId) async {
    try {
      final response = await _dio.get('/preview/$previewId');
      return PreviewEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Eliminar preview
  Future<void> deletePreview(String previewId) async {
    try {
      await _dio.delete('/preview/$previewId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener correcciones de un preview
  Future<List<CorrectionEntity>> getPreviewCorrections(String previewId) async {
    try {
      final response = await _dio.get('/preview/$previewId/corrections');
      return (response.data as List)
          .map((json) => CorrectionEntity.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Aplicar corrección específica
  Future<PreviewEntity> applySpecificCorrection(
    String previewId,
    String correctionId,
  ) async {
    try {
      final response = await _dio.post(
        '/preview/$previewId/corrections/$correctionId/apply',
      );
      return PreviewEntity.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Rechazar corrección específica
  Future<void> rejectCorrection(
    String previewId,
    String correctionId,
  ) async {
    try {
      await _dio.post('/preview/$previewId/corrections/$correctionId/reject');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtener estadísticas de previews
  Future<Map<String, dynamic>> getPreviewStats() async {
    try {
      final response = await _dio.get('/previews/stats');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Convertir respuesta del backend al formato esperado
  PreviewResponse _convertBackendResponse(Map<String, dynamic> responseData, CreatePreviewRequest request) {
    try {
      final backendResponse = BackendPreviewResponse.fromJson(responseData);
      final backendPreview = backendResponse.preview;
      
      // Extract caption from the complex structure
      String caption = '';
      if (backendPreview.suggested_caption is Map<String, dynamic>) {
        final captionData = backendPreview.suggested_caption as Map<String, dynamic>;
        if (captionData['captions'] is List && (captionData['captions'] as List).isNotEmpty) {
          final firstCaption = (captionData['captions'] as List).first as Map<String, dynamic>;
          caption = firstCaption['content']?.toString() ?? '';
        }
      } else if (backendPreview.suggested_caption is String) {
        caption = backendPreview.suggested_caption as String;
      }
      
      // Extract improve_suggestions from backend response if available
      List<String> improveSuggestions = [];
      if (responseData['preview'] != null && 
          responseData['preview']['improve_suggestions'] != null) {
        final suggestions = responseData['preview']['improve_suggestions'] as List;
        improveSuggestions = suggestions.map((s) => s.toString()).toList();
      }

      // Extract suggested_caption structure from backend response
      Map<String, dynamic>? suggestedCaptionData;
      if (responseData['preview'] != null && 
          responseData['preview']['suggested_caption'] != null) {
        suggestedCaptionData = responseData['preview']['suggested_caption'] as Map<String, dynamic>;
      }

      // Crear PreviewEntity con los datos del backend
      final preview = PreviewEntity(
        id: backendPreview.id,
        type: backendPreview.type,
        topic: request.topic,
        style: request.style,
        targetAudience: request.targetAudience,
        referenceImage: request.referenceImage,
        previewImage: backendPreview.image_url,
        videoUrl: backendPreview.video_url, // For reels
        caption: caption,
        status: 'draft',
        createdAt: DateTime.now(),
        views: 0,
        likes: 0,
        comments: 0,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'backend_message': backendResponse.message,
          'improve_suggestions': improveSuggestions,
          'suggested_caption': suggestedCaptionData,
        },
      );

      // Generar correcciones sugeridas basadas en el contenido
      final suggestedCorrections = _generateSuggestedCorrections(request.topic, request.targetAudience);

      return PreviewResponse(
        preview: preview,
        suggestedCorrections: improveSuggestions.isNotEmpty ? improveSuggestions : suggestedCorrections,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'backend_message': backendResponse.message,
          'improve_suggestions': improveSuggestions,
          'suggested_caption': suggestedCaptionData,
        },
      );
    } catch (e) {
      print('Error converting backend response: $e');
      throw Exception('Error procesando respuesta del servidor: $e');
    }
  }

  /// Generar correcciones sugeridas
  List<String> _generateSuggestedCorrections(String topic, String targetAudience) {
    return [
      'Mejorar el contraste de colores para mayor legibilidad',
      'Agregar más información sobre beneficios salariales',
      'Incluir testimonios de profesionales exitosos',
      'Optimizar el texto para redes sociales',
      'Añadir call-to-action más persuasivo',
    ];
  }

  /// Error handling
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Error de conexión. Verifica tu internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        
        // Extraer mensaje específico del backend
        String message = 'Error del servidor';
        if (responseData is Map<String, dynamic>) {
          message = responseData['error'] ?? 
                   responseData['message'] ?? 
                   responseData['details'] ?? 
                   'Error del servidor';
        }
        
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Operación cancelada');
      case DioExceptionType.connectionError:
        return Exception('Sin conexión a internet');
      default:
        return Exception('Error inesperado: ${e.message}');
    }
  }

}
