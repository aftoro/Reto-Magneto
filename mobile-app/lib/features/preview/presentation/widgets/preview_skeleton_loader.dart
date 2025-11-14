import 'package:flutter/material.dart';
import 'dart:math' as math;

class PreviewSkeletonLoader extends StatefulWidget {
  final String? type; // 'post', 'story', 'reel'
  
  const PreviewSkeletonLoader({
    super.key,
    this.type,
  });

  @override
  State<PreviewSkeletonLoader> createState() => _PreviewSkeletonLoaderState();
}

class _PreviewSkeletonLoaderState extends State<PreviewSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para light mode
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB), // Borde gris claro
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05), // Sombra suave para light mode
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton de imagen (parte superior expandida)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _ShimmerEffect(
                    controller: _shimmerController,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Skeleton de contenido (parte inferior)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skeleton de tipo y estado
                    Row(
                      children: [
                        _ShimmerEffect(
                          controller: _shimmerController,
                          child: Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Spacer(),
                        _ShimmerEffect(
                          controller: _shimmerController,
                          child: Container(
                            width: 70,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Skeleton de topic (líneas de texto)
                    _ShimmerEffect(
                      controller: _shimmerController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 200,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Skeleton de fecha
                    _ShimmerEffect(
                      controller: _shimmerController,
                      child: Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  final AnimationController controller;
  final Widget child;

  const _ShimmerEffect({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final progress = controller.value;
            final gradient = LinearGradient(
              colors: const [
                Color(0xFFF3F4F6), // Base color
                Colors.white, // Highlight color
                Color(0xFFF3F4F6), // Base color
              ],
              stops: [
                math.max(0.0, progress - 0.3),
                progress,
                math.min(1.0, progress + 0.3),
              ],
            );
            return gradient.createShader(bounds);
          },
          child: this.child,
        );
      },
      child: child,
    );
  }
}
