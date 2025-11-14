import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';

/// Eventos que pueden recibirse del stream
enum PreviewStreamEvent {
  start,
  captions,
  media,
  suggestions,
  status,
  preview_saved,
  preview_created,
  done,
  error,
}

/// Modelo para eventos del stream
class PreviewStreamData {
  final PreviewStreamEvent event;
  final Map<String, dynamic> data;

  PreviewStreamData({
    required this.event,
    required this.data,
  });

  factory PreviewStreamData.fromJson(String eventType, Map<String, dynamic> json) {
    PreviewStreamEvent event;
    switch (eventType) {
      case 'start':
        event = PreviewStreamEvent.start;
        break;
      case 'captions':
        event = PreviewStreamEvent.captions;
        break;
      case 'media':
        event = PreviewStreamEvent.media;
        break;
      case 'suggestions':
        event = PreviewStreamEvent.suggestions;
        break;
      case 'status':
        event = PreviewStreamEvent.status;
        break;
      case 'preview_saved':
        event = PreviewStreamEvent.preview_saved;
        break;
      case 'preview_created':
        event = PreviewStreamEvent.preview_created;
        break;
      case 'done':
        event = PreviewStreamEvent.done;
        break;
      case 'error':
        event = PreviewStreamEvent.error;
        break;
      default:
        event = PreviewStreamEvent.status;
    }
    return PreviewStreamData(event: event, data: json);
  }
}

/// Servicio para manejar streaming de previews
class PreviewStreamService {
  StreamSubscription<PreviewStreamData>? _subscription;
  http.Client? _client;
  StreamController<PreviewStreamData>? _controller;

  /// Iniciar stream de preview
  Stream<PreviewStreamData> createPreviewStream({
    required String type,
    required String topic,
    String? style,
    String? targetAudience,
    String? accent,
    int? duration,
    String? referenceImagePath,
  }) async* {
    _controller = StreamController<PreviewStreamData>.broadcast();
    _client = http.Client();

    try {
      // Construir URL base (sin /api)
      final urlWithoutApi = ApiConfig.baseUrl.replaceAll('/api', '');
      final uri = Uri.parse('$urlWithoutApi/generate/preview/stream');

      // Construir request
      final request = http.MultipartRequest('POST', uri);
      
      // Agregar headers
      request.headers.addAll(ApiConfig.defaultHeaders);
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';

      // Agregar campos
      request.fields['type'] = type;
      request.fields['prompt'] = topic;
      request.fields['topic'] = topic;
      if (style != null) request.fields['style'] = style;
      if (targetAudience != null) request.fields['target_audience'] = targetAudience;
      if (accent != null) request.fields['accent'] = accent;
      if (duration != null) request.fields['duration'] = duration.toString();

      // Agregar imagen si existe
      if (referenceImagePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', referenceImagePath),
        );
      }

      // Enviar request
      final streamedResponse = await _client!.send(request);

      if (streamedResponse.statusCode != 200) {
        final errorBody = await streamedResponse.stream.bytesToString();
        yield PreviewStreamData(
          event: PreviewStreamEvent.error,
          data: {'message': 'Error HTTP ${streamedResponse.statusCode}: $errorBody'},
        );
        return;
      }

      // Procesar stream SSE
      String buffer = '';
      String? currentEvent;

      await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;
        final lines = buffer.split('\n');
        
        // Mantener la última línea incompleta en el buffer
        if (lines.isNotEmpty && !buffer.endsWith('\n')) {
          buffer = lines.removeLast();
        } else {
          buffer = '';
        }

        for (final line in lines) {
          final trimmedLine = line.trim();
          if (trimmedLine.isEmpty) continue;

          if (trimmedLine.startsWith('event: ')) {
            currentEvent = trimmedLine.substring(7).trim();
          } else if (trimmedLine.startsWith('data: ')) {
            final jsonData = trimmedLine.substring(6).trim();
            if (jsonData.isNotEmpty) {
              try {
                final json = jsonDecode(jsonData) as Map<String, dynamic>;
                final eventType = currentEvent ?? 'status';
                yield PreviewStreamData.fromJson(eventType, json);
              } catch (e) {
                print('Error parsing SSE data: $e');
                print('Data: $jsonData');
              }
            }
            currentEvent = null;
          }
        }
      }
    } catch (e) {
      yield PreviewStreamData(
        event: PreviewStreamEvent.error,
        data: {'message': e.toString()},
      );
    } finally {
      await _controller?.close();
      _client?.close();
    }
  }

  /// Cancelar stream
  void cancel() {
    _subscription?.cancel();
    _controller?.close();
    _client?.close();
    _subscription = null;
    _controller = null;
    _client = null;
  }
}

