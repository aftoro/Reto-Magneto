import 'package:dio/dio.dart';
import '../config/api_config.dart';

class SearchService {
  final Dio _dio = Dio();

  SearchService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.headers.addAll(ApiConfig.defaultHeaders);
  }

  /// Búsqueda general con fuzzy search
  Future<SearchResult> search({
    required String query,
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
    try {
      final params = {
        'q': query,
        'type': type,
        'platform': platform,
        'limit': limit,
        'offset': offset,
        'fuzzy': fuzzy.toString(),
      };

      if (conversationType != null) params['conversation_type'] = conversationType;
      if (authorType != null) params['author_type'] = authorType;
      if (dateFrom != null) params['date_from'] = dateFrom;
      if (dateTo != null) params['date_to'] = dateTo;

      final response = await _dio.get('/api/search', queryParameters: params);
      
      return SearchResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Error en búsqueda: $e');
    }
  }

  /// Búsqueda rápida
  Future<QuickSearchResult> quickSearch({
    required String query,
    int limit = 20,
    String platform = 'instagram',
  }) async {
    try {
      final params = {
        'q': query,
        'limit': limit,
        'platform': platform,
      };

      final response = await _dio.get('/api/search/quick', queryParameters: params);
      
      return QuickSearchResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Error en búsqueda rápida: $e');
    }
  }

  /// Búsqueda fuzzy avanzada
  Future<FuzzySearchResult> fuzzySearch({
    required String query,
    String type = 'messages',
    double threshold = 0.4,
    int limit = 20,
    String platform = 'instagram',
    String? conversationType,
    String? authorType,
  }) async {
    try {
      final params = {
        'q': query,
        'type': type,
        'threshold': threshold,
        'limit': limit,
        'platform': platform,
      };

      if (conversationType != null) params['conversation_type'] = conversationType;
      if (authorType != null) params['author_type'] = authorType;

      final response = await _dio.get('/api/search/fuzzy', queryParameters: params);
      
      return FuzzySearchResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Error en búsqueda fuzzy: $e');
    }
  }

  /// Búsqueda por usuario
  Future<UserSearchResult> searchByUser({
    required String userId,
    String? query,
    int limit = 50,
    int offset = 0,
    String platform = 'instagram',
  }) async {
    try {
      final params = {
        'limit': limit,
        'offset': offset,
        'platform': platform,
      };

      if (query != null && query.isNotEmpty) params['q'] = query;

      final response = await _dio.get('/api/search/user/$userId', queryParameters: params);
      
      return UserSearchResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Error en búsqueda por usuario: $e');
    }
  }
}

class SearchResult {
  final List<Map<String, dynamic>> conversations;
  final List<Map<String, dynamic>> messages;
  final int totalConversations;
  final int totalMessages;
  final int totalResults;
  final String query;
  final Map<String, dynamic> filters;

  SearchResult({
    required this.conversations,
    required this.messages,
    required this.totalConversations,
    required this.totalMessages,
    required this.totalResults,
    required this.query,
    required this.filters,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      conversations: List<Map<String, dynamic>>.from(json['conversations'] ?? []),
      messages: List<Map<String, dynamic>>.from(json['messages'] ?? []),
      totalConversations: json['total_conversations'] ?? 0,
      totalMessages: json['total_messages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
      query: json['query'] ?? '',
      filters: Map<String, dynamic>.from(json['filters'] ?? {}),
    );
  }
}

class QuickSearchResult {
  final String query;
  final List<Map<String, dynamic>> results;
  final int total;

  QuickSearchResult({
    required this.query,
    required this.results,
    required this.total,
  });

  factory QuickSearchResult.fromJson(Map<String, dynamic> json) {
    return QuickSearchResult(
      query: json['query'] ?? '',
      results: List<Map<String, dynamic>>.from(json['results'] ?? []),
      total: json['total'] ?? 0,
    );
  }
}

class FuzzySearchResult {
  final String query;
  final String type;
  final double threshold;
  final List<Map<String, dynamic>> results;
  final int total;
  final String searchType;

  FuzzySearchResult({
    required this.query,
    required this.type,
    required this.threshold,
    required this.results,
    required this.total,
    required this.searchType,
  });

  factory FuzzySearchResult.fromJson(Map<String, dynamic> json) {
    return FuzzySearchResult(
      query: json['query'] ?? '',
      type: json['type'] ?? 'messages',
      threshold: (json['threshold'] ?? 0.4).toDouble(),
      results: List<Map<String, dynamic>>.from(json['results'] ?? []),
      total: json['total'] ?? 0,
      searchType: json['search_type'] ?? 'fuzzy_advanced',
    );
  }
}

class UserSearchResult {
  final String userId;
  final String? query;
  final List<Map<String, dynamic>> results;
  final int total;

  UserSearchResult({
    required this.userId,
    this.query,
    required this.results,
    required this.total,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      userId: json['user_id'] ?? '',
      query: json['query'],
      results: List<Map<String, dynamic>>.from(json['results'] ?? []),
      total: json['total'] ?? 0,
    );
  }
}
