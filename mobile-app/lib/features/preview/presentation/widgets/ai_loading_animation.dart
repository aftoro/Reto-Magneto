import 'package:flutter/material.dart';
import 'dart:math' as math;

class AILoadingAnimation extends StatefulWidget {
  final String? message;
  final double size;
  
  const AILoadingAnimation({
    super.key,
    this.message,
    this.size = 200.0,
  });

  @override
  State<AILoadingAnimation> createState() => _AILoadingAnimationState();
}

class _AILoadingAnimationState extends State<AILoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _textController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Rotation animation controller
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));
    
    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main AI Brain Animation
          AnimatedBuilder(
            animation: Listenable.merge([
              _mainController,
              _pulseController,
              _rotateController,
            ]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulse rings
                      ...List.generate(3, (index) {
                        final delay = index * 0.3;
                        final animationValue = (_pulseAnimation.value + delay) % 1.0;
                        final opacity = (1.0 - animationValue) * 0.6;
                        final scale = 0.5 + (animationValue * 1.5);
                        
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: widget.size,
                            height: widget.size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF3B82F6).withOpacity(opacity),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }),
                      
                      // Main brain container
                      Container(
                        width: widget.size * 0.6,
                        height: widget.size * 0.6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF3B82F6),
                              Color(0xFF1E40AF),
                              Color(0xFF8B5CF6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rotating neural network
                            Transform.rotate(
                              angle: _rotateAnimation.value,
                              child: CustomPaint(
                                size: Size(widget.size * 0.4, widget.size * 0.4),
                                painter: NeuralNetworkPainter(),
                              ),
                            ),
                            
                            // Central AI icon
                            Transform.scale(
                              scale: 0.8 + (0.2 * math.sin(_mainController.value * 2 * math.pi)),
                              child: const Icon(
                                Icons.psychology,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Floating particles
                      ...List.generate(8, (index) {
                        final angle = (index * 45) * (math.pi / 180);
                        final radius = widget.size * 0.4;
                        final x = math.cos(angle + _rotateAnimation.value) * radius;
                        final y = math.sin(angle + _rotateAnimation.value) * radius;
                        
                        return Positioned(
                          left: (widget.size / 2) + x - 4,
                          top: (widget.size / 2) + y - 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Loading text with animation
          AnimatedBuilder(
            animation: Listenable.merge([
              _textOpacityAnimation,
              _textSlideAnimation,
            ]),
            builder: (context, child) {
              return SlideTransition(
                position: _textSlideAnimation,
                child: Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        widget.message ?? 'La IA está generando tu contenido...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Analizando tendencias y creando algo increíble',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Progress dots
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final delay = index * 0.2;
                  final animationValue = (_textController.value + delay) % 1.0;
                  final opacity = math.sin(animationValue * math.pi);
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(opacity),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NeuralNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Draw neural network connections
    for (int i = 0; i < 8; i++) {
      final angle1 = (i * 45) * (math.pi / 180);
      final angle2 = ((i + 2) * 45) * (math.pi / 180);
      
      final point1 = Offset(
        center.dx + math.cos(angle1) * radius,
        center.dy + math.sin(angle1) * radius,
      );
      
      final point2 = Offset(
        center.dx + math.cos(angle2) * radius,
        center.dy + math.sin(angle2) * radius,
      );
      
      canvas.drawLine(point1, point2, paint);
    }

    // Draw nodes
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      
      canvas.drawCircle(point, 3, Paint()..color = Colors.white.withOpacity(0.6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
