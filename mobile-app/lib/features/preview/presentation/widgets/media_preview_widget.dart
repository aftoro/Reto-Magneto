import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../pages/video_player_page.dart';

class MediaPreviewWidget extends StatefulWidget {
  final String mediaUrl;
  final Function(Map<String, dynamic>)? onVisualSelection;
  final List<Map<String, dynamic>>? visualSelections;
  final double aspectRatio;

  const MediaPreviewWidget({
    super.key,
    required this.mediaUrl,
    this.onVisualSelection,
    this.visualSelections,
    this.aspectRatio = 1.0,
  });

  @override
  State<MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  
  bool _isSelecting = false;
  Offset? _selectionStart;
  Offset? _selectionEnd;
  
  // Video detection and thumbnail
  bool _isVideo = false;
  VideoPlayerController? _thumbnailController;
  bool _isThumbnailReady = false;
  bool _thumbnailError = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController.repeat(reverse: true);
    
    // Detectar si es video
    _detectMediaType();
  }

  void _detectMediaType() {
    final url = widget.mediaUrl.toLowerCase();
    if (url.contains('.mp4') || url.contains('.mov') || url.contains('.avi') || url.contains('.webm')) {
      print('DEBUG: Detected video file: $url');
      _isVideo = true;
      _initializeVideoThumbnail();
    } else {
      print('DEBUG: Detected image file: $url');
      _isVideo = false;
    }
  }

  Future<void> _initializeVideoThumbnail() async {
    try {
      print('DEBUG: Initializing video thumbnail for: ${widget.mediaUrl}');
      _thumbnailController = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl));
      
      _thumbnailController!.addListener(() {
        if (_thumbnailController!.value.isInitialized && mounted) {
          setState(() {
            _isThumbnailReady = true;
            _thumbnailError = false;
          });
        }
      });

      // Add timeout to prevent infinite loading
      await _thumbnailController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('WARNING: Video thumbnail initialization timeout');
          throw Exception('Video thumbnail timeout');
        },
      );
      
      // Seek to first frame (0 seconds) to get thumbnail
      await _thumbnailController!.seekTo(Duration.zero);
      
      if (mounted) {
        setState(() {
          _isThumbnailReady = true;
          _thumbnailError = false;
        });
      }
    } catch (e) {
      print('ERROR: Failed to initialize video thumbnail: $e');
      // Continue with placeholder if thumbnail fails
      if (mounted) {
        setState(() {
          _isThumbnailReady = false;
          _thumbnailError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _thumbnailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: _isVideo ? _buildVideoPreview() : _buildImagePreview(),
        ),
      ),
    );
  }

          Widget _buildVideoPreview() {
            return GestureDetector(
              onTap: _openVideoInBrowser,
              child: Container(
                color: Colors.grey[900],
                child: Stack(
                  children: [
                    // Video thumbnail or placeholder
                    if (_isThumbnailReady && _thumbnailController != null && !_thumbnailError)
                      // Real video thumbnail
                      Center(
                        child: AspectRatio(
                          aspectRatio: _thumbnailController!.value.aspectRatio,
                          child: VideoPlayer(_thumbnailController!),
                        ),
                      )
                    else
                      // Loading, error, or placeholder
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_thumbnailError)
                              // Error state
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )
                            else if (!_isThumbnailReady)
                              // Loading state
                              const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            else
                              // Fallback placeholder
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              _thumbnailError 
                                ? 'Error al cargar' 
                                : _isThumbnailReady 
                                  ? 'Video' 
                                  : 'Cargando...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_isThumbnailReady && !_thumbnailError) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'Toca para reproducir',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                    // Play button overlay (only when thumbnail is ready and no error)
                    if (_isThumbnailReady && !_thumbnailError)
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        // Image
        Image.network(
          widget.mediaUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cargando imagen...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('ERROR: Failed to load image: $error');
            print('ERROR: Image URL: ${widget.mediaUrl}');
            
            return Container(
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Imagen no disponible',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Error: ${error.toString().split(':').first}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        // Visual selection tools (only for images)
        if (widget.onVisualSelection != null && widget.visualSelections != null)
          ..._buildVisualSelectionTools(),
      ],
    );
  }

  Future<void> _openVideoInBrowser() async {
    try {
      print('DEBUG: Opening video in custom page: ${widget.mediaUrl}');
      
      // Navigate to custom video player page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(
              videoUrl: widget.mediaUrl,
              title: 'Video Preview',
            ),
          ),
        );
      }
    } catch (e) {
      print('ERROR: Failed to open video: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir video: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  List<Widget> _buildVisualSelectionTools() {
    return [
      // Selection overlay
      if (_selectionStart != null && _selectionEnd != null)
        Positioned.fill(
          child: CustomPaint(
            painter: SelectionPainter(
              start: _selectionStart!,
              end: _selectionEnd!,
              selections: widget.visualSelections!,
            ),
          ),
        ),
      
      // Selection gesture detector
      Positioned.fill(
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isSelecting = true;
              _selectionStart = details.localPosition;
              _selectionEnd = details.localPosition;
            });
          },
          onPanUpdate: (details) {
            if (_isSelecting) {
              setState(() {
                _selectionEnd = details.localPosition;
              });
            }
          },
          onPanEnd: (details) {
            if (_isSelecting && _selectionStart != null && _selectionEnd != null) {
              _finalizeSelection();
            }
            setState(() {
              _isSelecting = false;
            });
          },
        ),
      ),
    ];
  }

  void _finalizeSelection() {
    if (_selectionStart == null || _selectionEnd == null) return;
    
    final selection = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'start': {
        'x': _selectionStart!.dx,
        'y': _selectionStart!.dy,
      },
      'end': {
        'x': _selectionEnd!.dx,
        'y': _selectionEnd!.dy,
      },
      'type': 'rectangle',
    };
    
    widget.onVisualSelection?.call(selection);
    
    setState(() {
      _selectionStart = null;
      _selectionEnd = null;
    });
  }
}

class SelectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final List<Map<String, dynamic>> selections;

  SelectionPainter({
    required this.start,
    required this.end,
    required this.selections,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw current selection
    final rect = Rect.fromPoints(start, end);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, borderPaint);

    // Draw existing selections
    for (final selection in selections) {
      final selectionStart = Offset(
        (selection['start']['x'] as num).toDouble(),
        (selection['start']['y'] as num).toDouble(),
      );
      final selectionEnd = Offset(
        (selection['end']['x'] as num).toDouble(),
        (selection['end']['y'] as num).toDouble(),
      );
      
      final selectionRect = Rect.fromPoints(selectionStart, selectionEnd);
      canvas.drawRect(selectionRect, paint);
      canvas.drawRect(selectionRect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}