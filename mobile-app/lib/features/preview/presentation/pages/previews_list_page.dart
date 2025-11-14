import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../data/models/preview_entity.dart';
import '../providers/preview_provider.dart';
import 'preview_corrections_page.dart';
import 'package:video_player/video_player.dart';

class PreviewsListPage extends ConsumerStatefulWidget {
  const PreviewsListPage({super.key});

  @override
  ConsumerState<PreviewsListPage> createState() => _PreviewsListPageState();
}

class _PreviewsListPageState extends ConsumerState<PreviewsListPage>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedType = 'all';
  String _searchQuery = '';
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
    
    // Load initial previews
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(previewsListProvider.notifier).loadPreviews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewsState = ref.watch(previewsListProvider);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), // Icono iOS blanco
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.only(left: 8), // Padding ajustado
          ),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/logo_m.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mis Contenidos',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _showFilters,
              icon: Icon(
                CupertinoIcons.slider_horizontal_3,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF5B1DF4), // Morado Magneto
                  Color(0xFF7C3AED), // Morado más claro
                ],
              ),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Search Bar
                _buildSearchBar(),
                
                // Filters
                _buildFilters(),
                
                // Content
                Expanded(
                  child: _buildContent(previewsState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por tema...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: _searchQuery.isNotEmpty 
                ? const Color(0xFF5B1DF4)
                : Colors.grey.shade500,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF5B1DF4), width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _performSearch();
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterChip(
              'Todos',
              _selectedStatus == 'all',
              () => _setStatus('all'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              'Borradores',
              _selectedStatus == 'draft',
              () => _setStatus('draft'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              'Publicados',
              _selectedStatus == 'published',
              () => _setStatus('published'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B1DF4) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B1DF4) : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF5B1DF4).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContent(PreviewsListState state) {
    if (state is PreviewsListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
        ),
      );
    }
    
    if (state is PreviewsListError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: const Color(0xFF5B1DF4),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar contenidos',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(previewsListProvider.notifier).refreshPreviews();
              },
              icon: const Icon(CupertinoIcons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B1DF4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    if (state is PreviewsListLoaded) {
      if (state.response.previews.isEmpty) {
        return _buildEmptyState();
      }
      
      return _buildPreviewsGrid(state.response.previews);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF5B1DF4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B1DF4).withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.photo,
              color: Color(0xFF5B1DF4),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay contenidos',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer post o story para comenzar',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewsGrid(List<PreviewEntity> previews) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: previews.length,
      itemBuilder: (context, index) {
        final preview = previews[index];
        return _buildPreviewCard(preview);
      },
    );
  }

  Widget _buildPreviewCard(PreviewEntity preview) {
    return GestureDetector(
      onTap: () => _openPreview(preview),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or Video
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: preview.previewImage.isEmpty
                    ? Container(
                        color: Colors.grey.shade50,
                        child: Center(
                          child: _getPreviewTypeIcon(preview.type, size: 32),
                        ),
                      )
                    : preview.type == 'reel' && preview.videoUrl != null && preview.videoUrl!.isNotEmpty
                        ? _buildVideoThumbnail(preview.videoUrl!)
                        : Image.network(
                            preview.previewImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade50,
                                child: Center(
                                  child: _getPreviewTypeIcon(preview.type, size: 32),
                                ),
                              );
                            },
                          ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type and Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: preview.type == 'post' 
                              ? const Color(0xFF3B82F6).withOpacity(0.2)
                              : const Color(0xFF8B5CF6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          preview.type.toUpperCase(),
                          style: TextStyle(
                            color: preview.type == 'post' 
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF8B5CF6),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildStatusChip(preview.status),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Topic
                  Text(
                    preview.topic,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Date
                  Text(
                    _formatDate(preview.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'draft':
        color = Colors.orange;
        label = 'Borrador';
        break;
      case 'published':
        color = Colors.green;
        label = 'Publicado';
        break;
      case 'processing':
        color = Colors.blue;
        label = 'Procesando';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _performSearch();
  }

  void _setStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
    _loadPreviews();
  }

  void _performSearch() {
    _loadPreviews();
  }

  void _loadPreviews() {
    ref.read(previewsListProvider.notifier).loadPreviews(
      status: _selectedStatus == 'all' ? null : _selectedStatus,
      type: _selectedType == 'all' ? null : _selectedType,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filtros',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            // Add filter options here
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B1DF4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }

  void _openPreview(PreviewEntity preview) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewCorrectionsPage(
          preview: preview,
          suggestedCorrections: [], // Load from API if needed
        ),
      ),
    );
  }

  Widget _getPreviewTypeIcon(String type, {double size = 32}) {
    String iconPath;
    switch (type.toLowerCase()) {
      case 'reel':
        iconPath = 'assets/icons/reel.svg';
        break;
      case 'story':
        iconPath = 'assets/icons/storie.svg';
        break;
      case 'post':
      default:
        iconPath = 'assets/icons/media.svg';
        break;
    }
    
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        Colors.grey.shade600,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoUrl) {
    return _VideoThumbnailStatefulWidget(videoUrl: videoUrl);
  }
}

class _VideoThumbnailStatefulWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoThumbnailStatefulWidget({required this.videoUrl});

  @override
  State<_VideoThumbnailStatefulWidget> createState() => _VideoThumbnailStatefulWidgetState();
}

class _VideoThumbnailStatefulWidgetState extends State<_VideoThumbnailStatefulWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..setLooping(false)
        ..setVolume(0.0);
      
      _controller!.addListener(() {
        if (_controller!.value.isInitialized && mounted) {
          setState(() {
            _isInitialized = true;
            _hasError = false;
          });
        }
        if (_controller!.value.hasError && mounted) {
          setState(() {
            _hasError = true;
            _isInitialized = false;
          });
        }
      });

      // Reducir timeout a 5 segundos para que falle más rápido y muestre placeholder
      await _controller!.initialize().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );
      
      // Ir al primer frame
      await _controller!.seekTo(Duration.zero);
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      print('Error inicializando thumbnail de video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
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
    return Stack(
      children: [
        if (_isInitialized && !_hasError && _controller != null)
          // Mostrar el primer frame del video
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          )
        else if (_hasError)
          // Error state
          Container(
            color: Colors.grey.shade50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error al cargar video',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Loading state - mostrar placeholder más rápido
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white70,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Video',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Play button overlay (siempre visible)
        Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
