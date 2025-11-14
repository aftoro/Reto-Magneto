import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';

class AnalyticsStreamState {
  final bool isStreaming;
  final String statusMessage;
  final String bufferText;
  final Map<String, dynamic>? parsedJson;
  final Map<String, dynamic>? analyticsBase; // deprecado: ya no se envía por SSE
  final String? errorMessage;

  const AnalyticsStreamState({
    required this.isStreaming,
    required this.statusMessage,
    required this.bufferText,
    required this.parsedJson,
    required this.analyticsBase,
    required this.errorMessage,
  });

  factory AnalyticsStreamState.initial() => const AnalyticsStreamState(
        isStreaming: false,
        statusMessage: '',
        bufferText: '',
        parsedJson: null,
        analyticsBase: null,
        errorMessage: null,
      );

  AnalyticsStreamState copyWith({
    bool? isStreaming,
    String? statusMessage,
    String? bufferText,
    Map<String, dynamic>? parsedJson,
    Map<String, dynamic>? analyticsBase,
    String? errorMessage,
  }) {
    return AnalyticsStreamState(
      isStreaming: isStreaming ?? this.isStreaming,
      statusMessage: statusMessage ?? this.statusMessage,
      bufferText: bufferText ?? this.bufferText,
      parsedJson: parsedJson ?? this.parsedJson,
      analyticsBase: analyticsBase ?? this.analyticsBase,
      errorMessage: errorMessage,
    );
  }
}

class AnalyticsStreamNotifier extends StateNotifier<AnalyticsStreamState> {
  AnalyticsStreamNotifier() : super(AnalyticsStreamState.initial());

  http.Client? _client;
  StreamSubscription<List<int>>? _subscription;
  final String _endpoint = '${ApiConfig.baseUrl}/analytics/ai-insights/stream';

  Future<void> start() async {
    if (state.isStreaming) return;
    _client = http.Client();
    state = state.copyWith(
      isStreaming: true,
      statusMessage: 'Conectando...',
      bufferText: '',
      parsedJson: null,
      errorMessage: null,
    );

    try {
      final request = http.Request('GET', Uri.parse(_endpoint));
      request.headers.addAll(ApiConfig.defaultHeaders);
      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        throw Exception('SSE status ${response.statusCode}');
      }

      final utf8Decoder = utf8.decoder;
      final lineSplitter = const LineSplitter();
      String carryOver = '';

      _subscription = response.stream.listen((chunk) {
        final text = utf8Decoder.convert(chunk);
        final combined = carryOver + text;
        final lines = lineSplitter.convert(combined);

        // Si el texto termina con \n, no queda fragmento; si no, guardar el residuo
        final endsWithNewline = combined.endsWith('\n');
        carryOver = endsWithNewline ? '' : lines.removeLast();

        for (final line in lines) {
          if (!line.startsWith('data:')) continue;
          final payload = line.replaceFirst('data: ', '').trim();
          if (payload.isEmpty) continue;
          try {
            final event = json.decode(payload) as Map<String, dynamic>;
            final type = event['type'] as String?;
            if (type == 'status') {
              state = state.copyWith(statusMessage: (event['message'] ?? '').toString());
            } else if (type == 'delta') {
              final delta = (event['text'] ?? '').toString();
              if (delta.isNotEmpty) {
                state = state.copyWith(bufferText: state.bufferText + delta);
              }
            } else if (type == 'done') {
              final fullText = (event['fullText'] ?? '').toString();
              final parsed = event['json'] is Map<String, dynamic>
                  ? event['json'] as Map<String, dynamic>
                  : null;
              state = state.copyWith(
                bufferText: fullText.isNotEmpty ? fullText : state.bufferText,
                parsedJson: parsed,
                statusMessage: 'Completado',
              );
              stop();
            } else if (type == 'error') {
              state = state.copyWith(errorMessage: (event['message'] ?? '').toString());
              stop();
            }
          } catch (_) {
            // Ignorar líneas no JSON
          }
        }
      }, onError: (e) {
        state = state.copyWith(errorMessage: e.toString());
        stop();
      }, onDone: () {
        stop();
      }, cancelOnError: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      stop();
    }
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _client?.close();
    _client = null;
    state = state.copyWith(isStreaming: false);
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

final analyticsStreamProvider =
    StateNotifierProvider<AnalyticsStreamNotifier, AnalyticsStreamState>((ref) {
  return AnalyticsStreamNotifier();
});


