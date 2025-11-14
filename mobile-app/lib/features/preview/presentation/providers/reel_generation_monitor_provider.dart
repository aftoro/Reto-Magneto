import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/preview_api_service.dart';
import '../../data/models/preview_entity.dart';

/// Estados del monitoreo de generación de reels
class ReelGenerationState {
  final String? topic;
  final int progress;
  final PreviewEntity? completedPreview;
  final String? error;
  final bool isGenerating;

  const ReelGenerationState({
    this.topic,
    this.progress = 0,
    this.completedPreview,
    this.error,
    this.isGenerating = false,
  });

  const ReelGenerationState.idle() : this();
  
  const ReelGenerationState.generating({
    required String topic,
    required int progress,
  }) : this(
    topic: topic,
    progress: progress,
    isGenerating: true,
  );
  
  const ReelGenerationState.completed({
    required PreviewEntity preview,
  }) : this(
    completedPreview: preview,
  );
  
  const ReelGenerationState.error(String message) : this(
    error: message,
  );
}

/// Provider para monitorear reels en generación globalmente
class ReelGenerationMonitor extends StateNotifier<ReelGenerationState> {
  final PreviewApiService _apiService;
  Timer? _monitoringTimer;
  String? _currentTopic;
  DateTime? _searchStartTime;
  int _attempts = 0;

  ReelGenerationMonitor(this._apiService) : super(const ReelGenerationState.idle());

  /// Iniciar monitoreo de un reel en generación
  void startMonitoring(String topic) {
    _currentTopic = topic;
    _searchStartTime = DateTime.now();
    _attempts = 0;
    state = ReelGenerationState.generating(
      topic: topic,
      progress: 0,
    );
    
    _monitoringTimer?.cancel();
    _monitoringTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      _attempts++;
      await _checkForCompletedReel();
    });
  }

  /// Detener monitoreo
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _currentTopic = null;
    _searchStartTime = null;
    _attempts = 0;
    state = const ReelGenerationState.idle();
  }

  /// Verificar si hay un reel completado
  Future<void> _checkForCompletedReel() async {
    if (_currentTopic == null || _searchStartTime == null) return;

    try {
      // Buscar previews recientes de tipo reel
      final previewsResponse = await _apiService.getPreviews(
        type: 'reel',
        limit: 10,
      );

      // Buscar el preview que coincida con el tema y sea reciente
      PreviewEntity? matchingPreview;
      try {
        matchingPreview = previewsResponse.previews.firstWhere(
          (p) => p.topic.toLowerCase().contains(_currentTopic!.toLowerCase()) &&
                 p.status == 'draft' &&
                 p.createdAt.isAfter(_searchStartTime!),
        );
      } catch (e) {
        matchingPreview = null;
      }

      // Calcular progreso aproximado (máximo 90% hasta que esté listo)
      final progress = (_attempts * 5).clamp(0, 90);

      if (matchingPreview != null) {
        // Reel está listo
        stopMonitoring();
        state = ReelGenerationState.completed(
          preview: matchingPreview,
        );
      } else if (_attempts > 60) {
        // Timeout después de 10 minutos
        stopMonitoring();
        state = const ReelGenerationState.error('Tiempo de espera agotado');
      } else {
        // Actualizar progreso
        state = ReelGenerationState.generating(
          topic: _currentTopic!,
          progress: progress,
        );
      }
    } catch (e) {
      print('⚠️ Error verificando reel en generación: $e');
      // Continuar monitoreando aunque haya error temporal
    }
  }

  @override
  void dispose() {
    _monitoringTimer?.cancel();
    super.dispose();
  }
}

// Provider
final reelGenerationMonitorProvider = StateNotifierProvider<ReelGenerationMonitor, ReelGenerationState>((ref) {
  final apiService = PreviewApiService();
  return ReelGenerationMonitor(apiService);
});

