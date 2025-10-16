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

  AnalyticsNotifier(this._apiService) : super(const AnalyticsState.initial());

  /// Carga estadísticas con análisis de IA
  Future<void> loadAIAnalytics() async {
    state = const AnalyticsState.loading();
    
    try {
      final response = await _apiService.getAIAnalytics();
      if (response.success) {
        state = AnalyticsState.loaded(response.analytics);
      } else {
        state = AnalyticsState.error('Error al cargar estadísticas: ${response.message}');
      }
    } catch (e) {
      state = AnalyticsState.error('Error de conexión: $e');
    }
  }

  /// Carga estadísticas básicas
  Future<void> loadBasicAnalytics() async {
    state = const AnalyticsState.loading();
    
    try {
      final response = await _apiService.getBasicAnalytics();
      if (response.success) {
        state = AnalyticsState.loaded(response.analytics);
      } else {
        state = AnalyticsState.error('Error al cargar estadísticas: ${response.message}');
      }
    } catch (e) {
      state = AnalyticsState.error('Error de conexión: $e');
    }
  }

  /// Refresca las estadísticas
  Future<void> refreshAnalytics() async {
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
  return AnalyticsNotifier(apiService);
});

// Provider para obtener solo los datos cuando están cargados
final analyticsDataProvider = Provider<AnalyticsEntity?>((ref) {
  final state = ref.watch(analyticsNotifierProvider);
  return state.maybeWhen(
    loaded: (analytics) => analytics,
    orElse: () => null,
  );
});
