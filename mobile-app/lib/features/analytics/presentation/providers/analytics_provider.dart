import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/analytics_entity.dart';
import '../../data/datasources/analytics_api_service.dart';

part 'analytics_provider.freezed.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.initial() = _Initial;
  const factory AnalyticsState.loading() = _Loading;
  const factory AnalyticsState.loaded(AnalyticsEntity analytics) = _Loaded;
  const factory AnalyticsState.error(String message) = _Error;
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsApiService _apiService;
  final Ref ref;
  bool _hasLoadedOnce = false;

  AnalyticsNotifier(this._apiService, this.ref) : super(const AnalyticsState.initial());

  /// Carga estadísticas con análisis de IA solo si no se han cargado antes
  Future<void> loadAIAnalyticsIfNeeded() async {
    // Si ya se cargaron los datos una vez, no volver a cargar automáticamente
    if (_hasLoadedOnce && state is! _Loading) {
      return;
    }
    
    await loadAIAnalytics();
  }

  /// Carga estadísticas con análisis de IA (forzar carga)
  Future<void> loadAIAnalytics() async {
    state = const AnalyticsState.loading();
    
    try {
      final response = await _apiService.getAIAnalytics();
      if (response.success) {
        state = AnalyticsState.loaded(response.analytics);
        _hasLoadedOnce = true;
      } else {
        state = AnalyticsState.error('Error al cargar estadísticas: ${response.message}');
      }
    } catch (e) {
      state = AnalyticsState.error('Error de conexión: $e');
    }
  }

  /// Obtiene solo los insights de IA y los fusiona con el estado actual sin bloquear la UI
  Future<void> fetchAndMergeAIInsights() async {
    try {
      ref.read(aiLoadingProvider.notifier).state = true;
      // Si ya hay estadísticas básicas, reusar para IA vía POST
      final current = state.maybeWhen(loaded: (a) => a, orElse: () => null);
      if (current != null) {
        final payload = {
          'posts': {
            'totalPosts': current.posts.summary.totalPosts,
            'totalComments': current.posts.summary.totalComments,
            'totalLikes': current.posts.summary.totalLikes,
            'avgEngagement': current.posts.summary.avgEngagement,
            'aiResponses': current.posts.summary.aiResponses,
            'userComments': current.posts.summary.userComments,
            'topSectors': current.posts.topSectors
                .map((e) => {'sector': e.sector, 'count': e.count})
                .toList(),
            'topPositions': current.posts.topPositions
                .map((e) => {'position': e.position, 'count': e.count})
                .toList(),
            'posts': current.posts.recentPosts
                .map((e) => {
                      'id': e.id,
                      'caption': e.caption,
                      'comments': e.comments,
                      'likes': e.likes,
                      'created_at': e.createdAt.toIso8601String(),
                    })
                .toList(),
          },
          'conversations': {
            'totalConversations': current.conversations.summary.totalConversations,
            'activeConversations': current.conversations.summary.activeConversations,
            'avgCompletion': current.conversations.summary.avgCompletion,
            'messageStats': {
              'total': current.conversations.summary.messageStats.total,
              'aiGenerated': current.conversations.summary.messageStats.aiGenerated,
              'userGenerated': current.conversations.summary.messageStats.userGenerated,
              'aiRatio': current.conversations.summary.messageStats.aiRatio,
            },
            'topProfessions': current.conversations.topProfessions
                .map((e) => {'profession': e.profession, 'count': e.count})
                .toList(),
            'topLocations': current.conversations.topLocations
                .map((e) => {'location': e.location, 'count': e.count})
                .toList(),
            'experienceDistribution': current.conversations.experienceDistribution
                .map((e) => {'level': e.level, 'count': e.count})
                .toList(),
          }
        };
        var aiInsights = await _apiService.postAIInsightsWithExistingStats(payload);
        // Normalización adicional: si viene un único string con JSON en ```json ...```, parsearlo
        if ((aiInsights.recommendations.isEmpty && aiInsights.insights.length == 1)) {
          final parsed = _tryParseInsightsJson(aiInsights.insights.first);
          if (parsed != null) {
            aiInsights = parsed;
          }
        }
        final merged = current.copyWith(aiInsights: aiInsights);
        state = AnalyticsState.loaded(merged);
        _hasLoadedOnce = true;
        ref.read(aiLoadingProvider.notifier).state = false;
        return;
      }

      // Fallback: si no hay básicas aún, usa GET completo (con timeout extendido)
      final response = await _apiService.getAIAnalytics();
      if (!response.success) {
        ref.read(aiLoadingProvider.notifier).state = false;
        return; // no afectar estado si falla
      }
      state = AnalyticsState.loaded(response.analytics);
      _hasLoadedOnce = true;
    } catch (_) {
      // silencioso para no interrumpir la UI
    } finally {
      ref.read(aiLoadingProvider.notifier).state = false;
    }
  }

  AIInsightsEntity? _tryParseInsightsJson(String raw) {
    try {
      var clean = raw.trim();
      if (clean.startsWith('```')) {
        // remover cercas ```json \n ... ```
        clean = clean.replaceFirst(RegExp(r'^```[a-zA-Z]*'), '').replaceFirst('\n', '');
        if (clean.endsWith('```')) {
          clean = clean.substring(0, clean.length - 3);
        }
      }
      final dynamic json = _safeDecode(clean);
      if (json is! Map<String, dynamic>) return null;

      // Buscar bloque raíz conocido
      final root = (json['analisis_magneto_empleos'] as Map<String, dynamic>?) ?? json;

      final tendencias = (root['tendencias_mercado_laboral'] as Map<String, dynamic>?) ?? {};
      final sectores = (tendencias['sectores_demanda'] as Map?)?.keys
              .map((e) => e.toString())
              .toList() ??
          <String>[];
      final patrones = (root['patrones_interes'] as Map<String, dynamic>?) ?? {};
      final comportamiento = (root['comportamiento_usuarios'] as Map<String, dynamic>?) ?? {};
      final recs = (root['recomendaciones'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
      final insights = <String>[];
      // Agregar observaciones si existen
      if (tendencias['observacion'] != null) insights.add(tendencias['observacion'].toString());
      if (patrones.isNotEmpty) insights.add('Patrones: ' + patrones.keys.join(', '));
      if (comportamiento['interpretacion'] != null) insights.add(comportamiento['interpretacion'].toString());

      return AIInsightsEntity.fromApiJson({
        'marketTrends': {
          'hotSectors': sectores,
          'demandPatterns': tendencias['observacion']?.toString() ?? '',
          'growthOpportunities': (root['oportunidades_mejora'] is List && (root['oportunidades_mejora'] as List).isNotEmpty)
              ? (root['oportunidades_mejora'] as List).first.toString()
              : '',
        },
        'userBehavior': {
          'engagementLevel': comportamiento['nivel_engagement']?.toString() ?? '',
          'profileCompletion': comportamiento['completitud_datos']?.toString() ?? '',
          'interactionPatterns': comportamiento['interpretacion']?.toString() ?? '',
        },
        'recommendations': recs,
        'insights': insights,
      });
    } catch (_) {
      return null;
    }
  }

  dynamic _safeDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (_) {
      return null;
    }
  }

  /// Carga estadísticas básicas solo si no se han cargado antes
  Future<void> loadBasicAnalyticsIfNeeded() async {
    // Si ya se cargaron los datos una vez, no volver a cargar automáticamente
    if (_hasLoadedOnce && state is! _Loading) {
      return;
    }
    
    await loadBasicAnalytics();
  }

  /// Carga estadísticas básicas (forzar carga)
  Future<void> loadBasicAnalytics() async {
    state = const AnalyticsState.loading();
    
    try {
      final response = await _apiService.getBasicAnalytics();
      if (response.success) {
        // Log del objeto de analytics cargado
        try {
          print('[AnalyticsNotifier] analytics cargado (basic): ${response.analytics.toString()}');
        } catch (_) {}
        state = AnalyticsState.loaded(response.analytics);
        _hasLoadedOnce = true;
      } else {
        state = AnalyticsState.error('Error al cargar estadísticas: ${response.message}');
      }
    } catch (e) {
      state = AnalyticsState.error('Error de conexión: $e');
    }
  }

  /// Refresca las estadísticas (forzar recarga)
  Future<void> refreshAnalytics() async {
    _hasLoadedOnce = false; // Reset flag to allow reload
    await loadAIAnalytics();
  }

  /// Limpia el estado
  void clearState() {
    state = const AnalyticsState.initial();
  }
}

// Providers
final analyticsApiServiceProvider = Provider<AnalyticsApiService>((ref) {
  return AnalyticsApiService();
});

final analyticsNotifierProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final apiService = ref.watch(analyticsApiServiceProvider);
  return AnalyticsNotifier(apiService, ref);
});

// Provider para obtener solo los datos cuando están cargados
final analyticsDataProvider = Provider<AnalyticsEntity?>((ref) {
  final state = ref.watch(analyticsNotifierProvider);
  return state.maybeWhen(
    loaded: (analytics) => analytics,
    orElse: () => null,
  );
});

// Bandera para mostrar indicadores mientras se genera el análisis IA
final aiLoadingProvider = StateProvider<bool>((ref) => false);
