import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/preview_entity.dart';
import '../providers/preview_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/media_preview_widget.dart';

class ReelPreviewPage extends ConsumerStatefulWidget {
  final PreviewEntity preview;

  const ReelPreviewPage({
    super.key,
    required this.preview,
  });

  @override
  ConsumerState<ReelPreviewPage> createState() => _ReelPreviewPageState();
}

class _ReelPreviewPageState extends ConsumerState<ReelPreviewPage> {
  VideoPlayerController? _controller;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.preview.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.preview.videoUrl!));
      await _controller!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Preview del Reel',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _cancelReel,
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video preview
          Expanded(
            flex: 3,
            child: MediaPreviewWidget(
              mediaUrl: widget.preview.videoUrl ?? widget.preview.previewImage,
              aspectRatio: 9/16, // Aspect ratio típico de reels
            ),
          ),
          
          // Información del reel
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema: ${widget.preview.topic}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Caption sugerido:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.preview.caption,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isPublishing ? null : _cancelReel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'CANCELAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isPublishing ? null : _publishReel,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF8B5CF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isPublishing
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'PUBLICAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _cancelReel() {
    Navigator.pop(context, false); // Volver sin publicar
  }

  Future<void> _publishReel() async {
    setState(() => _isPublishing = true);

    try {
      final request = PublishPreviewRequest(
        finalCaption: widget.preview.caption,
      );

      await ref.read(previewDetailsProvider.notifier).publishPreview(
        widget.preview.id,
        request,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reel publicado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to main app
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/main-app',
          (route) => false,
          arguments: {'initialIndex': 2}, // Posts tab
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al publicar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPublishing = false);
      }
    }
  }
}
