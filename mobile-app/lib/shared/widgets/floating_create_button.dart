import 'package:flutter/material.dart';

class FloatingCreateButton extends StatefulWidget {
  final Function(String) onItemSelected;

  const FloatingCreateButton({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<FloatingCreateButton> createState() => _FloatingCreateButtonState();
}

class _FloatingCreateButtonState extends State<FloatingCreateButton>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  AnimationController? _animationController;
  Animation<double>? _postButtonAnimation;
  Animation<double>? _storyButtonAnimation;
  Animation<double>? _reelButtonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _postButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _storyButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _reelButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
  }

  void _selectItem(String item) {
    _toggleMenu();
    widget.onItemSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Menu Items - Above the main button
        if (_isExpanded) ...[
          AnimatedBuilder(
            animation: _postButtonAnimation ?? const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.scale(
                scale: _postButtonAnimation?.value ?? 0.0,
                child: Opacity(
                  opacity: _postButtonAnimation?.value ?? 0.0,
                  child: _buildFloatingMenuItem(
                    icon: Icons.add_photo_alternate,
                    tooltip: 'Crear Post',
                    color: const Color(0xFF3B82F6),
                    onTap: () => _selectItem('post'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _storyButtonAnimation ?? const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.scale(
                scale: _storyButtonAnimation?.value ?? 0.0,
                child: Opacity(
                  opacity: _storyButtonAnimation?.value ?? 0.0,
                  child: _buildFloatingMenuItem(
                    icon: Icons.auto_stories,
                    tooltip: 'Crear Story',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => _selectItem('story'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _reelButtonAnimation ?? const AlwaysStoppedAnimation(0.0),
            builder: (context, child) {
              return Transform.scale(
                scale: _reelButtonAnimation?.value ?? 0.0,
                child: Opacity(
                  opacity: _reelButtonAnimation?.value ?? 0.0,
                  child: _buildFloatingMenuItem(
                    icon: Icons.video_library,
                    tooltip: 'Crear Reel',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => _selectItem('reel'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        
        // Main Floating Button
        GestureDetector(
          onTap: _toggleMenu,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _isExpanded ? Icons.close : Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingMenuItem({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
      ),
      textStyle: const TextStyle(
        color: Color(0xFFE5E7EB),
        fontSize: 12,
      ),
      preferBelow: false,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}