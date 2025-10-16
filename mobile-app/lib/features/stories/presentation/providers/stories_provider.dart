import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/story_entity.dart';
import '../../data/datasources/stories_api_service.dart';

part 'stories_provider.freezed.dart';

// Provider para el servicio de API
final storiesApiServiceProvider = Provider<StoriesApiService>((ref) => StoriesApiService());

@freezed
class StoriesState with _$StoriesState {
  const factory StoriesState.initial() = _Initial;
  const factory StoriesState.loading() = _Loading;
  const factory StoriesState.loaded({
    required List<StoryEntity> stories,
    required int total,
    required int limit,
    required int offset,
  }) = _Loaded;
  const factory StoriesState.error({required String message}) = _Error;
}

class StoriesNotifier extends StateNotifier<StoriesState> {
  final StoriesApiService _apiService;

  StoriesNotifier(this._apiService) : super(const StoriesState.initial());

  /// Cargar stories
  Future<void> loadStories({
    int limit = 20,
    int offset = 0,
    String status = 'created',
  }) async {
    state = const StoriesState.loading();
    try {
      final response = await _apiService.getStories(
        limit: limit,
        offset: offset,
        status: status,
      );
      
      // Si la respuesta indica que no hay datos pero no es un error
      if (response.stories.isEmpty && response.total == 0) {
        state = StoriesState.loaded(
          stories: [],
          total: 0,
          limit: limit,
          offset: offset,
        );
        return;
      }
      
      state = StoriesState.loaded(
        stories: response.stories,
        total: response.total,
        limit: response.limit,
        offset: response.offset,
      );
    } catch (e) {
      // Si es un error de conexión o 404, mostrar stories vacías en lugar de error
      if (e.toString().contains('404') || 
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        state = StoriesState.loaded(
          stories: [],
          total: 0,
          limit: limit,
          offset: offset,
        );
      } else {
        state = StoriesState.error(message: e.toString());
      }
    }
  }

  /// Refrescar stories
  Future<void> refreshStories({
    int limit = 20,
    int offset = 0,
    String status = 'created',
  }) async {
    await loadStories(
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  /// Cargar más stories (paginación)
  Future<void> loadMoreStories({
    int limit = 20,
    String status = 'created',
  }) async {
    final currentState = state;
    
    currentState.when(
      initial: () {},
      loading: () {},
      loaded: (stories, total, limit, offset) async {
        final newOffset = offset + limit;
        
        try {
          final response = await _apiService.getStories(
            limit: limit,
            offset: newOffset,
            status: status,
          );
          
          final allStories = [...stories, ...response.stories];
          
          state = StoriesState.loaded(
            stories: allStories,
            total: response.total,
            limit: response.limit,
            offset: newOffset,
          );
        } catch (e) {
          // No cambiar el estado si hay error al cargar más
          print('Error al cargar más stories: $e');
        }
      },
      error: (error) {},
    );
  }

  /// Cargar stories por estado específico
  Future<void> loadStoriesByStatus({
    required String status,
    int limit = 20,
    int offset = 0,
  }) async {
    await loadStories(
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  /// Cargar stories publicadas
  Future<void> loadPublishedStories({
    int limit = 20,
    int offset = 0,
  }) async {
    await loadStoriesByStatus(
      status: 'published',
      limit: limit,
      offset: offset,
    );
  }

  /// Cargar stories pendientes
  Future<void> loadPendingStories({
    int limit = 20,
    int offset = 0,
  }) async {
    await loadStoriesByStatus(
      status: 'pending',
      limit: limit,
      offset: offset,
    );
  }

  /// Cargar stories fallidas
  Future<void> loadFailedStories({
    int limit = 20,
    int offset = 0,
  }) async {
    await loadStoriesByStatus(
      status: 'failed',
      limit: limit,
      offset: offset,
    );
  }
}

// Providers
final storiesNotifierProvider = StateNotifierProvider<StoriesNotifier, StoriesState>((ref) {
  return StoriesNotifier(ref.watch(storiesApiServiceProvider));
});
