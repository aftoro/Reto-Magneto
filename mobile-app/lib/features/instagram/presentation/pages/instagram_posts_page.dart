import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/video_thumbnail_widget.dart';
import '../../data/models/instagram_post_entity.dart';
import '../providers/instagram_posts_provider.dart';
import 'instagram_comments_page.dart';

class InstagramPostsPage extends ConsumerStatefulWidget {
  const InstagramPostsPage({super.key});

  @override
  ConsumerState<InstagramPostsPage> createState() => _InstagramPostsPageState();
}

class _InstagramPostsPageState extends ConsumerState<InstagramPostsPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Cargar posts solo si no se han cargado antes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instagramPostsNotifierProvider.notifier).loadPostsIfNeeded();
    });
  }

  List<InstagramPostEntity> _getDemoPosts() {
    return [
      InstagramPostEntity(
        id: 'demo-post-1',
        mediaId: 'demo_media_1',
        instagramPostId: 'demo_ig_1',
        mediaType: 'IMAGE',
        imageUrl: 'https://picsum.photos/400/400?random=1',
        mediaUrl: 'https://picsum.photos/400/400?random=1',
        caption: '¡Estamos contratando! 🚀 Buscamos desarrolladores Full Stack con experiencia en Flutter y Node.js. Salario competitivo y trabajo remoto. #Empleos #Tech #Desarrollo',
        permalink: 'https://instagram.com/p/demo1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        commentsCount: 15,
        likesCount: 89,
        sharesCount: 12,
      ),
      InstagramPostEntity(
        id: 'demo-post-2',
        mediaId: 'demo_media_2',
        instagramPostId: 'demo_ig_2',
        mediaType: 'VIDEO',
        imageUrl: '',
        mediaUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        caption: 'Publicación con v24.0 #Reel - Descubre las últimas tendencias en tecnología y desarrollo de software. ¡No te pierdas esta oportunidad! #Tech #Innovación #Desarrollo',
        permalink: 'https://instagram.com/p/demo2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        commentsCount: 2,
        likesCount: 45,
        sharesCount: 6,
      ),
      InstagramPostEntity(
        id: 'demo-post-3',
        mediaId: 'demo_media_3',
        instagramPostId: 'demo_ig_3',
        mediaType: 'IMAGE',
        imageUrl: 'https://picsum.photos/400/400?random=3',
        mediaUrl: 'https://picsum.photos/400/400?random=3',
        caption: 'Buscamos Product Manager con experiencia en startups 🎯 Lidera productos innovadores y trabaja con equipos ágiles. ¡Aplica ahora! #ProductManagement #Startup #Innovación',
        permalink: 'https://instagram.com/p/demo3',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        commentsCount: 23,
        likesCount: 156,
        sharesCount: 18,
      ),
      InstagramPostEntity(
        id: 'demo-post-4',
        mediaId: 'demo_media_4',
        instagramPostId: 'demo_ig_4',
        mediaType: 'IMAGE',
        imageUrl: 'https://picsum.photos/400/400?random=4',
        mediaUrl: 'https://picsum.photos/400/400?random=4',
        caption: 'Vacante para Data Scientist 📊 Analiza datos y ayuda a tomar decisiones estratégicas. Conocimiento en Python y Machine Learning requerido. #DataScience #AI #Analytics',
        permalink: 'https://instagram.com/p/demo4',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        commentsCount: 12,
        likesCount: 78,
        sharesCount: 9,
      ),
      InstagramPostEntity(
        id: 'demo-post-5',
        mediaId: 'demo_media_5',
        instagramPostId: 'demo_ig_5',
        mediaType: 'VIDEO',
        imageUrl: '',
        mediaUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        caption: '¡Tu CV, tu pasaporte al éxito! 🚀 ¿Estás listx para dar el siguiente paso en tu carrera? Te ayudamos a destacar entre la multitud. #CV #Carrera #Éxito',
        permalink: 'https://instagram.com/p/demo5',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        commentsCount: 8,
        likesCount: 34,
        sharesCount: 5,
      ),
      InstagramPostEntity(
        id: 'demo-post-6',
        mediaId: 'demo_media_6',
        instagramPostId: 'demo_ig_6',
        mediaType: 'IMAGE',
        imageUrl: 'https://picsum.photos/400/400?random=6',
        mediaUrl: 'https://picsum.photos/400/400?random=6',
        caption: '¡Tu CV es tu carta de presentación! Asegúrate de que refleje tu verdadero potencial. Consejos profesionales para destacar. #CV #Profesional #Consejos',
        permalink: 'https://instagram.com/p/demo6',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        commentsCount: 5,
        likesCount: 28,
        sharesCount: 3,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(instagramPostsNotifierProvider);

    return Column(
      children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco para light mode
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE5E7EB), // Borde gris claro
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: AppConstants.textPrimary, // Texto negro
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar posts...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF), // Gris claro para hint
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: _isSearching 
                        ? AppConstants.primaryColor
                        : const Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                            });
                            ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.trim().isNotEmpty;
                  });
                  if (value.trim().isNotEmpty) {
                    ref.read(instagramPostsNotifierProvider.notifier).searchPosts(query: value);
                  } else {
                    ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                  }
                },
              ),
            ),
          ),
          
          // Posts List
          Expanded(
            child: postsState.when(
              initial: () => const Center(
                child: Text(
                  'Cargando posts...',
                  style: TextStyle(color: AppConstants.textSecondary),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                ),
              ),
              loaded: (posts, pagination) => posts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return _InstagramPostTile(
                          post: post,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InstagramCommentsPage(post: post),
                              ),
                            );
                          },
                        );
                      },
                    ),
              error: (error) => Column(
                children: [
                  // Offline Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Color(0xFFF59E0B),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'API no disponible - Mostrando posts de ejemplo',
                            style: TextStyle(
                              color: Color(0xFFF59E0B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                          },
                          child: const Text(
                            'Reintentar',
                            style: TextStyle(color: Color(0xFFF59E0B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Demo Posts
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _getDemoPosts().length,
                      itemBuilder: (context, index) {
                        final post = _getDemoPosts()[index];
                        return _InstagramPostTile(
                          post: post,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InstagramCommentsPage(post: post),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // Gris claro para light mode
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay posts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Los posts de Instagram aparecerán aquí',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InstagramPostTile extends StatelessWidget {
  final InstagramPostEntity post;
  final VoidCallback onTap;

  const _InstagramPostTile({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Post Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildMediaPreview(post),
                  ),
                ),
                const SizedBox(width: 16),
                // Post Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (_isVideoContent(post)) ...[
                                Container(
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  _truncateText(post.caption, 50),
                                  style: const TextStyle(
                                    color: AppConstants.textPrimary, // Texto negro
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(post.timestamp),
                        style: const TextStyle(
                          color: AppConstants.textSecondary, // Gris medio
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.commentsCount ?? 0} comentarios',
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.favorite_outline,
                            size: 16,
                            color: AppConstants.errorColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likesCount ?? 0} likes',
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Widget _buildMediaPreview(InstagramPostEntity post) {
    // Determinar si es video o imagen basado en múltiples criterios
    final isVideo = _isVideoContent(post);
    
    // Prioridad: imageUrl para imágenes, videoUrl para videos, luego mediaUrl
    String? mediaUrl;
    if (isVideo) {
      // Para videos, priorizar videoUrl
      if (post.videoUrl != null && post.videoUrl!.isNotEmpty && post.videoUrl!.startsWith('http')) {
        mediaUrl = post.videoUrl;
      } else if (post.mediaUrl.isNotEmpty && post.mediaUrl.startsWith('http')) {
        mediaUrl = post.mediaUrl;
      }
    } else {
      // Para imágenes, priorizar imageUrl
      if (post.imageUrl.isNotEmpty && post.imageUrl.startsWith('http')) {
        mediaUrl = post.imageUrl;
      } else if (post.mediaUrl.isNotEmpty && post.mediaUrl.startsWith('http')) {
        mediaUrl = post.mediaUrl;
      }
    }

    // Si tenemos una URL válida, intentar cargar
    if (mediaUrl != null) {
      if (isVideo) {
        // Para videos, usar VideoThumbnailWidget
        return VideoThumbnailWidget(
          videoUrl: mediaUrl,
          width: 60,
          height: 60,
        );
      } else {
        // Para imágenes, intentar cargar la imagen
        return Image.network(
          mediaUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error al cargar imagen: $mediaUrl - $error');
            return _buildPlaceholder(false);
          },
        );
      }
    }

    // Si no hay URL válida, mostrar placeholder
    return _buildPlaceholder(isVideo);
  }

  bool _isVideoContent(InstagramPostEntity post) {
    // Verificar mediaType
    if (post.mediaType == 'VIDEO' || post.mediaType == 'REEL') {
      return true;
    }
    
    // Verificar si el caption contiene "reel"
    if (post.caption.toLowerCase().contains('reel')) {
      return true;
    }
    
    // Verificar extensiones de archivo en las URLs
    final urls = <String>[];
    if (post.imageUrl.isNotEmpty) urls.add(post.imageUrl);
    if (post.videoUrl != null && post.videoUrl!.isNotEmpty) urls.add(post.videoUrl!);
    if (post.mediaUrl.isNotEmpty) urls.add(post.mediaUrl);
    
    for (final url in urls) {
      if (url.toLowerCase().contains('.mp4') || 
          url.toLowerCase().contains('.mov') || 
          url.toLowerCase().contains('.avi') ||
          url.toLowerCase().contains('.webm')) {
        return true;
      }
    }
    
    return false;
  }

  Widget _buildPlaceholder(bool isVideo) {
    if (isVideo) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF833AB4), Color(0xFFE1306C), Color(0xFFFD1D1D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE1306C).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF833AB4), Color(0xFFE1306C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF833AB4).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.image,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
