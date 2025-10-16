import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImagePreviewWidget extends StatefulWidget {
  final String imageUrl;
  final Function(Map<String, dynamic>) onVisualSelection;
  final List<Map<String, dynamic>> visualSelections;
  final double aspectRatio;

  const ImagePreviewWidget({
    super.key,
    required this.imageUrl,
    required this.onVisualSelection,
    required this.visualSelections,
    this.aspectRatio = 1.0,
  });

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _isSelecting = false;
  Offset? _selectionStart;
  Offset? _selectionEnd;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ImagePreviewWidget - Image URL: ${widget.imageUrl}');
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onTap: () => _onTap(),
            child: Stack(
              children: [
                // Main Image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      print('Loading progress: $loadingProgress');
                      if (loadingProgress == null) {
                        print('Image loaded successfully');
                        return child;
                      }
                      return Container(
                        color: const Color(0xFF2D2D2D),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Cargando imagen...',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Image load error: $error');
                      print('Stack trace: $stackTrace');
                      return Container(
                        color: const Color(0xFF2D2D2D),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error al cargar imagen',
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'URL: ${widget.imageUrl}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Selection Overlay
                if (_isSelecting && _selectionStart != null && _selectionEnd != null)
                  _buildSelectionOverlay(),
                
                // Existing Selections
                ...widget.visualSelections.map((selection) => _buildExistingSelection(selection)),
                
                // Tools Overlay
                _buildToolsOverlay(),
                
                // Selection Mode Indicator
                if (_isSelecting)
                  _buildSelectionModeIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOverlay() {
    if (_selectionStart == null || _selectionEnd == null) return const SizedBox.shrink();
    
    final selection = Rect.fromPoints(_selectionStart!, _selectionEnd!);
    
    return Positioned.fill(
      child: CustomPaint(
        painter: SelectionPainter(
          selection: selection,
          isActive: true,
        ),
      ),
    );
  }

  Widget _buildExistingSelection(Map<String, dynamic> selection) {
    final rect = selection['rect'] as Rect;
    final isActive = selection['isActive'] as bool? ?? false;
    
    return Positioned.fill(
      child: CustomPaint(
        painter: SelectionPainter(
          selection: rect,
          isActive: isActive,
          color: selection['color'] as Color?,
        ),
      ),
    );
  }

  Widget _buildToolsOverlay() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          _buildToolButton(
            icon: Icons.crop_free,
            label: 'Seleccionar',
            isActive: _isSelecting,
            onTap: _toggleSelectionMode,
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            icon: Icons.zoom_in,
            label: 'Zoom',
            onTap: () {}, // TODO: Implement zoom
          ),
          const SizedBox(height: 8),
          _buildToolButton(
            icon: Icons.rotate_right,
            label: 'Rotar',
            onTap: _rotateImage,
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3B82F6) : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionModeIndicator() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: const Icon(
                    Icons.touch_app,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Arrastra para seleccionar un área',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: _cancelSelection,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isSelecting) return;
    
    setState(() {
      _selectionStart = details.localPosition;
      _selectionEnd = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isSelecting || _selectionStart == null) return;
    
    setState(() {
      _selectionEnd = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isSelecting || _selectionStart == null || _selectionEnd == null) return;
    
    final selection = Rect.fromPoints(_selectionStart!, _selectionEnd!);
    
    if (selection.width > 20 && selection.height > 20) {
      _showSelectionMenu(selection);
    }
    
    setState(() {
      _selectionStart = null;
      _selectionEnd = null;
    });
  }

  void _onTap() {
    if (_isSelecting) {
      setState(() {
        _isSelecting = false;
        _selectionStart = null;
        _selectionEnd = null;
      });
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelecting = !_isSelecting;
      if (!_isSelecting) {
        _selectionStart = null;
        _selectionEnd = null;
      }
    });
  }


  void _rotateImage() {
    // TODO: Implement image rotation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rotación de imagen próximamente'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _selectionStart = null;
      _selectionEnd = null;
    });
  }

  void _showSelectionMenu(Rect selection) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Qué quieres hacer con esta área?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSelectionAction(
                    icon: Icons.text_fields,
                    label: 'Modificar Texto',
                    onTap: () => _handleSelectionAction('text', selection),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSelectionAction(
                    icon: Icons.palette,
                    label: 'Cambiar Color',
                    onTap: () => _handleSelectionAction('color', selection),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSelectionAction(
                    icon: Icons.aspect_ratio,
                    label: 'Cambiar Tamaño',
                    onTap: () => _handleSelectionAction('size', selection),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSelectionAction(
                    icon: Icons.add,
                    label: 'Agregar Elemento',
                    onTap: () => _handleSelectionAction('add', selection),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3B82F6),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSelectionAction(String action, Rect selection) {
    Navigator.pop(context); // Close bottom sheet
    
    final selectionData = {
      'action': action,
      'rect': selection,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'color': _getRandomColor(),
    };
    
    widget.onVisualSelection(selectionData);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Acción "$action" aplicada al área seleccionada'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];
    return colors[math.Random().nextInt(colors.length)];
  }
}

class SelectionPainter extends CustomPainter {
  final Rect selection;
  final bool isActive;
  final Color? color;

  SelectionPainter({
    required this.selection,
    required this.isActive,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (color ?? const Color(0xFF3B82F6)).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color ?? const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw selection rectangle
    canvas.drawRect(selection, paint);
    canvas.drawRect(selection, borderPaint);

    // Draw corner handles
    final handleSize = 8.0;
    final handles = [
      selection.topLeft,
      selection.topRight,
      selection.bottomLeft,
      selection.bottomRight,
      Offset(selection.center.dx, selection.top),
      Offset(selection.center.dx, selection.bottom),
      Offset(selection.left, selection.center.dy),
      Offset(selection.right, selection.center.dy),
    ];

    for (final handle in handles) {
      canvas.drawCircle(handle, handleSize, borderPaint);
      canvas.drawCircle(handle, handleSize - 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
