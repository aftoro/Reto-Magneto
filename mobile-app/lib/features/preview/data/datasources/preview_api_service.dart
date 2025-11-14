import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import '../../../../core/config/api_config.dart';
import '../models/preview_entity.dart';

class PreviewApiService {
  final Dio _dio = Dio();

  PreviewApiService() {
    // Los endpoints de preview están fuera de /api
    final urlWithoutApi = ApiConfig.baseUrl.replaceAll('/api', '');
    _dio.options.baseUrl = urlWithoutApi;
    _dio.options.headers = ApiConfig.defaultHeaders;
  }

  /// Obtener headers con autenticación
  Future<Map<String, String>> _getAuthHeaders({bool retry = false}) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    try {
      // Obtener sesión actual directamente
      var session = Supabase.instance.client.auth.currentSession;
      
      // Si no hay sesión o el token está vacío, intentar refrescar
      if ((session == null || session.accessToken.isEmpty) && !retry) {
        print('🔄 Token expirado o no disponible, intentando refrescar...');
        try {
          // Intentar refrescar la sesión
          final refreshedSession = await Supabase.instance.client.auth.refreshSession();
          session = refreshedSession.session;
          print('✅ Token refrescado exitosamente');
        } catch (refreshError) {
          print('⚠️ Error al refrescar token: $refreshError');
          // Si falla el refresh, verificar si hay sesión guardada
          session = Supabase.instance.client.auth.currentSession;
        }
      }
      
      // Verificar y agregar token
      if (session != null && session.accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${session.accessToken}';
        print('🔐 Token de autenticación agregado a headers (${session.user.email ?? session.user.id})');
      } else {
        print('⚠️ No hay sesión de Supabase disponible para preview');
      }
    } catch (e) {
      print('⚠️ Error al obtener token de Supabase: $e');
    }
    
    return headers;
  }

  /// Crear preview de post
  Future<PreviewResponse> createPostPreview(CreatePreviewRequest request) async {
    try {
      // Preparar datos JSON para el backend
      final jsonData = {
        'type': 'post', // Especificar tipo para el backend
        'prompt': request.topic, // El backend espera 'prompt' no 'topic'
        'style': request.style,
        'target_audience': request.targetAudience,
      };

      // Si hay imagen de referencia, usar FormData
      if (request.referenceImage != null) {
        final formData = FormData();
        formData.fields.addAll([
          MapEntry('type', 'post'),
          MapEntry('prompt', request.topic),
          MapEntry('style', request.style),
          MapEntry('target_audience', request.targetAudience),
        ]);
        formData.files.add(MapEntry(
          'reference_image',
          await MultipartFile.fromFile(request.referenceImage!),
        ));
        
        final response = await _dio.post('/generate/preview', data: formData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request, type: 'post');
      } else {
        // Sin imagen, enviar JSON puro
        final response = await _dio.post('/generate/preview', data: jsonData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request, type: 'post');
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
        'type': 'story', // Especificar tipo para el backend
        'prompt': request.topic, // El backend espera 'prompt' no 'topic'
        'style': request.style,
        'target_audience': request.targetAudience,
      };

      // Si hay imagen de referencia, usar FormData
      if (request.referenceImage != null) {
        final formData = FormData();
        formData.fields.addAll([
          MapEntry('type', 'story'),
          MapEntry('prompt', request.topic),
          MapEntry('style', request.style),
          MapEntry('target_audience', request.targetAudience),
        ]);
        formData.files.add(MapEntry(
          'reference_image',
          await MultipartFile.fromFile(request.referenceImage!),
        ));
        
        final response = await _dio.post('/generate/preview', data: formData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request, type: 'story');
      } else {
        // Sin imagen, enviar JSON puro
        final response = await _dio.post('/generate/preview', data: jsonData);
        print('Response data: ${response.data}');
        return _convertBackendResponse(response.data, request, type: 'story');
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
        'type': 'reel', // Especificar tipo explícitamente
        'prompt': request.prompt, // Backend acepta 'prompt' o 'topic'
        'topic': request.prompt, // También enviar como 'topic' para consistencia
        'accent': request.accent ?? 'neutral',
        'style': request.style ?? 'realista',
        'duration': request.duration ?? 8,
        'target_audience': request.targetAudience ?? 'desarrolladores y profesionales tech',
      };

      print('DEBUG: Creating reel with data: $jsonData');
      
      final response = await _dio.post('/generate/preview', data: jsonData);
      print('Response data: ${response.data}');
      
      // Convertir CreateReelRequest a CreatePreviewRequest para compatibilidad
      final previewRequest = CreatePreviewRequest(
        topic: request.prompt,
        style: request.style ?? 'realista',
        targetAudience: request.targetAudience ?? 'desarrolladores y profesionales tech',
        referenceImage: null, // Los reels no usan imagen de referencia
      );
      
      // Verificar si el backend devolvió status "generating" (reel en background)
      if (response.data['data'] != null && 
          response.data['data']['status'] == 'generating') {
        // El reel se está generando pero aún no hay previewId
        // Crear un preview temporal sin ID real (se creará cuando esté listo)
        final tempPreview = PreviewEntity(
          id: 'temp-${DateTime.now().millisecondsSinceEpoch}', // ID temporal
          type: 'reel',
          topic: request.prompt,
          style: request.style ?? 'realista',
          targetAudience: request.targetAudience ?? 'desarrolladores y profesionales tech',
          previewImage: '', // Sin imagen todavía
          caption: 'Generando reel...',
          status: 'generating',
          createdAt: DateTime.now(),
        );
        
        return PreviewResponse(
          preview: tempPreview,
          suggestedCorrections: [],
          metadata: {
            'isGenerating': true, 
            'topic': request.prompt, // Guardar el tema para buscar después
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
      }
      
      // Pasar el tipo explícitamente como 'reel' para la conversión
      return _convertBackendResponse(response.data, previewRequest, type: 'reel');
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
      // El endpoint de publicación está en /api/preview/:id/publish
      // Usar baseUrl que ya incluye /api y construir la ruta correctamente
      final dioWithApi = Dio();
      dioWithApi.options.baseUrl = ApiConfig.baseUrl;
      
      // Obtener headers con autenticación
      var headers = await _getAuthHeaders();
      
      // Construir la URL completa para logging
      final fullUrl = '${ApiConfig.baseUrl}/preview/$previewId/publish';
      print('📤 [PreviewApiService] Publicando preview $previewId');
      print('   🔗 URL: $fullUrl');
      print('   🔐 Headers con auth: ${headers.containsKey('Authorization')}');
      
      // La ruta debe empezar con / para que Dio la concatene correctamente al baseUrl
      try {
        final response = await dioWithApi.post(
          '/preview/$previewId/publish',
          data: request.toJson(),
          options: Options(
            headers: headers,
          ),
        );
        
        print('✅ [PreviewApiService] Preview publicado exitosamente');
        
        // Mapear la respuesta del backend (snake_case) al formato esperado por PreviewEntity (camelCase)
        final backendData = response.data as Map<String, dynamic>;
        final mappedData = {
          'id': backendData['id'] ?? '',
          'type': backendData['type'] ?? 'post',
          'topic': backendData['topic'] ?? '',
          'style': backendData['style'] ?? '',
          'targetAudience': backendData['target_audience'] ?? '',
          'referenceImage': backendData['reference_image'],
          'previewImage': backendData['image_url'] ?? '', // Usar solo image_url (para todos los tipos)
          'videoUrl': null, // Ya no se usa video_url en la tabla
          'caption': backendData['final_caption'] ?? backendData['suggested_caption']?['captions']?[0]?['content'] ?? '',
          'status': backendData['status'] ?? 'published',
          'createdAt': backendData['created_at'] ?? DateTime.now().toIso8601String(),
          'updatedAt': backendData['updated_at'],
          'publishedAt': backendData['published_at'],
          'corrections': null,
          'views': backendData['views'] ?? 0,
          'likes': backendData['likes'] ?? 0,
          'comments': backendData['comments'] ?? 0,
          'metadata': {
            'improve_suggestions': backendData['improve_suggestions'],
            'suggested_caption': backendData['suggested_caption'],
          },
        };
        
        return PreviewEntity.fromJson(mappedData);
      } on DioException catch (e) {
        // Si es un error 401, intentar refrescar el token y reintentar una vez
        if (e.response?.statusCode == 401) {
          print('🔄 Error 401 detectado, intentando refrescar token y reintentar...');
          try {
            // Refrescar el token
            headers = await _getAuthHeaders(retry: true);
            
            // Reintentar la petición con el nuevo token
            final response = await dioWithApi.post(
              '/preview/$previewId/publish',
              data: request.toJson(),
              options: Options(
                headers: headers,
              ),
            );
            
            print('✅ [PreviewApiService] Preview publicado exitosamente después de refrescar token');
            
            // Mapear la respuesta del backend (snake_case) al formato esperado por PreviewEntity (camelCase)
            final backendData = response.data as Map<String, dynamic>;
            final mappedData = {
              'id': backendData['id'] ?? '',
              'type': backendData['type'] ?? 'post',
              'topic': backendData['topic'] ?? '',
              'style': backendData['style'] ?? '',
              'targetAudience': backendData['target_audience'] ?? '',
              'referenceImage': backendData['reference_image'],
              'previewImage': backendData['image_url'] ?? '', // Usar solo image_url (para todos los tipos)
              'videoUrl': null, // Ya no se usa video_url en la tabla
              'caption': backendData['final_caption'] ?? backendData['suggested_caption']?['captions']?[0]?['content'] ?? '',
              'status': backendData['status'] ?? 'published',
              'createdAt': backendData['created_at'] ?? DateTime.now().toIso8601String(),
              'updatedAt': backendData['updated_at'],
              'publishedAt': backendData['published_at'],
              'corrections': null,
              'views': backendData['views'] ?? 0,
              'likes': backendData['likes'] ?? 0,
              'comments': backendData['comments'] ?? 0,
              'metadata': {
                'improve_suggestions': backendData['improve_suggestions'],
                'suggested_caption': backendData['suggested_caption'],
              },
            };
            
            return PreviewEntity.fromJson(mappedData);
          } catch (retryError) {
            print('❌ Error al reintentar después de refrescar token: $retryError');
            throw _handleError(e);
          }
        } else {
          throw _handleError(e);
        }
      }
    } on DioException catch (e) {
      print('❌ [PreviewApiService] Error publicando preview: ${e.response?.statusCode}');
      print('   Mensaje: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('❌ Error inesperado al publicar preview: $e');
      throw Exception('Error al publicar preview: $e');
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
            final type = preview['type'] ?? 'post';
            final imageUrl = preview['image_url'] ?? '';
            
            // Usar image_url para todos los tipos (imagen o video)
            final previewImage = imageUrl.isNotEmpty ? imageUrl : '';
            
            return PreviewEntity(
              id: preview['id'] ?? '',
              type: type,
              topic: preview['topic'] ?? '',
              style: preview['style'] ?? '',
              targetAudience: preview['target_audience'] ?? '',
              referenceImage: preview['reference_image'],
              previewImage: previewImage,
              videoUrl: null, // Ya no se usa video_url en la tabla
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
      // El endpoint está en /api/preview/:id, usar ApiConfig.baseUrl directamente
      final dioWithApi = Dio();
      dioWithApi.options.baseUrl = ApiConfig.baseUrl;
      dioWithApi.options.headers = ApiConfig.defaultHeaders;
      
      // Obtener headers con autenticación
      var headers = await _getAuthHeaders();
      
      try {
        final response = await dioWithApi.get(
          '/preview/$previewId',
          options: Options(headers: headers),
        );
        
        // Mapear la respuesta del backend (snake_case) al formato esperado por PreviewEntity (camelCase)
        final backendData = response.data is Map<String, dynamic> 
            ? (response.data['preview'] ?? response.data)
            : response.data as Map<String, dynamic>;
        
        final mappedData = {
          'id': backendData['id']?.toString() ?? '',
          'type': backendData['type']?.toString() ?? 'post',
          'topic': backendData['topic']?.toString() ?? '',
          'style': backendData['style']?.toString() ?? '',
          'targetAudience': backendData['target_audience']?.toString() ?? '',
          'referenceImage': backendData['reference_image']?.toString(),
          'previewImage': backendData['image_url']?.toString() ?? '', // Usar solo image_url
          'videoUrl': null, // Ya no se usa video_url en la tabla
          'caption': backendData['final_caption']?.toString() ?? 
                     backendData['suggested_caption']?['captions']?[0]?['content']?.toString() ?? '',
          'status': backendData['status']?.toString() ?? 'draft',
          'createdAt': backendData['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          'updatedAt': backendData['updated_at']?.toString(),
          'publishedAt': backendData['published_at']?.toString(),
          'corrections': null,
          'views': backendData['views'] ?? 0,
          'likes': backendData['likes'] ?? 0,
          'comments': backendData['comments'] ?? 0,
          'metadata': {
            'improve_suggestions': backendData['improve_suggestions'],
            'suggested_caption': backendData['suggested_caption'],
          },
        };
        
        return PreviewEntity.fromJson(mappedData);
      } on DioException catch (e) {
        // Si es un error 401, intentar refrescar el token y reintentar una vez
        if (e.response?.statusCode == 401) {
          print('🔄 Error 401 al obtener preview, intentando refrescar token y reintentar...');
          try {
            // Refrescar el token
            headers = await _getAuthHeaders(retry: true);
            
            // Reintentar la petición con el nuevo token
            final response = await dioWithApi.get(
              '/preview/$previewId',
              options: Options(headers: headers),
            );
            
            // Mapear la respuesta del backend (snake_case) al formato esperado por PreviewEntity (camelCase)
            final backendData = response.data is Map<String, dynamic> 
                ? (response.data['preview'] ?? response.data)
                : response.data as Map<String, dynamic>;
            
            final mappedData = {
              'id': backendData['id']?.toString() ?? '',
              'type': backendData['type']?.toString() ?? 'post',
              'topic': backendData['topic']?.toString() ?? '',
              'style': backendData['style']?.toString() ?? '',
              'targetAudience': backendData['target_audience']?.toString() ?? '',
              'referenceImage': backendData['reference_image']?.toString(),
              'previewImage': backendData['image_url']?.toString() ?? '', // Usar solo image_url
              'videoUrl': null, // Ya no se usa video_url en la tabla
              'caption': backendData['final_caption']?.toString() ?? 
                         backendData['suggested_caption']?['captions']?[0]?['content']?.toString() ?? '',
              'status': backendData['status']?.toString() ?? 'draft',
              'createdAt': backendData['created_at']?.toString() ?? DateTime.now().toIso8601String(),
              'updatedAt': backendData['updated_at']?.toString(),
              'publishedAt': backendData['published_at']?.toString(),
              'corrections': null,
              'views': backendData['views'] ?? 0,
              'likes': backendData['likes'] ?? 0,
              'comments': backendData['comments'] ?? 0,
              'metadata': {
                'improve_suggestions': backendData['improve_suggestions'],
                'suggested_caption': backendData['suggested_caption'],
              },
            };
            
            return PreviewEntity.fromJson(mappedData);
          } catch (retryError) {
            print('❌ Error al reintentar después de refrescar token: $retryError');
            throw _handleError(e);
          }
        } else {
          throw _handleError(e);
        }
      }
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      print('❌ Error inesperado al obtener preview: $e');
      throw Exception('Error al obtener preview: $e');
    }
  }

  /// Verificar estado de un preview (para polling de reels en background)
  Future<Map<String, dynamic>> getPreviewStatus(String previewId) async {
    try {
      // El endpoint de status está en /api, usar ApiConfig.baseUrl directamente
      final dioWithApi = Dio();
      dioWithApi.options.baseUrl = ApiConfig.baseUrl;
      dioWithApi.options.headers = ApiConfig.defaultHeaders;
      
      // Obtener headers con autenticación
      final headers = await _getAuthHeaders();
      
      final response = await dioWithApi.get(
        '/preview/$previewId/status',
        options: Options(headers: headers),
      );
      return response.data;
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
  PreviewResponse _convertBackendResponse(
    Map<String, dynamic> responseData, 
    CreatePreviewRequest request, {
    String? type, // Tipo explícito (reel, post, story)
  }) {
    try {
      // El backend ahora devuelve: { success: true, data: { mediaUrl, captionOptions, improveSuggestions } }
      final data = responseData['data'] as Map<String, dynamic>?;
      
      if (data == null) {
        throw Exception('Respuesta del servidor sin campo "data"');
      }

      // Extraer mediaUrl (usar image_url para todos los tipos)
      final mediaUrl = data['mediaUrl'] as String? ?? '';
      
      // Determinar el tipo: usar el tipo explícito si está disponible, sino 'post'
      final finalType = type ?? 'post';
      
      // Extraer captionOptions (solo para posts y reels, no para stories)
      String caption = '';
      Map<String, dynamic>? suggestedCaptionData;
      if (finalType != 'story') {
        final captionOptions = data['captionOptions'] as Map<String, dynamic>?;
        if (captionOptions != null && captionOptions['captions'] is List) {
          final captions = captionOptions['captions'] as List;
          if (captions.isNotEmpty) {
            final firstCaption = captions.first as Map<String, dynamic>;
            caption = firstCaption['content']?.toString() ?? '';
          }
          suggestedCaptionData = captionOptions;
        }
      }
      
      // Si no hay caption de captionOptions, usar string vacío
      if (caption.isEmpty) {
        caption = '';
      }
      
      // Extraer improveSuggestions
      List<String> improveSuggestions = [];
      final suggestions = data['improveSuggestions'];
      if (suggestions is List) {
        improveSuggestions = suggestions.map((s) => s?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      } else if (suggestions is String) {
        improveSuggestions = [suggestions];
      }

      // Extraer previewId del backend
      // El backend devuelve: { success: true, data: { previewId: ..., id: ..., mediaUrl: ... } }
      // Nota: 'data' ya es el objeto interno extraído en la línea 570
      final previewId = data['previewId'] as String? ?? 
                       data['id'] as String? ?? 
                       DateTime.now().millisecondsSinceEpoch.toString();
      
      print('🔍 [PreviewApiService] PreviewId extraído: $previewId');
      print('   De data[previewId]: ${data['previewId']}');
      print('   De data[id]: ${data['id']}');
      print('   Tipo de preview: $finalType');

      // Crear PreviewEntity con los datos del backend
      final preview = PreviewEntity(
        id: previewId,
        type: finalType,
        topic: request.topic,
        style: request.style,
        targetAudience: request.targetAudience,
        referenceImage: request.referenceImage,
        previewImage: mediaUrl.isNotEmpty ? mediaUrl : '',
        videoUrl: null, // Ya no se usa video_url en la tabla
        caption: caption,
        status: 'draft',
        createdAt: DateTime.now(),
        views: 0,
        likes: 0,
        comments: 0,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'improve_suggestions': improveSuggestions,
          'suggested_caption': suggestedCaptionData,
          'media_url': mediaUrl,
        },
      );

      // Generar correcciones sugeridas basadas en el contenido si no hay sugerencias del backend
      final suggestedCorrections = improveSuggestions.isNotEmpty 
          ? improveSuggestions 
          : _generateSuggestedCorrections(request.topic, request.targetAudience);

      return PreviewResponse(
        preview: preview,
        suggestedCorrections: suggestedCorrections,
        metadata: {
          'generated_at': DateTime.now().toIso8601String(),
          'improve_suggestions': improveSuggestions,
          'suggested_caption': suggestedCaptionData,
          'media_url': mediaUrl,
        },
      );
    } catch (e, stackTrace) {
      print('Error converting backend response: $e');
      print('Stack trace: $stackTrace');
      print('Response data: $responseData');
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
