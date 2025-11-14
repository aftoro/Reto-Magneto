import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/instagram_post_entity.dart';
import '../../data/datasources/instagram_api_service.dart';

part 'instagram_posts_provider.freezed.dart';

// Provider para el servicio de API
final instagramApiServiceProvider = Provider<InstagramApiService>((ref) => InstagramApiService());

@freezed
class InstagramPostsState with _$InstagramPostsState {
  const factory InstagramPostsState.initial() = _Initial;
  const factory InstagramPostsState.loading() = _Loading;
  const factory InstagramPostsState.loaded({
    required List<InstagramPostEntity> posts,
    required InstagramPagination pagination,
  }) = _Loaded;
  const factory InstagramPostsState.error({required String message}) = _Error;
}

@freezed
class InstagramCommentsState with _$InstagramCommentsState {
  const factory InstagramCommentsState.initial() = _CommentsInitial;
  const factory InstagramCommentsState.loading() = _CommentsLoading;
  const factory InstagramCommentsState.loaded({
    required List<InstagramCommentEntity> comments,
    required int count,
  }) = _CommentsLoaded;
  const factory InstagramCommentsState.error({required String message}) = _CommentsError;
}

class InstagramPostsNotifier extends StateNotifier<InstagramPostsState> {
  final InstagramApiService _apiService;
  bool _hasLoadedOnce = false;

  InstagramPostsNotifier(this._apiService) : super(const InstagramPostsState.initial());

  /// Cargar posts solo si no se han cargado antes
  Future<void> loadPostsIfNeeded({
    int page = 1,
    int limit = 20,
  }) async {
    // Si ya se cargaron los datos una vez, no volver a cargar automáticamente
    if (_hasLoadedOnce && state is! _Loading) {
      return;
    }
    
    await loadPosts(page: page, limit: limit);
  }

  /// Cargar posts (forzar carga)
  Future<void> loadPosts({
    int page = 1,
    int limit = 20,
  }) async {
    state = const InstagramPostsState.loading();
    try {
      final response = await _apiService.getPosts(
        page: page,
        limit: limit,
      );
      
      state = InstagramPostsState.loaded(
        posts: response.data,
        pagination: response.pagination,
      );
      _hasLoadedOnce = true;
    } catch (e) {
      state = InstagramPostsState.error(message: e.toString());
    }
  }

  /// Refrescar posts (forzar recarga)
  Future<void> refreshPosts() async {
    _hasLoadedOnce = false; // Reset flag to allow reload
    await loadPosts();
  }

  /// Buscar posts
  Future<void> searchPosts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    state = const InstagramPostsState.loading();
    try {
      final response = await _apiService.searchPosts(
        query: query,
        page: page,
        limit: limit,
      );
      
      state = InstagramPostsState.loaded(
        posts: response.data,
        pagination: response.pagination,
      );
    } catch (e) {
      state = InstagramPostsState.error(message: e.toString());
    }
  }
}

class InstagramCommentsNotifier extends StateNotifier<InstagramCommentsState> {
  final InstagramApiService _apiService;
  final Map<String, bool> _loadedPosts = {};

  InstagramCommentsNotifier(this._apiService) : super(const InstagramCommentsState.initial());

  /// Cargar comentarios solo si no se han cargado antes para este post
  Future<void> loadCommentsIfNeeded(
    String postId, {
    bool includeReplies = true,
  }) async {
    // Si ya se cargaron los comentarios para este post, no volver a cargar
    if (_loadedPosts[postId] == true && state is! _CommentsLoading) {
      return;
    }
    
    await loadComments(postId, includeReplies: includeReplies);
  }

  /// Cargar comentarios de un post (forzar carga)
  Future<void> loadComments(
    String postId, {
    bool includeReplies = true,
  }) async {
    state = const InstagramCommentsState.loading();
    try {
      final response = await _apiService.getPostComments(
        postId,
        includeReplies: includeReplies,
      );
      
      // Si la respuesta indica que no hay datos pero no es un error
      if (!response.success && response.data.isEmpty) {
        state = InstagramCommentsState.loaded(
          comments: [],
          count: 0,
        );
        _loadedPosts[postId] = true;
        return;
      }
      
      state = InstagramCommentsState.loaded(
        comments: response.data,
        count: response.count,
      );
      _loadedPosts[postId] = true;
    } catch (e) {
      // Si es un error de conexión o 404, mostrar comentarios vacíos en lugar de error
      if (e.toString().contains('404') || 
          e.toString().contains('connection') ||
          e.toString().contains('timeout')) {
        state = InstagramCommentsState.loaded(
          comments: [],
          count: 0,
        );
        _loadedPosts[postId] = true;
      } else {
        state = InstagramCommentsState.error(message: e.toString());
      }
    }
  }

  /// Refrescar comentarios (forzar recarga)
  Future<void> refreshComments(String postId) async {
    _loadedPosts[postId] = false; // Reset flag to allow reload
    await loadComments(postId);
  }
}

// Providers
final instagramPostsNotifierProvider = StateNotifierProvider<InstagramPostsNotifier, InstagramPostsState>((ref) {
  return InstagramPostsNotifier(ref.watch(instagramApiServiceProvider));
});

final instagramCommentsNotifierProvider = StateNotifierProvider<InstagramCommentsNotifier, InstagramCommentsState>((ref) {
  return InstagramCommentsNotifier(ref.watch(instagramApiServiceProvider));
});
