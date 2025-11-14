import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _useWebView = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..setLooping(true)
        ..setVolume(0.0);
      
      _controller!.addListener(() {
        if (_controller!.value.isInitialized && mounted) {
          setState(() {
            _isInitialized = true;
            _hasError = false;
          });
        }
      });

      await _controller!.initialize().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );
      
      // Seek to first frame
      await _controller!.seekTo(Duration.zero);
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      print('Error initializing video thumbnail: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _hasError = true;
          _useWebView = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError && _useWebView) {
      return _buildInlineWebView();
    } else if (_hasError) {
      return _buildErrorPlaceholder();
    }
    
    if (!_isInitialized || _controller == null) {
      return _buildLoadingPlaceholder();
    }
    
    return _buildVideoThumbnail();
  }

  Widget _buildInlineWebView() {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      child: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString('<html><head><meta name="viewport" content="width=device-width, initial-scale=1"/></head><body style="margin:0;background:#000"><video src="${Uri.encodeFull(widget.videoUrl)}" controls autoplay muted playsinline style="width:100%;height:100%;object-fit:cover"></video></body></html>'),
      ),
    );
  }

  Widget _buildVideoThumbnail() {
    return Stack(
      children: [
        // Video thumbnail
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        
        // Play button overlay
        Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        
        // Reel indicator
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF833AB4), Color(0xFFE1306C)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'REEL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1F1F), Color(0xFF2D2D2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
            SizedBox(height: 8),
            Text(
              'Cargando...',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFFD1D1D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: 28,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Icon(
              Icons.video_library,
              color: Colors.white,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}
