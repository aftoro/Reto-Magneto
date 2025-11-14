import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../stories/presentation/providers/stories_provider.dart';
import '../../../stories/data/models/story_entity.dart';
import '../../../../core/constants/app_constants.dart';

class CreatedStoriesPage extends ConsumerStatefulWidget {
  const CreatedStoriesPage({super.key});

  @override
  ConsumerState<CreatedStoriesPage> createState() => _CreatedStoriesPageState();
}

class _CreatedStoriesPageState extends ConsumerState<CreatedStoriesPage> {
  String _selectedStatus = 'created';

  @override
  void initState() {
    super.initState();
    // Cargar stories cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storiesNotifierProvider.notifier).loadStoriesByStatus(status: _selectedStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storiesState = ref.watch(storiesNotifierProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // SliverAppBar con blur glass effect como Chats
          SliverAppBar(
            expandedHeight: 70,
            collapsedHeight: 70,
            pinned: true,
            clipBehavior: Clip.none,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppConstants.textTertiary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // Logo
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                          color: AppConstants.primaryColor.withOpacity(0.1),
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
                              'Stories',
                              style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                        icon: Icon(
                          CupertinoIcons.refresh,
                          color: AppConstants.textSecondary,
                        ),
                              onPressed: () {
                          ref.read(storiesNotifierProvider.notifier).loadStoriesByStatus(status: _selectedStatus);
                              },
                              tooltip: 'Actualizar',
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ),
          
          // Status Filter con estilo Cupertino
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatusChip('created', 'Creadas'),
                    const SizedBox(width: 8),
                    _buildStatusChip('published', 'Publicadas'),
                    const SizedBox(width: 8),
                    _buildStatusChip('pending', 'Pendientes'),
                    const SizedBox(width: 8),
                    _buildStatusChip('failed', 'Fallidas'),
                  ],
                ),
              ),
            ),
          ),
          
          // Stories List
          storiesState.when(
            initial: () => const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando stories...',
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando stories...',
                      style: TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loaded: (stories, total, limit, offset) => stories.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, index == 0 ? 8 : 4, 20, 4),
                          child: _buildStoryCard(stories[index]),
                        );
                      },
                      childCount: stories.length,
                    ),
                  ),
            error: (error) => SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        color: AppConstants.primaryColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar stories',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Verifica tu conexión e intenta de nuevo',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(storiesNotifierProvider.notifier).loadStoriesByStatus(status: _selectedStatus);
                        },
                        icon: const Icon(CupertinoIcons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
        ref.read(storiesNotifierProvider.notifier).loadStoriesByStatus(
          status: status,
          limit: 20,
          offset: 0,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppConstants.primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppConstants.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.book,
              color: AppConstants.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay stories',
            style: GoogleFonts.poppins(
              color: AppConstants.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyMessage(),
            style: GoogleFonts.poppins(
              color: AppConstants.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyMessage() {
    switch (_selectedStatus) {
      case 'created':
        return 'Las stories creadas aparecerán aquí';
      case 'published':
        return 'Las stories publicadas aparecerán aquí';
      case 'pending':
        return 'Las stories pendientes aparecerán aquí';
      case 'failed':
        return 'Las stories fallidas aparecerán aquí';
      default:
        return 'Las stories aparecerán aquí';
    }
  }


  Widget _buildStoryCard(StoryEntity story) {
    final statusColor = _getStatusColor(story.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Abriendo story: ${story.id}'),
                backgroundColor: statusColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Story Preview
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor,
                        statusColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: story.imageUrl.isNotEmpty && story.imageUrl != 'null'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            story.imageUrl,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                print('✅ Imagen cargada exitosamente: ${story.imageUrl}');
                                return child;
                              }
                              print('⏳ Cargando imagen: ${story.imageUrl} - ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes ?? '?'}');
                              return Container(
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('❌ Error cargando imagen de story: $error');
                              print('❌ URL: ${story.imageUrl}');
                              print('❌ StackTrace: $stackTrace');
                              return Container(
                                color: Colors.grey.shade100,
                                child: Icon(
                                  CupertinoIcons.photo,
                                  color: AppConstants.textSecondary,
                                size: 32,
                                ),
                              );
                            },
                          ),
                        )
                      : Builder(
                          builder: (context) {
                            print('⚠️ Story sin imagen o URL vacía: imageUrl="${story.imageUrl}"');
                            return Container(
                              color: Colors.grey.shade100,
                              child: Icon(
                          CupertinoIcons.book,
                                color: AppConstants.textSecondary,
                          size: 32,
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(width: 16),
                // Story Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.aiPrompt ?? 'Story generada con IA',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getStatusLabel(story.status),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (story.aiGenerated)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'IA',
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            color: AppConstants.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(story.createdAt),
                            style: GoogleFonts.poppins(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (story.publishedAt != null) ...[
                            const SizedBox(width: 16),
                            Icon(
                              CupertinoIcons.arrow_up_circle,
                              color: AppConstants.textSecondary,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimestamp(story.publishedAt!),
                              style: GoogleFonts.poppins(
                                color: AppConstants.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.arrow_up_right,
                      color: AppConstants.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Abriendo en Instagram: ${story.id}'),
                          backgroundColor: statusColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      case 'created':
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'published':
        return 'Publicada';
      case 'pending':
        return 'Pendiente';
      case 'failed':
        return 'Fallida';
      case 'created':
      default:
        return 'Creada';
    }
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
}