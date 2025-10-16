import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/preview_api_service.dart';
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

  PreviewCreationNotifier(this._apiService) : super(const PreviewCreationInitial());

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
      state = PreviewCreationSuccess(response);
    } catch (e) {
      state = PreviewCreationError(e.toString());
    }
  }

  void reset() {
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
      print('DEBUG: Publishing preview $previewId with caption: ${request.finalCaption}');
      final publishedPreview = await _apiService.publishPreview(previewId, request);
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
