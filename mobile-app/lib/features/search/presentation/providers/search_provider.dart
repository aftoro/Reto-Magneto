import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/services/search_service.dart';

part 'search_provider.freezed.dart';

// Provider para el servicio de búsqueda
final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.loaded({
    required SearchResult result,
  }) = _Loaded;
  const factory SearchState.error({required String message}) = _Error;
}

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchService _searchService;
  Timer? _debounceTimer;

  SearchNotifier({required SearchService searchService})
      : _searchService = searchService,
        super(const SearchState.initial());

  /// Búsqueda con debounce
  void search(String query, {
    String type = 'all',
    String platform = 'instagram',
    String? conversationType,
    String? authorType,
    String? dateFrom,
    String? dateTo,
    int limit = 50,
    int offset = 0,
    bool fuzzy = true,
  }) {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    if (query.trim().length < 2) {
      return; // Mínimo 2 caracteres
    }

    // Cancelar timer anterior
    _debounceTimer?.cancel();

    // Configurar debounce de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(
        query.trim(),
        type: type,
        platform: platform,
        conversationType: conversationType,
        authorType: authorType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        limit: limit,
        offset: offset,
        fuzzy: fuzzy,
      );
    });
  }

  /// Búsqueda inmediata
  void searchImmediate(String query, {
    String type = 'all',
    String platform = 'instagram',
    String? conversationType,
    String? authorType,
    String? dateFrom,
    String? dateTo,
    int limit = 50,
    int offset = 0,
    bool fuzzy = true,
  }) {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    if (query.trim().length < 2) {
      return;
    }

    _performSearch(
      query.trim(),
      type: type,
      platform: platform,
      conversationType: conversationType,
      authorType: authorType,
      dateFrom: dateFrom,
      dateTo: dateTo,
      limit: limit,
      offset: offset,
      fuzzy: fuzzy,
    );
  }

  /// Búsqueda rápida
  Future<void> quickSearch(String query, {
    int limit = 20,
    String platform = 'instagram',
  }) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    if (query.trim().length < 2) {
      return;
    }

    state = const SearchState.loading();

    try {
      final result = await _searchService.quickSearch(
        query: query.trim(),
        limit: limit,
        platform: platform,
      );

      // Convertir QuickSearchResult a SearchResult para mantener consistencia
      final searchResult = SearchResult(
        conversations: [],
        messages: result.results,
        totalConversations: 0,
        totalMessages: result.total,
        totalResults: result.total,
        query: result.query,
        filters: {
          'type': 'messages',
          'platform': platform,
        },
      );

      state = SearchState.loaded(result: searchResult);
    } catch (e) {
      state = SearchState.error(message: e.toString());
    }
  }

  /// Búsqueda fuzzy avanzada
  Future<void> fuzzySearch(String query, {
    String type = 'messages',
    double threshold = 0.4,
    int limit = 20,
    String platform = 'instagram',
    String? conversationType,
    String? authorType,
  }) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    if (query.trim().length < 2) {
      return;
    }

    state = const SearchState.loading();

    try {
      final result = await _searchService.fuzzySearch(
        query: query.trim(),
        type: type,
        threshold: threshold,
        limit: limit,
        platform: platform,
        conversationType: conversationType,
        authorType: authorType,
      );

      // Convertir FuzzySearchResult a SearchResult
      final searchResult = SearchResult(
        conversations: type == 'conversations' ? result.results : [],
        messages: type == 'messages' ? result.results : [],
        totalConversations: type == 'conversations' ? result.total : 0,
        totalMessages: type == 'messages' ? result.total : 0,
        totalResults: result.total,
        query: result.query,
        filters: {
          'type': type,
          'platform': platform,
          'threshold': threshold,
          'conversation_type': conversationType,
          'author_type': authorType,
        },
      );

      state = SearchState.loaded(result: searchResult);
    } catch (e) {
      state = SearchState.error(message: e.toString());
    }
  }

  /// Búsqueda por usuario
  Future<void> searchByUser(String userId, {
    String? query,
    int limit = 50,
    int offset = 0,
    String platform = 'instagram',
  }) async {
    state = const SearchState.loading();

    try {
      final result = await _searchService.searchByUser(
        userId: userId,
        query: query,
        limit: limit,
        offset: offset,
        platform: platform,
      );

      // Convertir UserSearchResult a SearchResult
      final searchResult = SearchResult(
        conversations: [],
        messages: result.results,
        totalConversations: 0,
        totalMessages: result.total,
        totalResults: result.total,
        query: result.query ?? '',
        filters: {
          'type': 'messages',
          'platform': platform,
          'user_id': userId,
        },
      );

      state = SearchState.loaded(result: searchResult);
    } catch (e) {
      state = SearchState.error(message: e.toString());
    }
  }

  /// Realizar búsqueda
  Future<void> _performSearch(String query, {
    String type = 'all',
    String platform = 'instagram',
    String? conversationType,
    String? authorType,
    String? dateFrom,
    String? dateTo,
    int limit = 50,
    int offset = 0,
    bool fuzzy = true,
  }) async {
    state = const SearchState.loading();

    try {
      final result = await _searchService.search(
        query: query,
        type: type,
        platform: platform,
        conversationType: conversationType,
        authorType: authorType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        limit: limit,
        offset: offset,
        fuzzy: fuzzy,
      );

      state = SearchState.loaded(result: result);
    } catch (e) {
      state = SearchState.error(message: e.toString());
    }
  }

  /// Limpiar búsqueda
  void clearSearch() {
    _debounceTimer?.cancel();
    state = const SearchState.initial();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    searchService: ref.watch(searchServiceProvider),
  );
});
