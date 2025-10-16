import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../stories/presentation/providers/stories_provider.dart';
import '../../../stories/data/models/story_entity.dart';

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
      ref.read(storiesNotifierProvider.notifier).loadStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storiesState = ref.watch(storiesNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stories Creadas',
                            style: TextStyle(
                              color: Color(0xFFE5E7EB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Tus stories publicadas en Instagram',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stats Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2D2D2D),
                          width: 1,
                        ),
                      ),
                      child: storiesState.when(
                        initial: () => const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF8B5CF6),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '0 stories',
                              style: TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Cargando...',
                              style: TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        loaded: (stories, total, limit, offset) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF8B5CF6),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$total stories',
                              style: const TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        error: (error) => const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Color(0xFFEF4444),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Error',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Filter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              
              // Stories List
              Expanded(
                child: storiesState.when(
                  initial: () => const Center(
                    child: Text(
                      'Cargando stories...',
                      style: TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                    ),
                  ),
                  loaded: (stories, total, limit, offset) => stories.isEmpty
                      ? _buildEmptyState()
                      : _buildStoriesList(stories),
                  error: (error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppConstants.errorColor,
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        const Text(
                          'Error al cargar stories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Text(
                          error,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.spacingL),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(storiesNotifierProvider.notifier).refreshStories();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        ref.read(storiesNotifierProvider.notifier).loadStoriesByStatus(status: status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF4B5563),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.auto_stories_outlined,
              size: 48,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyMessage(),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
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

  Widget _buildStoriesList(List<StoryEntity> stories) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(story);
      },
    );
  }

  Widget _buildStoryCard(StoryEntity story) {
    final statusColor = _getStatusColor(story.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                  child: story.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            story.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.auto_stories,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.auto_stories,
                          color: Colors.white,
                          size: 32,
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
                        style: const TextStyle(
                          color: Color(0xFFE5E7EB),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                            Icons.schedule,
                            color: const Color(0xFF6B7280),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(story.createdAt),
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          if (story.publishedAt != null) ...[
                            const SizedBox(width: 16),
                            Icon(
                              Icons.publish,
                              color: const Color(0xFF6B7280),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimestamp(story.publishedAt!),
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
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
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.open_in_new,
                      color: Color(0xFF9CA3AF),
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