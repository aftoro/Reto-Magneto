import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/preview_api_service.dart';
import '../../data/datasources/preview_stream_service.dart';
import '../../data/models/preview_entity.dart';

// API Service Provider
final previewApiServiceProvider = Provider<PreviewApiService>((ref) {
  return PreviewApiService();
});

// Estados para Preview Creation
abstract class PreviewCreationState {
  const PreviewCreationState();
}

class PreviewCreationInitial extends PreviewCreationState {
  const PreviewCreationInitial();
}

class PreviewCreationLoading extends PreviewCreationState {
  const PreviewCreationLoading();
}

class PreviewCreationSuccess extends PreviewCreationState {
  final PreviewResponse response;
  const PreviewCreationSuccess(this.response);
}

class PreviewCreationError extends PreviewCreationState {
  final String message;
  const PreviewCreationError(this.message);
}

class PreviewCreationStreaming extends PreviewCreationState {
  final String? statusMessage;
  final Map<String, dynamic>? captionOptions;
  final String? mediaUrl;
  final String? videoUrl;
  final List<String>? improveSuggestions;
  final String? previewId; // ID del preview guardado en la BD
  
  const PreviewCreationStreaming({
    this.statusMessage,
    this.captionOptions,
    this.mediaUrl,
    this.videoUrl,
    this.improveSuggestions,
    this.previewId,
  });
  
  PreviewCreationStreaming copyWith({
    String? statusMessage,
    Map<String, dynamic>? captionOptions,
    String? mediaUrl,
    String? videoUrl,
    List<String>? improveSuggestions,
    String? previewId,
  }) {
    return PreviewCreationStreaming(
      statusMessage: statusMessage ?? this.statusMessage,
      captionOptions: captionOptions ?? this.captionOptions,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      improveSuggestions: improveSuggestions ?? this.improveSuggestions,
      previewId: previewId ?? this.previewId,
    );
  }
}

// Estados para Previews List
abstract class PreviewsListState {
  const PreviewsListState();
}

class PreviewsListInitial extends PreviewsListState {
  const PreviewsListInitial();
}

class PreviewsListLoading extends PreviewsListState {
  const PreviewsListLoading();
}

class PreviewsListLoaded extends PreviewsListState {
  final PreviewsResponse response;
  const PreviewsListLoaded(this.response);
}

class PreviewsListError extends PreviewsListState {
  final String message;
  const PreviewsListError(this.message);
}

// Estados para Preview Details
abstract class PreviewDetailsState {
  const PreviewDetailsState();
}

class PreviewDetailsInitial extends PreviewDetailsState {
  const PreviewDetailsInitial();
}

class PreviewDetailsLoading extends PreviewDetailsState {
  const PreviewDetailsLoading();
}

class PreviewDetailsLoaded extends PreviewDetailsState {
  final PreviewEntity preview;
  const PreviewDetailsLoaded(this.preview);
}

class PreviewDetailsError extends PreviewDetailsState {
  final String message;
  const PreviewDetailsError(this.message);
}

// Estados para Corrections
abstract class CorrectionsState {
  const CorrectionsState();
}

class CorrectionsInitial extends CorrectionsState {
  const CorrectionsInitial();
}

class CorrectionsLoading extends CorrectionsState {
  const CorrectionsLoading();
}

class CorrectionsLoaded extends CorrectionsState {
  final List<CorrectionEntity> corrections;
  const CorrectionsLoaded(this.corrections);
}

class CorrectionsError extends CorrectionsState {
  final String message;
  const CorrectionsError(this.message);
}

// Notifier para creación de previews
class PreviewCreationNotifier extends StateNotifier<PreviewCreationState> {
  final PreviewApiService _apiService;
  final PreviewStreamService _streamService = PreviewStreamService();
  StreamSubscription? _streamSubscription;

  PreviewCreationNotifier(this._apiService) : super(const PreviewCreationInitial());
  
  Timer? _pollingTimer;
  
  @override
  void dispose() {
    _streamSubscription?.cancel();
    _pollingTimer?.cancel();
    _streamService.cancel();
    super.dispose();
  }

  int _pollingAttempts = 0;
  
  /// Buscar preview de reel por tema y fecha cuando esté listo
  void _startSearchingReelPreview(String topic, String? createdAt) {
    _pollingTimer?.cancel();
    _pollingAttempts = 0;
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      _pollingAttempts++;
      try {
        // Buscar previews recientes de tipo reel con el mismo tema
        final previewsResponse = await _apiService.getPreviews(
          type: 'reel',
          limit: 5,
        );
        
        // Buscar el preview que coincida con el tema y sea reciente
        PreviewEntity? matchingPreview;
        try {
          matchingPreview = previewsResponse.previews.firstWhere(
            (p) => p.topic.toLowerCase().contains(topic.toLowerCase()) &&
                   p.status == 'draft' &&
                   p.createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 1))),
          );
        } catch (e) {
          // No se encontró preview que coincida
          matchingPreview = null;
        }
        
        // Calcular porcentaje aproximado (máximo 90% hasta que esté listo)
        final progress = (_pollingAttempts * 5).clamp(0, 90);
        final statusMessage = 'Generando reel... $progress%';
        
        // Actualizar estado con progreso
        if (state is PreviewCreationStreaming) {
          state = (state as PreviewCreationStreaming).copyWith(
            statusMessage: statusMessage,
          );
        }
        
        if (matchingPreview != null) {
          // Reel está listo
          timer.cancel();
          _pollingTimer = null;
          _pollingAttempts = 0;
          
          print('✅ Reel encontrado! Preview ID: ${matchingPreview.id}');
          
          // Actualizar estado con 100%
          if (state is PreviewCreationStreaming) {
            state = (state as PreviewCreationStreaming).copyWith(
              statusMessage: 'Generando reel... 100%',
            );
          }
          
          // Cargar el preview completo
          try {
            final preview = await _apiService.getPreview(matchingPreview.id);
            state = PreviewCreationSuccess(
              PreviewResponse(
                preview: preview,
                suggestedCorrections: [],
                metadata: {},
              ),
            );
          } catch (e) {
            print('⚠️ Error cargando preview completo: $e');
          }
        } else if (_pollingAttempts > 60) {
          // Timeout después de 10 minutos (60 intentos * 10 segundos)
          timer.cancel();
          _pollingTimer = null;
          _pollingAttempts = 0;
          state = PreviewCreationError('Tiempo de espera agotado. El reel puede estar aún generándose.');
        }
        // Continuar buscando si no se encontró
      } catch (e) {
        print('⚠️ Error buscando preview de reel: $e');
        // Continuar buscando aunque haya error temporal
      }
    });
  }
  
  /// Iniciar polling para verificar estado de reel en background (cuando hay previewId)
  void _startPollingReelStatus(String previewId) {
    _pollingTimer?.cancel();
    _pollingAttempts = 0;
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _pollingAttempts++;
      try {
        final statusData = await _apiService.getPreviewStatus(previewId);
        final status = statusData['preview']?['status'] as String?;
        
        // Calcular porcentaje aproximado (máximo 90% hasta que esté listo)
        final progress = (_pollingAttempts * 5).clamp(0, 90);
        final statusMessage = 'Generando reel... $progress%';
        
        // Actualizar estado con progreso
        if (state is PreviewCreationStreaming) {
          state = (state as PreviewCreationStreaming).copyWith(
            statusMessage: statusMessage,
          );
        }
        
        if (status == 'draft') {
          // Reel está listo
          timer.cancel();
          _pollingTimer = null;
          _pollingAttempts = 0;
          
          print('✅ Reel listo! Preview ID: $previewId');
          
          // Actualizar estado con 100%
          if (state is PreviewCreationStreaming) {
            state = (state as PreviewCreationStreaming).copyWith(
              statusMessage: 'Generando reel... 100%',
            );
          }
          
          // Cargar el preview completo
          try {
            final preview = await _apiService.getPreview(previewId);
            state = PreviewCreationSuccess(
              PreviewResponse(
                preview: preview,
                suggestedCorrections: [],
                metadata: {},
              ),
            );
          } catch (e) {
            print('⚠️ Error cargando preview completo: $e');
          }
        } else if (status == 'error') {
          // Error en la generación
          timer.cancel();
          _pollingTimer = null;
          _pollingAttempts = 0;
          state = PreviewCreationError('Error generando el reel');
        }
        // Si status es 'generating', continuar polling
      } catch (e) {
        print('⚠️ Error verificando estado del reel: $e');
        // Continuar polling aunque haya error temporal
      }
    });
  }

  Future<void> createPostPreview(CreatePreviewRequest request) async {
    state = const PreviewCreationLoading();
    try {
      final response = await _apiService.createPostPreview(request);
      state = PreviewCreationSuccess(response);
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  Future<void> createStoryPreview(CreatePreviewRequest request) async {
    state = const PreviewCreationLoading();
    try {
      final response = await _apiService.createStoryPreview(request);
      state = PreviewCreationSuccess(response);
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  Future<void> createReelPreview(CreateReelRequest request) async {
    state = const PreviewCreationLoading();
    try {
      final response = await _apiService.createReelPreview(request);
      
      // Verificar si el reel está generándose en background
      if (response.metadata != null && 
          response.metadata!['isGenerating'] == true) {
        // El reel se está generando pero aún no hay previewId
        final topic = response.metadata!['topic'] as String? ?? request.prompt;
        
        // Iniciar monitoreo global del reel (se maneja en MainAppPage)
        // Nota: Necesitamos acceso al ref, pero StateNotifier no lo tiene directamente
        // El monitoreo se iniciará desde preview_creation_page usando el ref
        
        // Cambiar a estado streaming sin previewId
        state = PreviewCreationStreaming(
          statusMessage: 'Generando reel...',
          previewId: null, // No hay previewId todavía
        );
        
        // Iniciar búsqueda periódica del preview cuando esté listo
        _startSearchingReelPreview(topic, response.metadata!['createdAt'] as String?);
      } else {
        state = PreviewCreationSuccess(response);
      }
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  /// Crear preview con streaming (progresivo)
  Future<void> createPostPreviewStream(CreatePreviewRequest request) async {
    _streamSubscription?.cancel();
    state = const PreviewCreationStreaming();
    
    try {
      final stream = _streamService.createPreviewStream(
        type: 'post',
        topic: request.topic,
        style: request.style,
        targetAudience: request.targetAudience,
        referenceImagePath: request.referenceImage,
      );
      
      await _processStream(stream, request, 'post');
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  Future<void> createStoryPreviewStream(CreatePreviewRequest request) async {
    _streamSubscription?.cancel();
    state = const PreviewCreationStreaming();
    
    try {
      final stream = _streamService.createPreviewStream(
        type: 'story',
        topic: request.topic,
        style: request.style,
        targetAudience: request.targetAudience,
        referenceImagePath: request.referenceImage,
      );
      
      await _processStream(stream, request, 'story');
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  Future<void> createReelPreviewStream(CreateReelRequest request) async {
    _streamSubscription?.cancel();
    state = const PreviewCreationStreaming();
    
    try {
      final stream = _streamService.createPreviewStream(
        type: 'reel',
        topic: request.prompt,
        style: request.style,
        targetAudience: request.targetAudience,
        accent: request.accent,
        duration: request.duration,
      );
      
      // Convertir CreateReelRequest a CreatePreviewRequest para compatibilidad
      final previewRequest = CreatePreviewRequest(
        topic: request.prompt,
        style: request.style ?? 'realista',
        targetAudience: request.targetAudience ?? 'desarrolladores y profesionales tech',
        referenceImage: null,
      );
      
      await _processStream(stream, previewRequest, 'reel');
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  Future<void> _processStream(
    Stream<PreviewStreamData> stream,
    CreatePreviewRequest request,
    String type,
  ) async {
    var streamingState = const PreviewCreationStreaming();
    
    _streamSubscription = stream.listen(
      (streamData) {
        switch (streamData.event) {
          case PreviewStreamEvent.start:
            streamingState = const PreviewCreationStreaming();
            state = streamingState;
            break;
            
          case PreviewStreamEvent.captions:
            final captionOptions = streamData.data['captionOptions'] as Map<String, dynamic>?;
            streamingState = streamingState.copyWith(captionOptions: captionOptions);
            state = streamingState;
            break;
            
          case PreviewStreamEvent.media:
            final mediaUrl = streamData.data['mediaUrl'] as String?;
            final videoUrl = streamData.data['videoUrl'] as String?;
            streamingState = streamingState.copyWith(
              mediaUrl: mediaUrl,
              videoUrl: videoUrl,
            );
            state = streamingState;
            break;
            
          case PreviewStreamEvent.suggestions:
            final suggestions = streamData.data['improveSuggestions'] as List<dynamic>?;
            final improveSuggestions = suggestions?.map((s) => s.toString()).toList();
            streamingState = streamingState.copyWith(improveSuggestions: improveSuggestions);
            state = streamingState;
            break;
            
          case PreviewStreamEvent.status:
            final message = streamData.data['message'] as String?;
            streamingState = streamingState.copyWith(statusMessage: message);
            state = streamingState;
            break;
            
          case PreviewStreamEvent.preview_saved:
            final previewId = streamData.data['previewId'] as String?;
            streamingState = streamingState.copyWith(previewId: previewId);
            state = streamingState;
            print('✅ Preview guardado con ID: $previewId');
            
            // Si ya tenemos todos los datos necesarios, convertir a respuesta completa
            // Esto asegura que el previewId se use correctamente
            if (streamingState.mediaUrl != null || streamingState.videoUrl != null) {
              final response = _convertStreamingToResponse(streamingState, request, type);
              state = PreviewCreationSuccess(response);
            }
            break;
            
          case PreviewStreamEvent.preview_created:
            // Para reels: el preview se creó y está generándose en background
            final previewId = streamData.data['previewId'] as String?;
            streamingState = streamingState.copyWith(previewId: previewId);
            state = streamingState;
            print('✅ Preview creado para reel (generando en background): $previewId');
            // Iniciar polling para verificar cuando esté listo
            if (previewId != null) {
              _startPollingReelStatus(previewId);
            }
            break;
            
          case PreviewStreamEvent.done:
            // Convertir estado de streaming a respuesta completa
            // Si el previewId ya está disponible (de preview_saved), se usará
            // Solo convertir si aún no se ha convertido (evitar sobrescribir si preview_saved ya lo hizo)
            if (state is PreviewCreationStreaming) {
              final response = _convertStreamingToResponse(streamingState, request, type);
              state = PreviewCreationSuccess(response);
            }
            break;
            
          case PreviewStreamEvent.error:
            final message = streamData.data['message'] as String? ?? 'Error desconocido';
            state = PreviewCreationError(message);
            break;
        }
      },
      onError: (error) {
        state = PreviewCreationError(error.toString());
      },
    );
  }

  PreviewResponse _convertStreamingToResponse(
    PreviewCreationStreaming streamingState,
    CreatePreviewRequest request,
    String type,
  ) {
    // Extraer caption del captionOptions (solo para posts y reels, no para stories)
    String caption = '';
    Map<String, dynamic>? suggestedCaptionData;
    if (type != 'story' && streamingState.captionOptions != null) {
      final captions = streamingState.captionOptions!['captions'] as List?;
      if (captions != null && captions.isNotEmpty) {
        final firstCaption = captions.first as Map<String, dynamic>;
        caption = firstCaption['content']?.toString() ?? '';
      }
      suggestedCaptionData = streamingState.captionOptions;
    }

    // Determinar media URL
    final mediaUrl = streamingState.videoUrl ?? streamingState.mediaUrl ?? '';

    // Usar el previewId real de la BD si está disponible
    // IMPORTANTE: Para stories, el previewId DEBE venir del backend (preview_saved event)
    // Si no está disponible y es story, esperar a que llegue el preview_saved
    final previewId = streamingState.previewId;
    if (previewId == null) {
      print('⚠️ ADVERTENCIA: previewId no disponible al construir PreviewEntity para tipo: $type');
      // Para stories, el previewId es obligatorio - el backend debe enviarlo antes de done
      if (type == 'story') {
        print('❌ Error: Preview ID no disponible para story. El backend debe enviar preview_saved antes de done.');
        // Usar un ID temporal pero registrar el error
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        print('⚠️ Usando ID temporal para story: $tempId - Esto causará error al publicar');
        // Continuar con el ID temporal pero esto debería ser raro
      } else {
        // Para otros tipos, usar timestamp temporal (compatibilidad hacia atrás)
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        print('⚠️ Usando ID temporal: $tempId');
      }
      // Continuar con el flujo normal pero con ID temporal
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      return _buildPreviewResponse(streamingState, request, type, tempId, caption, suggestedCaptionData, mediaUrl);
    }
    
    return _buildPreviewResponse(streamingState, request, type, previewId, caption, suggestedCaptionData, mediaUrl);
  }

  PreviewResponse _buildPreviewResponse(
    PreviewCreationStreaming streamingState,
    CreatePreviewRequest request,
    String type,
    String previewId,
    String caption,
    Map<String, dynamic>? suggestedCaptionData,
    String mediaUrl,
  ) {

    // Crear PreviewEntity
    final preview = PreviewEntity(
      id: previewId,
      type: type,
      topic: request.topic,
      style: request.style,
      targetAudience: request.targetAudience,
      referenceImage: request.referenceImage,
      previewImage: mediaUrl,
      videoUrl: streamingState.videoUrl,
      caption: caption,
      status: 'draft',
      createdAt: DateTime.now(),
      views: 0,
      likes: 0,
      comments: 0,
      metadata: {
        'generated_at': DateTime.now().toIso8601String(),
        'improve_suggestions': streamingState.improveSuggestions ?? [],
        'suggested_caption': suggestedCaptionData,
        'media_url': streamingState.mediaUrl,
        'video_url': streamingState.videoUrl,
      },
    );

    // Generar correcciones sugeridas
    final suggestedCorrections = (streamingState.improveSuggestions != null && streamingState.improveSuggestions!.isNotEmpty)
        ? streamingState.improveSuggestions!
        : _generateSuggestedCorrections(request.topic, request.targetAudience);

    return PreviewResponse(
      preview: preview,
      suggestedCorrections: suggestedCorrections,
      metadata: {
        'generated_at': DateTime.now().toIso8601String(),
        'improve_suggestions': streamingState.improveSuggestions ?? [],
        'suggested_caption': suggestedCaptionData,
        'media_url': streamingState.mediaUrl,
        'video_url': streamingState.videoUrl,
      },
    );
  }

  List<String> _generateSuggestedCorrections(String topic, String targetAudience) {
    // Generar correcciones básicas si no hay sugerencias del backend
    return [
      'Considera ajustar el tono para mejor conexión con $targetAudience',
      'Revisa la longitud del caption para optimizar engagement',
    ];
  }

  void reset() {
    _streamSubscription?.cancel();
    _streamService.cancel();
    state = const PreviewCreationInitial();
  }
}

// Notifier para lista de previews
class PreviewsListNotifier extends StateNotifier<PreviewsListState> {
  final PreviewApiService _apiService;

  PreviewsListNotifier(this._apiService) : super(const PreviewsListInitial());

  Future<void> loadPreviews({
    String? status,
    String? type,
    int limit = 20,
    int offset = 0,
    String? search,
    bool append = false,
  }) async {
    if (!append) {
      state = const PreviewsListLoading();
    }
    
    try {
      print('DEBUG: Loading previews with params: status=$status, type=$type, limit=$limit, offset=$offset, append=$append');
      final response = await _apiService.getPreviews(
        status: status,
        type: type,
        limit: limit,
        offset: offset,
        search: search,
      );
      print('DEBUG: Previews loaded successfully: ${response.previews.length} previews');
      
      if (append && state is PreviewsListLoaded) {
        final currentState = state as PreviewsListLoaded;
        final combinedPreviews = [...currentState.response.previews, ...response.previews];
        state = PreviewsListLoaded(PreviewsResponse(
          previews: combinedPreviews,
          total: response.total,
          limit: response.limit,
          offset: response.offset,
          hasMore: response.hasMore,
        ));
      } else {
        state = PreviewsListLoaded(response);
      }
    } catch (e) {
      print('DEBUG: Error loading previews: $e');
      state = PreviewsListError(e.toString());
    }
  }

  Future<void> refreshPreviews() async {
    await loadPreviews();
  }

  Future<void> loadMorePreviews() async {
    final currentState = state;
    if (currentState is PreviewsListLoaded) {
      final newOffset = currentState.response.offset + currentState.response.limit;
      try {
        final response = await _apiService.getPreviews(
          limit: currentState.response.limit,
          offset: newOffset,
        );
        
        final updatedPreviews = [
          ...currentState.response.previews,
          ...response.previews,
        ];
        
        final updatedResponse = PreviewsResponse(
          previews: updatedPreviews,
          total: response.total,
          limit: response.limit,
          offset: newOffset,
          hasMore: response.hasMore,
        );
        
        state = PreviewsListLoaded(updatedResponse);
      } catch (e) {
        state = PreviewsListError(e.toString());
      }
    }
  }
}

// Notifier para detalles de preview
class PreviewDetailsNotifier extends StateNotifier<PreviewDetailsState> {
  final PreviewApiService _apiService;

  PreviewDetailsNotifier(this._apiService) : super(const PreviewDetailsInitial());

  Future<void> loadPreview(String previewId) async {
    state = const PreviewDetailsLoading();
    try {
      final preview = await _apiService.getPreview(previewId);
      state = PreviewDetailsLoaded(preview);
    } catch (e) {
      state = PreviewDetailsError(e.toString());
    }
  }

  Future<PreviewEntity?> applyCorrections(
    String previewId,
    ApplyCorrectionsRequest request,
  ) async {
    try {
      final updatedPreview = await _apiService.applyCorrections(previewId, request);
      state = PreviewDetailsLoaded(updatedPreview);
      return updatedPreview;
    } catch (e) {
      state = PreviewDetailsError(e.toString());
      return null;
    }
  }

  Future<void> publishPreview(
    String previewId,
    PublishPreviewRequest request,
  ) async {
    try {
      // Normalizar caption: si viene vacío o como JSON de captions, extraer texto
      String? effective = request.finalCaption;
      if (effective == null || effective.trim().isEmpty || effective.trim().startsWith('{') || effective.trim().startsWith('[')) {
        // Intentar desde el estado actual cargado
        PreviewEntity? current;
        if (state is PreviewDetailsLoaded) {
          current = (state as PreviewDetailsLoaded).preview;
        }
        // Si no hay estado cargado, obtener detalles desde la API
        current ??= await _apiService.getPreview(previewId);
        // 1) Si request trae JSON válido, parsear
        final parsedFromRequest = _extractContentFromJson(effective);
        if (parsedFromRequest != null && parsedFromRequest.isNotEmpty) {
          effective = parsedFromRequest;
        } else {
          // 2) Usar caption plano si existe
          if (current.caption.trim().isNotEmpty) {
            effective = current.caption.trim();
          } else {
            // 3) Intentar metadata.suggested_caption.captions[0].content
            final meta = current.metadata;
            if (meta != null && meta['suggested_caption'] is Map<String, dynamic>) {
              final sc = meta['suggested_caption'] as Map<String, dynamic>;
              if (sc['captions'] is List && (sc['captions'] as List).isNotEmpty) {
                final first = (sc['captions'] as List).first;
                if (first is Map<String, dynamic>) {
                  effective = (first['content']?.toString() ?? '').trim();
                }
              }
            }
          }
        }
      }

      print('DEBUG: Publishing preview $previewId with caption(normalized): ${effective ?? '(null)'}');
      final publishedPreview = await _apiService.publishPreview(previewId, PublishPreviewRequest(finalCaption: effective));
      state = PreviewDetailsLoaded(publishedPreview);
    } catch (e) {
      print('DEBUG: Error publishing preview: $e');
      // Extraer el mensaje de error más específico si es posible
      String errorMessage = e.toString();
      if (e.toString().contains('OAuthException')) {
        errorMessage = 'Error de Instagram: El contenido no cumple con los requisitos de la plataforma.';
      } else if (e.toString().contains('Media download has failed')) {
        errorMessage = 'Error: La imagen no se pudo procesar correctamente.';
      } else if (e.toString().contains('Only photo or video can be accepted')) {
        errorMessage = 'Error: Solo se aceptan fotos o videos como contenido.';
      }
      state = PreviewDetailsError(errorMessage);
    }
  }

  // Extrae el primer captions[0].content si la cadena es un JSON válido con esa estructura
  String? _extractContentFromJson(String? raw) {
    if (raw == null) return null;
    final t = raw.trim();
    if (!(t.startsWith('{') || t.startsWith('['))) return null;
    try {
      final decoded = jsonDecode(t);
      if (decoded is Map<String, dynamic>) {
        final caps = decoded['captions'];
        if (caps is List && caps.isNotEmpty) {
          final first = caps.first;
          if (first is Map && first['content'] != null) {
            return first['content'].toString();
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> deletePreview(String previewId) async {
    try {
      await _apiService.deletePreview(previewId);
      state = const PreviewDetailsInitial();
    } catch (e) {
      state = PreviewDetailsError(e.toString());
    }
  }
}

// Notifier para correcciones
class CorrectionsNotifier extends StateNotifier<CorrectionsState> {
  final PreviewApiService _apiService;

  CorrectionsNotifier(this._apiService) : super(const CorrectionsInitial());

  Future<void> loadCorrections(String previewId) async {
    state = const CorrectionsLoading();
    try {
      final corrections = await _apiService.getPreviewCorrections(previewId);
      state = CorrectionsLoaded(corrections);
    } catch (e) {
      state = CorrectionsError(e.toString());
    }
  }

  Future<void> applyCorrection(String previewId, String correctionId) async {
    try {
      await _apiService.applySpecificCorrection(previewId, correctionId);
      await loadCorrections(previewId); // Recargar correcciones
    } catch (e) {
      state = CorrectionsError(e.toString());
    }
  }

  Future<void> rejectCorrection(String previewId, String correctionId) async {
    try {
      await _apiService.rejectCorrection(previewId, correctionId);
      await loadCorrections(previewId); // Recargar correcciones
    } catch (e) {
      state = CorrectionsError(e.toString());
    }
  }
}

// Providers
final previewCreationProvider = StateNotifierProvider<PreviewCreationNotifier, PreviewCreationState>((ref) {
  final apiService = ref.watch(previewApiServiceProvider);
  return PreviewCreationNotifier(apiService);
});

final previewsListProvider = StateNotifierProvider<PreviewsListNotifier, PreviewsListState>((ref) {
  final apiService = ref.watch(previewApiServiceProvider);
  return PreviewsListNotifier(apiService);
});

final previewDetailsProvider = StateNotifierProvider<PreviewDetailsNotifier, PreviewDetailsState>((ref) {
  final apiService = ref.watch(previewApiServiceProvider);
  return PreviewDetailsNotifier(apiService);
});

final correctionsProvider = StateNotifierProvider<CorrectionsNotifier, CorrectionsState>((ref) {
  final apiService = ref.watch(previewApiServiceProvider);
  return CorrectionsNotifier(apiService);
});

// Provider para estadísticas
final previewStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiService = ref.watch(previewApiServiceProvider);
  return await apiService.getPreviewStats();
});
